with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Directories;

procedure Ada_Merge is

   txt : File_Type;

   max_recurse_depth : Constant := 10;
   recurse_depth     : Integer  := 0;

   src_file_name : String := read_command_arg ('i',"<no-source>");
   out_file_name : String := read_command_arg ('o',"<no-output>");

   silent        : Boolean := find_command_arg ('S');  -- true: do not wrap include text in beg/end pairs
   markup        : Boolean := not silent;              -- true:     do wrap include text in beg/end pairs

   function File_Exists (the_file_name : string) return boolean renames Ada.Directories.Exists;

   procedure include_files
     (prev_path   : String;
      this_line   : String;
      prev_indent : Integer)
   is

      -- allow simple variations of the Input syntax:
      --    \Input for TeX, use \Input to avoid confusion with \input
      --    $Input for Ada/Python/Cadabra
      -- note that this is only for convenience, the comment string will be deduced
      -- from the file extension of the Input'ed file
      re_inc_file : String := "^[\t ]*(\\|\$)Input\{""([_a-zA-Z0-9./-]+)""\}";

      -- this function is not used
      function not_tex_comment
        (the_line : String)
         return     Boolean
      is
         re_tex_comment : String := "^\s*%";
      begin
         return (not grep (the_line, re_tex_comment));
      end not_tex_comment;

      function is_include_file
        (the_line : String)
         Return     Boolean
      is
      begin
         return grep (the_line,re_inc_file);
      end is_include_file;

      function absolute_path
        (the_path : String;    -- full path to most recent include file, e.g. foo/bah/cow.tex
         the_line : String)    -- contains relative path to new include file, e.g., \Input{"cat/dot/fly.tex"}
         Return     String     -- full path to new include file, e.g., foo/bah/cat/dog/fly.tex
      is
         re_dirname  : String := "([_a-zA-Z0-9./-]*\/)";      -- as per dirname in bash
         tmp_path : String (1..the_path'last+the_line'last);  -- overestimate length of string
         new_path : String (1..the_path'last+the_line'last);
      begin
         -- drop the simple file name from the existing path
         writestr (tmp_path, trim ( grep (the_path,re_dirname,1,fail => "") ));
         -- append new file path to the path
         writestr (new_path, cut(tmp_path)&trim ( grep (the_line,re_inc_file,2,fail => "") ));
         return cut(new_path);
      end absolute_path;

      function absolute_indent
        (indent   : Integer;
         the_line : String)
         Return     Integer
      is
         start : Integer;
      begin
         start := 0;
         for i in the_line'Range loop
            if the_line (i) /= ' ' then
               start := max(0,i-1);
               exit;
            end if;
         end loop;
         return indent + start;
      end absolute_indent;

      function set_comment (the_line : String) return String
      is
         re_file_ext : String := "(\.[a-z]+)""";
         the_ext     : String := grep (the_line,re_file_ext,1,fail => "?");
      begin
         if markup then
            if    the_ext = ".tex" then return "%";
            elsif the_ext = ".py"  then return "#";
            elsif the_ext = ".cdb" then return "#";
            elsif the_ext = ".ads" then return "--";
            elsif the_ext = ".adb" then return "--";
            elsif the_ext = ".adt" then return "--";
            elsif the_ext = ".ad"  then return "--";
            else return "#";
            end if;
         else
            return "#";
         end if;
      end set_comment;

      function filter (the_line : String) return String
      is
         tmp_line : String := the_line;
         re_uuid  : String := "(uuid):([a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12})";
         the_beg, the_end : Integer;
         found : Boolean;
      begin
         -- "uuid" is reserved for the original source
         -- the new file being created by this job must use a prefix other than "uuid"
         -- replace the prefix "uuid" with "file"
         if regex_match (the_line, re_uuid) then
            grep (the_beg, the_end, found, the_line, re_uuid, 1);
            tmp_line (the_beg..the_end) := "file";
         end if;
         return tmp_line;
      end filter;

   begin

      recurse_depth := recurse_depth + 1;

      if recurse_depth > max_recurse_depth then
         Put_Line ("> merge-src: Too many nested Input{...}'s (max = "&str(max_recurse_depth)&"), exit");
         halt(1);
      end if;

      declare
         src        : File_Type;
         the_path   : String  := absolute_path (prev_path, this_line);
         the_indent : Integer := absolute_indent (prev_indent, this_line);
         comment    : String  := set_comment (this_line);
      begin

         if markup then
            Put_Line (txt, spc(the_indent)&comment&" beg"&make_str(recurse_depth,2)&": ./" & the_path);
         end if;

         if File_Exists (the_path)
            then Open (src, In_File, the_path);
            else raise Name_Error with "Could not find the file "&""""&str(the_path)&"""";
         end if;

         loop
            begin
               declare
                  the_line : String := filter (Get_Line (src));
               begin
                  if is_include_file (the_line)
                     then include_files (the_path, the_line, the_indent);
                     else Put_Line (txt, spc(the_indent)&the_line);
                  end if;
               end;
            exception
               when end_error => exit;
            end;
         end loop;

         Close (src);

         if markup then
            Put_Line (txt, spc(the_indent)&comment&" end"&make_str(recurse_depth,2)&": ./" & the_path);
         end if;

      end;

      recurse_depth := recurse_depth - 1;

   end include_files;

   procedure show_info is
   begin

      Put_Line ("------------------------------------------------------------------------------");
      Put_Line (" Merges a set of source files into a single file.");
      Put_Line (" Usage:");
      Put_Line ("    merge-src -i <source> -o <output> [-hS]");
      Put_Line (" Files:");
      Put_Line ("    <source> : the source that may contain include statements in the form");
      Put_Line ("               \Input{file-name}");
      Put_Line ("    <output> : the merged file");
      Put_Line (" Options:");
      Put_Line ("    -h : help, show this help message, then exit");
      Put_Line ("    -S : silent, do not wrap included text in beg/end pairs");
      Put_Line (" Example:");
      Put_Line ("    merge-src -i driver.tex -o merged.tex");
      Put_Line ("------------------------------------------------------------------------------");

   end show_info;

   procedure initialize is
   begin

      if find_command_arg ('h') then
         show_info;
         halt(0);
      end if;

      if src_file_name = out_file_name
      then
         Put_Line ("> merge-src: Indentical files names for input and output, exit.");
         halt(1);
      end if;

      if not File_Exists (src_file_name) then
         Put_Line ("> merge-src: Source file """ & cut (src_file_name) & """ not found, exit.");
         halt(1);
      end if;

   end initialize;

begin

   initialize;

   -- copy the source to the output, but with \Input{...} fully expanded

   Create (txt, Out_File, out_file_name);

   include_files ("", "\Input{"""&src_file_name&"""}", 0);

   Close (txt);

   if recurse_depth /= 0 then
      Put_Line("> merge-src: error during merger");
      Put_Line("> recursion depth should be zero, actual value: "&str(recurse_depth));
   end if;

end Ada_Merge;
