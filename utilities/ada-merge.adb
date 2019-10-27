with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Directories;

procedure Ada_Merge is

   txt : File_Type;

   max_recurse_depth : Constant := 10;
   recurse_depth     : Integer;

   src_file_name : String := read_command_arg ('i',"<no-source>.adt");
   out_file_name : String := read_command_arg ('o',"<no-output>.adb");

   comment       : String := read_command_arg ('C',"--"); -- the comment marker, default is Ada --

   silent        : Boolean := find_command_arg ('S');  -- true: do not wrap include text in beg/end pairs
   markup        : Boolean := not silent;              -- true:     do wrap include text in beg/end pairs
   indent        : Boolean := find_command_arg ('I');  -- true: match indent to indent of {$include...}

   max_file_len  : Constant := 255;
   initial_path  : String (1 .. max_file_len);
   first_line    : String (1 .. max_file_len);
   last_line     : String (1 .. max_file_len);

   function File_Exists (the_file_name : string) return boolean renames Ada.Directories.Exists;

   procedure include_files (file_path  : in out String;
                            file_name  : in out String;
                            the_indent : in     Integer)
   is

      src        : File_Type;
      j          : Integer;
      found      : Boolean;
      new_indent : Integer;
      the_path   : String (1 .. max_file_len);
      the_file   : String (1 .. max_file_len);
      inc_file   : String (1 .. max_file_len);

      num_dash_max : Integer := 91;  -- line width for beg/end comment lines

      function not_comment (the_line : String) return Boolean is
         re_comment : String := "^\s*--";
      begin
         return (not grep (the_line, re_comment));
      end not_comment;

      procedure read_include_name (file_name : in out String; found : out Boolean; the_line : String)
      is
         re_file_name : String := "\{\$include[\t| ]+""([_a-zA-Z0-9./-]+)""\}";
      begin
         grep (file_name,found,the_line,re_file_name,1);
      end read_include_name;

      function read_include_indent (the_line : String) return Integer is
      begin
         if indent then
            for i in 1 .. the_line'last loop
               if the_line(i) = '{' then
                  return i-1;
               end if;
            end loop;
         end if;
         return 0;
      end read_include_indent;

      procedure standard_form (the_path : in out String; the_file : in out String)
      is
         re_path_file : String := "[\t ]*([_a-zA-Z0-9./-]*\/)([_a-zA-Z0-9.-]+)";
         tmp : String (1..the_path'last+the_file'last+1);
      begin
         writestr (tmp,cut(the_path)&cut(the_file));
         writestr (the_path, trim ( grep (tmp,re_path_file,1,fail => "") ));
         writestr (the_file, trim ( grep (tmp,re_path_file,2,fail => "<no-file>") ));
      end standard_form;

   begin
      recurse_depth := recurse_depth + 1;
      if recurse_depth > max_recurse_depth then
         Put_Line ("> ada-merge: Too many levels of include, exit");
         halt(1);
      end if;
      standard_form (file_path, file_name);
      Open (src, In_File, cut(file_path) & cut(file_name));
      loop
         begin
            declare
               the_line : String := Get_Line (src);
            begin
               if not_comment (the_line) then
                  read_include_name (inc_file, found, the_line);
                  if found then
                     new_indent := the_indent + read_include_indent (the_line);
                     writestr (the_file, inc_file);
                     writestr (the_path, file_path);
                     standard_form (the_path, the_file);
                     if not File_Exists (cut(the_path) & cut(the_file)) then
                        Put_Line ("> ada-merge: Include file "&cut(the_path)&cut(the_file)&" not found, exit.");
                        halt(1);
                     end if;
                     j := num_dash_max - get_strlen (the_path) - get_strlen (the_file) - new_indent;
                     if markup then
                        for i in 1 .. new_indent loop
                           Put (txt, ' ');
                        end loop;
                        Put (txt, comment&" beg: " & cut (the_path) & cut (the_file) & ' ');
                        for i in 1 .. j loop
                           Put (txt, '-');
                        end loop;
                        New_Line (txt);
                        include_files (the_path, the_file, new_indent);
                        for i in 1 .. new_indent loop
                           Put (txt, ' ');
                        end loop;
                        Put (txt, comment&" end: " & cut (the_path) & cut (the_file) & ' ');
                        for i in 1 .. j loop
                           Put (txt, '-');
                        end loop;
                        New_Line (txt);
                     else
                        include_files (the_path, the_file, new_indent);
                     end if;
                  else
                     for i in 1 .. the_indent loop
                        Put (txt, ' ');
                     end loop;
                     Put_Line (txt, cut (the_line));
                  end if;
               else
                  for i in 1 .. the_indent loop
                     Put (txt, ' ');
                  end loop;
                  Put_Line (txt, cut (the_line));
               end if;
            end;
         exception
            when end_error => exit;
         end;
      end loop;
      Close (src);
      recurse_depth := recurse_depth - 1;
   end include_files;

   procedure show_info is
   begin

      Put_Line ("------------------------------------------------------------------------------");
      Put_Line (" Merges a set of Ada files into a single file.");
      Put_Line (" Usage:");
      Put_Line ("    ada-merge -i <source> -o <output> [-hSC]");
      Put_Line (" Files:");
      Put_Line ("    <source> : the source that may contain include statements in the form");
      Put_Line ("               ${include ""file-name""}");
      Put_Line ("    <output> : the merged file");
      Put_Line (" Options:");
      Put_Line ("    -h : help, show this help message, then exit");
      Put_Line ("    -I : indent, add indentation to match ident of {$include ...}");
      Put_Line ("    -S : silent, do not wrap included text in beg/end pairs");
      Put_Line ("    -Ctext : Use 'text' as a comment marker, the default is --");
      Put_Line (" Example:");
      Put_Line ("    ada-merge -i driver.adt -o merged.adb");
      Put_Line ("------------------------------------------------------------------------------");

   end show_info;

   procedure initialize is
   begin

      if find_command_arg ('h') then
         show_info;
         halt(0);
      end if;

      if not find_command_arg ('i') then
         show_info;
         halt(0);
      end if;

      if not find_command_arg ('o') then
         show_info;
         halt(0);
      end if;

      if src_file_name = out_file_name
      then
         Put_Line ("> ada-merge: Indentical files names for input and output, exit.");
         halt(1);
      end if;

      if not File_Exists (src_file_name) then
         Put_Line ("> ada-merge: Source file """ & cut (src_file_name) & """ not found, exit.");
         halt(1);
      end if;

   end initialize;

begin

   initialize;

   -- copy the source to the output, but with {$include ...} fully expanded

   Create (txt, Out_File, out_file_name);

   if src_file_name (1) = '/'
      then writestr (initial_path, "");
      else writestr (initial_path, "./");
   end if;

   recurse_depth := 0;

   if markup then

      -- use "--!" so that ada-split can ignore these lines

      Put_Line (txt,"--! ------------------------------------------------------------");
      Put_Line (txt,"--!  Do not edit this file, it was created by ada-merge from:");
      Put_Line (txt,"--!     "&src_file_name);
      Put_Line (txt,"--! ------------------------------------------------------------");

      if src_file_name (1) = '/' then
         writestr (first_line,comment&" src: " & src_file_name);
         writestr (last_line, comment&" end: " & src_file_name);
      else
         writestr (first_line,comment&" src: ./" & src_file_name);
         writestr (last_line, comment&" end: ./" & src_file_name);
      end if;

      Put_Line (txt, cut(first_line));
      include_files (initial_path, src_file_name, 0);
      Put_Line (txt, cut(last_line));

   else
      include_files (initial_path, src_file_name, 0);
   end if;

   Close (txt);

end Ada_Merge;
