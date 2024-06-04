with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Characters.Latin_1;

procedure cdb2ada is

   target_line_length : constant := 256;  -- target length of outputlines
                                          -- will split at whitepace, short overruns possible

   src_file_name  : String := read_command_arg ("-i","foo.c");
   txt_file_name  : String := read_command_arg ("-o","foo.ad");
   ads_file_name  : String := read_command_arg ("-s","foo.ads");
   procedure_name : String := read_command_arg ("-P","foo");  -- can embed proc. args in name
   function_name  : String := read_command_arg ("-F","foo");  -- ditto
   return_name    : String := read_command_arg ("-r","bah");
   before_begin   : String := read_command_arg ("-b","");  -- add extra text before the body

   is_function    : Boolean := find_command_arg ("-F");
   is_procedure   : Boolean := not is_function;

   write_ada_spec : Boolean := find_command_arg ("-s");  -- write a matching .ads file

   local_var_prefix : Character := read_command_arg ("-v",'x');  -- local vars will be x1, x2, ... x123, ...

   -----------------------------------------------------------------------------

   procedure rewrite_code is
      txt          : File_Type;
      ads          : File_Type;
      src          : File_Type;
      start_line   : Boolean;
      finished     : Boolean;
      this_lead_in : Integer;
      break_at     : integer;
      found_at     : integer;
      found        : Boolean;
      beg_at       : integer;
      end_at       : integer;
      var_beg      : integer;
      var_end      : integer;
      rhs_beg      : integer;
      rhs_end      : integer;
      tail_beg     : integer;
      tail_end     : integer;
      max_names_width : Integer;

      procedure write_procedure_begin is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         the_name : String := grep (procedure_name, re_name, 1, fail => "no_procedure_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         Put_Line (txt, "Procedure "&the_name&" is");

         if write_ada_spec then
            Put_Line (ads, "Procedure "&the_name&";");
         end if;

      end write_procedure_begin;

      procedure write_procedure_end is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         the_name : String := grep (procedure_name, re_name, 1, fail => "no_procedure_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         Put_Line (txt, "end "&the_name&";");
         New_Line (txt);

      end write_procedure_end;

      procedure write_function_begin is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         -- the_name : String := function_name;   -- was this, but this must be wrong?
         the_name : String := grep (function_name, re_name, 1, fail => "no_function_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         Put_Line (txt, "Function "&the_name&" is");

         if write_ada_spec then
            Put_Line (ads, "Function "&the_name&";");
         end if;

      end write_function_begin;

      procedure write_function_end is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         the_name : String := grep (function_name, re_name, 1, fail => "no_function_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         -- New_Line (txt);
         Put_Line (txt, "   return "&return_name&";");
         -- New_Line (txt);
         Put_Line (txt, "end "&the_name&";");
         New_Line (txt);

      end write_function_end;

      function is_local_var (this_name : String) return Boolean is
      begin
         if this_name (this_name'First) = local_var_prefix
            then return True;
            else return False;
         end if;
      end is_local_var;

      procedure add_declarations is

         src       : File_Type;
         count     : integer;
         max_count : integer;
         width     : integer;
         target    : integer;
         lead_in   : integer;
         num_chars : integer;
         num_names : Integer;
         max_width : Integer;

         type action_list is (wrote_xvar, wrote_type, wrote_space);
         last_action : action_list;

      begin

         -- first pass: count the number of names and record max width

         Open (src, In_File, src_file_name);

         num_names := 0;  -- number of local var names (including duplicates)
         max_width := 0;  -- maximum width of the names

         loop
            begin
               declare
                  re_lhs    : String := "^ *([a-zA-Z0-9_(), ]+) +=";
                  this_line : String := get_line (src);
                  this_name : String := grep (this_line, re_lhs, 1, fail => "<no-match 1>");
               begin
                  -- count only the local var names
                  if this_line'length > 0 then
                     if is_local_var (this_name) then
                        num_names := num_names + 1;
                        max_width := max (max_width, this_name'length);
                     end if;
                  end if;
               end;
            exception
               when end_error => exit;
            end;
         end loop;

         max_names_width := max_width+1;

         Close (src);

         declare

            max_name_length : Integer := 25;
            num_unique_names : Integer;

            unique_names : Array (1..num_names) of String (1..max_name_length) := (others => (others => Ada.Characters.Latin_1.NUL));

            function in_list (name : String) return Boolean is
            begin
               for i in 1 .. num_unique_names loop
                  if str_match(name, unique_names (i)) then
                     return True;
                  end if;
               end loop;
               return False;
            end in_list;

            procedure add_to_list (name : String) is
            begin
               if get_strlen (name) > max_name_length then
                  raise CONSTRAINT_ERROR with "c2ada: name "&cut(name)&" too long, max = "&str(max_name_length);
               else
                  num_unique_names := num_unique_names + 1;
                  writestr (unique_names (num_unique_names), name);
               end if;
            end add_to_list;

         begin

            -- second pass get a list of *unique* var names

            Open (src, In_File, src_file_name);

            num_unique_names := 0;

            loop
               begin
                  declare
                     re_lhs    : String := "^ *([a-zA-Z0-9_(), ]+) +=";
                     this_line : String := get_line (src);
                     this_name : String := grep (this_line, re_lhs, 1, fail => "<no-match 2>");
                  begin
                     -- build a list of unique local var names
                     if this_line'length > 0 then
                        if is_local_var (this_name) then
                           if not in_list (this_name) then
                              add_to_list (this_name);
                           end if;
                        end if;
                     end if;
                  end;
               exception
                  when end_error => exit;
               end;
            end loop;

            Close (src);

            -- third pass, write out declarations for all names

            if num_names /= 0 then

               width   := max_width+2;  -- +2 = +1 for the comma and +1 for the space
               lead_in := 3;            -- whitespace at start of each line

               target  := 85;           -- max length of a line

               count     := 0;          -- number of names written in this block
               max_count := 250;        -- max number of names in any one block
                                        -- avoids gant crash -- too many names before the type decalaration

               Put (txt, spc (lead_in));
               num_chars := lead_in;

               for i in 1 .. num_unique_names loop
                  begin
                     declare
                        this_name : String := cut(unique_names(i));
                     begin
                        if is_local_var (this_name) then

                           if (count < max_count) then
                              if i /= num_unique_names
                                 then Put (txt, str (cut (this_name) & ",", width, pad=>' '));
                                 else Put (txt, str (cut (this_name)));
                              end if;
                              num_chars := num_chars + width;
                              count := count + 1;
                              last_action := wrote_xvar;
                           else
                              Put (txt, str (cut (this_name) & " : Real;", width+6 ,pad=>' '));
                              count := 0;
                              last_action := wrote_type;
                           end if;

                           if i /= num_unique_names then
                              if (num_chars > target) or (count = 0) then
                                 New_Line (txt);
                                 Put (txt, spc (lead_in));
                                 num_chars := lead_in;
                                 last_action := wrote_space;
                              end if;
                           end if;

                        end if;

                     end;
                  end;

               end loop;

               if last_action /= wrote_type then
                  Put_Line (txt, " : Real;");
               end if;

               -- New_Line (txt);  -- new line at end of declarations

            end if;

            -- use -bfoo to add the text "foo" after the declarations
            -- and just before the begin block
            -- this can be used to squeeze in extra code

            if find_command_arg ("-b") then
               Put (txt, spc (lead_in));
               Put (txt, before_begin);
               New_Line (txt);
            end if;

         end;

      end add_declarations;

      procedure find_equal_sign
        (found     : out Boolean;
         found_at  : out Integer;
         this_line :     String)
      is
      begin

         found := false;
         found_at := this_line'length+1;

         for i in this_line'range loop
            if this_line (i) = '=' then
               found := true;
               found_at := i;
               exit;
            end if;
         end loop;

      end find_equal_sign;

      procedure find_break
        (found_at  : out Integer;
         beg_at    :     Integer;
         end_at    :     Integer;
         this_line :     String)
      is
         found     : Boolean;
         searching : Boolean;
      begin

         if end_at-beg_at > target_line_length then

            found_at  := min (this_line'last, beg_at + target_line_length);
            searching := (found_at > 0);

            while searching loop

               if (this_line (found_at) = '+')
               or (this_line (found_at) = '-')
               -- or (this_line (found_at) = '*')
               -- or (this_line (found_at) = '/')
               then
                  found     := True;
                  searching := False;
               else
                  found     := False;
                  searching := (found_at > beg_at);
               end if;

               found_at := found_at - 1;

            end loop;

            if not found then
               found_at := end_at;
            end if;

         else
            found_at := end_at;
         end if;

      end find_break;

   begin

      Create (txt, Out_File, txt_file_name);

      if write_ada_spec then
         Create (ads, Out_File, ads_file_name);
      end if;

      if is_procedure
         then write_procedure_begin;
         else write_function_begin;
      end if;

      add_declarations;

      Open (src, In_File, src_file_name);

      Put_line (txt, "begin");

      loop
         begin
            declare
               re_lhs    : String := "^ *([a-zA-Z0-9_(), ]+) +=";
               this_line : String := get_line (src);
               this_line_len : Integer := this_line'length;
               this_name : String := grep (this_line, re_lhs, 1, fail => "<no-match 3>");
            begin
               find_equal_sign (found,found_at,this_line);

               if not found then

                  Put_Line (txt,this_line);

               else

                  var_beg:=1;
                  var_end:=found_at-1;

                  tail_beg := found_at+1;
                  tail_end := this_line_len;

                  if this_name'length >= max_names_width
                     then this_lead_in := this_name'length + 1;
                     else this_lead_in := max_names_width;
                  end if;

                  start_line := True;
                  finished   := False;

                  while (not finished) loop

                     beg_at := tail_beg;
                     end_at := tail_end;
                     find_break (break_at,beg_at,end_at,this_line);

                     rhs_beg := tail_beg;
                     rhs_end := break_at;

                     if start_line then
                        Put (txt, spc(3));
                        Put (txt, str (this_line(var_beg..var_end),this_lead_in,pad=>' ') );
                        Put (txt, ":=");
                        Put (txt, this_line(rhs_beg..rhs_end));
                        New_Line (txt);
                     else
                        Put (txt, spc(3));
                        Put (txt, spc (this_lead_in));
                        Put (txt, " ");
                        Put (txt, this_line(rhs_beg..rhs_end));
                        New_Line (txt);
                     end if;

                     start_line := False;

                     tail_beg := break_at+1;
                     tail_end := this_line_len;

                     finished := tail_beg > tail_end;

                  end loop;

               end if;
            end;
         exception
            when end_error => exit;
         end;
      end loop;

      if is_procedure
         then write_procedure_end;
         else write_function_end;
      end if;

      Close (src);
      Close (txt);

      if write_ada_spec then
         Close (ads);
      end if;

   end rewrite_code;

   -----------------------------------------------------------------------------

   procedure Show_Usage is
   begin
      Put_line (" Usage : c2ada -i <src-file> -o <out-file> <options>");
      Put_line (" Options:");
      Put_line ("   -i foo.c       C input.");
      Put_line ("   -o foo.ad      Ada body.");
      Put_line ("   -s foo.ads     Add spec. (optional)");
      Put_line ("   -P name        Write an Ada Procedure with the given name. May include proc. args in name.");
      Put_line ("   -F name        Ditto but for an Ada Function. Ditto re args.");
      Put_line ("   -r var         The return var in the Ada Function.");
      Put_line ("   -x list        A list of global variables of the form :foo:bah:cat:dog:");
      Put_line ("   -b snippet     Add a snippet of code before the body of the procedure/function.");
      Put_line (" Note:");
      Put_Line ("    The C source should consist of a sequence statements of the form");
      Put_Line ("       foo = bah");
      Put_Line ("    with no line breaks in bah.");
      halt;
   end Show_Usage;

   -----------------------------------------------------------------------------

   procedure initialize is
   begin

      if (not find_command_arg ("-i"))
      or (not find_command_arg ("-o")) then
         Show_Usage;
      end if;

   end initialize;

begin

   initialize;

   rewrite_code;

end cdb2ada;
