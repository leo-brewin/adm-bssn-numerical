with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Directories;

procedure Ada_Split is

   max_file_len : constant := 255;

   type status_type is (file_beg, file_end, file_src, normal, ignore);

   src_file_name : String := read_command_arg ('i',"<no-source>.adb");
   out_file_name : String := read_command_arg ('o',"<no-output>.adt");

   comment       : String := read_command_arg ('C',"--"); -- the comment marker, default is Ada

   inp : File_Type;

   function File_Exists (the_file_name : string) return boolean renames Ada.Directories.Exists;

   procedure parse_line
     (new_dir_name  : in out String;
      new_file_name : in out String;
      status        : out status_type;
      the_line      : String)
   is

      re_ignore : String := "^--!";
      re_beg    : String := "^[\t ]*"&comment&" *beg: *([_a-zA-Z0-9./-]+\/)([_a-zA-Z0-9.-]+)";
      re_src    : String := "^[\t ]*"&comment&" *src: *";
      re_end    : String := "^[\t ]*"&comment&" *end: *";

   begin

      Writestr (new_dir_name, "?");
      Writestr (new_file_name, "?");

      if    grep (the_line,re_ignore) then status := ignore;
      elsif grep (the_line,re_src)    then status := file_src;
      elsif grep (the_line,re_end)    then status := file_end;
      elsif grep (the_line,re_beg) then
         status := file_beg;
         writestr (new_dir_name, trim ( grep (the_line,re_beg,1,fail => "") ));
         writestr (new_file_name,trim ( grep (the_line,re_beg,2,fail => "<no-file>") ));
      else
         status := normal;
      end if;

   end parse_line;

   procedure get_path (rel_path : in out String; new_dir_name : String; old_dir_name : String)
   is
      the_beg, the_end : Integer;
   begin
      null_string (rel_path);
      the_beg := get_strlen (old_dir_name) + 1;
      the_end := get_strlen (new_dir_name);
      writestr (rel_path,new_dir_name(the_beg..the_end));
      trim (rel_path);
   end get_path;

   procedure write_file (dir_name : String; file_name : String)
   is
      txt           : File_Type;
      reading       : Boolean;
      status        : status_type;
      new_dir_name  : String (1 .. max_file_len);
      new_file_name : String (1 .. max_file_len);
      relative_path : String (1 .. max_file_len);
      full_name     : String (1 .. max_file_len);
   begin

      writestr (full_name, trim (cut(dir_name) & cut(file_name)));

      if get_strlen (dir_name) > 0 then
         Ada.Directories.Create_Path (cut(dir_name));
      end if;

      Create (txt, Out_File, full_name);

      reading := True;

      loop
         begin

            declare
               the_line : String := Get_Line (inp);
            begin

               parse_line (new_dir_name, new_file_name, status, the_line);

               case status is

                  when file_end =>
                     Close (txt);
                     reading := False;

                  when file_beg =>
                     get_path (relative_path, new_dir_name, dir_name);
                     Put_Line (txt, "{$include """ & cut (relative_path) & cut (new_file_name) & """}");
                     write_file (new_dir_name, new_file_name);

                  when normal =>
                     Put_Line (txt, cut (the_line));

                  when file_src =>
                     null; -- do nothing, skips first line in the file if it begins with "-- src: ."

                  when ignore =>
                     null; -- skip lines that begins with "--!"

               end case;

            end;

            exit when not reading;

         exception
            when end_error => exit;
         end;
      end loop;

      -- this is probably not needed, but just to be sure

      if reading then
         Close (txt);
      end if;

   end write_file;

   procedure show_info is
   begin

      Put_Line ("------------------------------------------------------------------------------");
      Put_Line (" Splits a merged set of Ada files into its component files.");
      Put_Line (" Usage:");
      Put_Line ("    ada-split [-h] -i <source> -o <output>");
      Put_Line (" Files:");
      Put_Line ("    <source> : the merged set of files");
      Put_Line ("    <output> : a new file that can be reused via ada-merge to");
      Put_Line ("               recover the <source>");
      Put_Line (" Options:");
      Put_Line ("    -h : help, show this help message, then exit");
      Put_Line (" Example:");
      Put_Line ("    ada-split -i merged.adb -o driver.adt");
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
         Put_Line ("> ada-split: Indentical files names for input and output, exit.");
         halt(1);
      end if;

      if not File_Exists (src_file_name) then
         Put_Line ("> ada-split: Source file """ & src_file_name & """ not found, exit.");
         halt(1);
      end if;

   end initialize;

begin

   initialize;

   Open (inp, In_File, src_file_name);

   write_file ("", out_file_name);

end Ada_Split;
