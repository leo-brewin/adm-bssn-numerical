with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Strings.Unbounded;                     use Ada.Strings.Unbounded;
with Ada.Directories;

procedure Ada_Split is

   src : File_Type;

   max_recurse_depth : Constant := 10;
   recurse_depth     : Integer  := 0;

   src_file_name : String := read_command_arg ('i',"<no-source>");
   out_file_name : String := read_command_arg ('o',"<no-output>");

   type tag_type is (beg_tag, end_tag, neither);

   function Path_Exists (the_path_name : string) return boolean renames Ada.Directories.Exists;
   function File_Exists (the_file_name : string) return boolean renames Ada.Directories.Exists;

   procedure write_file
      (parent : String;   -- "   -- beg03: foo/bah/cat.tex"
       child  : String)   -- "      --- beg04: foo/bah/moo/cow/dog.tex"
   is

      re_beg_tag : String := "^[\t ]*(--|#|%) beg[0-9]{2}:";
      re_end_tag : String := "^[\t ]*(--|#|%) end[0-9]{2}:";

      function full_dir (text : String) return String is  -- text := "  -- beg01: ./foo/bah/cat.tex"
         re_dirname : String := "([_a-zA-Z0-9./-]*\/)";   -- as per dirname in bash
      begin
         return grep (text,re_dirname,1,fail => "");      -- returns "./foo/bah/"
      end full_dir;

      function full_file (text : String) return String is -- text := "  -- beg01: ./foo/bah/cat.tex"
         re_file : String := re_beg_tag & " (.+)";
      begin
         return grep (text,re_file,2,fail => "");         -- returns "./foo/bah/cat.tex"
      end full_file;

      function relative_path
        (parent : String;    -- "   -- beg03: foo/bah/cat.tex"
         child  : String)    -- "      -- beg04: foo/bah/moo/cow/dog.tex"
         Return   String     -- relative path of the child to the parent, e.g., "moo/cow/dog.tex"
      is
         re_dirname  : String := "([_a-zA-Z0-9./-]*\/)";                  -- as per dirname in bash
         re_basename : String := re_beg_tag & " " &re_dirname & "(.+)";   -- as per basename in bash
         parent_dir  : String := trim ( grep (parent,re_dirname,1,fail => "./") );        -- "foo/bah/"
         child_dir   : String := trim ( grep (child,re_dirname,1,fail => "./") );         -- "foo/bah/moo/cow/"
         child_file  : String := trim ( grep (child,re_basename,3,fail => "??.txt") );    -- "dog.tex"
      begin
         -- strip parent_directory from front of child
         return trim ( child_dir(child_dir'first+get_strlen(parent_dir)..child_dir'last)&str(child_file) );  -- "moo/cow/dog.tex"
      end relative_path;

      function absolute_indent (text : String) return Integer is
         indent : Integer;
      begin
         indent := 0;
         for i in text'Range loop
            if text (i) /= ' ' then
               indent := max(0,i-1);
               exit;
            end if;
         end loop;
         return indent;
      end absolute_indent;

      function relative_indent
        (parent : String;
         child  : String)
         Return   Integer
      is
      begin
         return absolute_indent(child) - absolute_indent(parent);
      end relative_indent;

      function classify (the_line : String) return tag_type is
      begin
         if    grep (the_line,re_beg_tag) then return beg_tag;
         elsif grep (the_line,re_end_tag) then return end_tag;
                                          else return neither;
         end if;
      end classify;

   begin

      recurse_depth := recurse_depth + 1;

      if recurse_depth > max_recurse_depth then
         Put_Line ("> split-mrg: Recursion limit reached (max = "&str(max_recurse_depth)&"), exit");
         halt(1);
      end if;

      declare
         txt        : File_Type;
         the_dir    : String  := full_dir (child);
         the_file   : String  := full_file (child);
         the_path   : String  := relative_path (parent, child);
         the_indent : Integer := absolute_indent (child);

         procedure write_path (parent : String; child : String) is
            the_path : String := relative_path (parent, child);
            the_indent : Integer := relative_indent (parent, child);
         begin
            put_line (txt,spc(the_indent)&"$Input{"""&the_path&"""}");
         end write_path;

         procedure write_line (the_line : String; the_indent : Integer) is
         begin
            if the_indent > get_strlen(the_line)
               then put_line (txt, str(the_line));
               else put_line (txt, str(the_line(the_indent+1..the_line'last)));
            end if;
         end write_line;

      begin

         if not Path_Exists (the_dir) then
            Ada.Directories.Create_Path (the_dir);
         end if;

         if File_Exists (the_file)
            then   Open (txt, out_file, the_file);
            else Create (txt, out_file, the_file);
         end if;

         loop
            begin
               declare
                  the_line : String := Get_Line (src);
               begin
                  case classify (the_line) is
                     when beg_tag => write_path (child, the_line);
                                     write_file (child, the_line);
                     when end_tag => exit;
                     when others  => write_line (the_line, the_indent);
                  end case;
               end;
            exception
               when end_error => exit;
            end;
         end loop;

         Close (txt);

      end;

      recurse_depth := recurse_depth - 1;

   end write_file;

   procedure show_info is
   begin

      Put_Line ("------------------------------------------------------------------------------");
      Put_Line (" Splits a previously merged source into its component files.");
      Put_Line (" Usage:");
      Put_Line ("    split-mrg -i <source> [-o <output>] [-h]");
      Put_Line (" Files:");
      Put_Line ("    <source> : the merged source, must contain merge markup lines like");
      Put_Line ("               -- beg03: ./foo/bah/cow.ad");
      Put_Line ("    <output> : optional, use this to avoid overwriting original source template");
      Put_Line (" Options:");
      Put_Line ("    -h : help, show this help message, then exit");
      Put_Line (" Example:");
      Put_Line ("    split-mrg -i foo.adb");
      Put_Line ("    split-mrg -i foo.adb -o bah.adt");
      Put_Line ("------------------------------------------------------------------------------");

   end show_info;

   procedure initialize is
   begin

      if find_command_arg ('h') then
         show_info;
         halt(0);
      end if;

      if not File_Exists (src_file_name) then
         Put_Line ("> split-mrg: Source file """ & cut (src_file_name) & """ not found, exit.");
         halt(1);
      end if;

   end initialize;

begin

   initialize;

   -- split the merged source into its component parts

   Open (src, In_File, src_file_name);

   if find_command_arg ('o') then
      Skip_Line (src);
      write_file ("-- beg01: ./", "-- beg01: ./"&out_file_name);
   else
      write_file ("-- beg01: ./", Get_Line(src));
   end if;

   Close (src);

   if recurse_depth /= 0 then
      Put_Line("> split-mrg: error during split");
      Put_Line("> recursion depth should be zero, actual value: "&str(recurse_depth));
   end if;

end Ada_Split;
