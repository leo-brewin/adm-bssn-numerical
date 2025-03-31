with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

with Ada.Characters.Latin_1;

procedure cdb2ada is

   target_line_length : constant := 256;  -- target length of outputlines
                                          -- will split at whitepace, short overruns possible

   src_file_name  : String := read_command_arg ("-i","foo.c");         -- C source (input).

   vars_file_name : String := read_command_arg ("-v","foo-vars.ad");   -- Ada variables (output).
   body_file_name : String := read_command_arg ("-b","foo-body.ad");   -- Ada body code (output).

   local_var_prefix : Character := read_command_arg ("-x",'x');  -- Local variables all share this prefix character, e.g., x1, x2, ... x123, ...

   the_left_offset : Integer := read_command_arg ("-l",0);  -- left offset applied to each output line

   final_var_name : String (1..32); -- assume var names are no longer than 32

   -----------------------------------------------------------------------------

   procedure write_ada_fragments is
      txt          : File_Type;
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

      function is_local_var (this_name : String) return Boolean is
      begin
         if this_name (this_name'First) = local_var_prefix
            then return True;
            else return False;
         end if;
      end is_local_var;

      procedure write_vars is

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

         Create (txt, Out_File, vars_file_name);

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

               width   := max_width+2;      -- +2 = +1 for the comma and +1 for the space
               lead_in := the_left_offset;  -- whitespace at start of each line

               target  := 85;               -- max length of a line

               count     := 0;              -- number of names written in this block
               max_count := 250;            -- max number of names in any one block
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

               -- save the final var name for later so that we can force a blank line
               -- between the local vars and the body of the code

               writestr (final_var_name, cut (unique_names(num_unique_names)));

            else

               Put_Line (txt,spc(the_left_offset)&"-- no local vars");

               writestr (final_var_name, "");

            end if;

         end;

         Close (txt);

      end write_vars;

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

      procedure write_body is
      begin

         Create (txt, Out_File, body_file_name);

         Open (src, In_File, src_file_name);

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
                           Put (txt, spc(the_left_offset));
                           Put (txt, str (this_line(var_beg..var_end),this_lead_in,pad=>' ') );
                           Put (txt, ":=");
                           Put (txt, this_line(rhs_beg..rhs_end));
                           New_Line (txt);
                        else
                           Put (txt, spc(the_left_offset));
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

                  -- force a blank line between the local vars and the body of the code

                  if str_match(this_name, final_var_name) then
                     New_Line (txt);
                  end if;

               end;
            exception
               when end_error => exit;
            end;
         end loop;

         Close (src);
         Close (txt);

      end write_body;

   begin

      write_vars;
      write_body;

   end write_ada_fragments;

   -----------------------------------------------------------------------------

   procedure Show_Usage is
   begin
      Put_line (" Usage : cdb2ada -i <src-file> -v <vars-out-file> -b <body-out-file> [options]");
      Put_line (" Required:");
      Put_line ("   -i foo.c       C source (input).");
      Put_line ("   -v vars.ad     Ada variables (output).");
      Put_line ("   -b body.ad     Add body code (output)");
      Put_line (" Options:");
      Put_line ("   -v character   Local variables all share this prefix character, e.g., x1, x2, ... x123, ..., default = x");
      Put_line ("   -l integer     Add this many spaces to start of every output line, default = 0.");
      Put_line (" Note:");
      Put_Line ("    The C source should consist of a sequence statements of the form");
      Put_Line ("       foo = bah");
      Put_Line ("    with no line breaks in bah.");
      Put_Line ("    This code is intended to be used with merge-src to build complete Ada procedures.");
      halt;
   end Show_Usage;

   -----------------------------------------------------------------------------

   procedure initialize is
   begin

      if  (not find_command_arg ("-i"))
      and (not find_command_arg ("-v"))
      and (not find_command_arg ("-b")) then
         Show_Usage;
      end if;

   end initialize;

begin

   initialize;

   write_ada_fragments;

end cdb2ada;
