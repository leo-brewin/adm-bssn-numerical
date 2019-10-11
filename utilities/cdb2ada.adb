with Ada.Text_IO;                               use Ada.Text_IO;

with Support;                                   use Support;
with Support.Cmdline;                           use Support.Cmdline;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;

procedure cdb2ada is

   target_line_length : constant := 256;

   src_file_name  : String := read_command_arg ('i',"foo.c");
   txt_file_name  : String := read_command_arg ('o',"foo.ad");
   procedure_name : String := read_command_arg ('n',"foo");

   symbol         : Character := read_command_arg ('s','t'); -- the 'x' in vars like x0123 or
                                                             -- the 't' in t321

   -----------------------------------------------------------------------------

   procedure rewrite_cdb is
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
      max_xvars_width : Integer;

      procedure write_procedure_begin is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         the_name : String := grep (procedure_name, re_name, 1, fail => "no_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         Put_Line (txt, "Procedure "&the_name&" is");

      end write_procedure_begin;

      procedure write_procedure_end is
         re_name  : String := "([a-zA-Z0-9_-]+)";
         the_name : String := grep (procedure_name, re_name, 1, fail => "no_name");
      begin

         for i in the_name'range loop
            if the_name (i)  = '-' then
               the_name (i) := '_';
            end if;
         end loop;

         Put_Line (txt, "end "&the_name&";");

      end write_procedure_end;

      procedure add_declarations is

         src       : File_Type;
         count     : integer;
         max_count : integer;
         width     : integer;
         target    : integer;
         lead_in   : integer;
         num_chars : integer;
         tmp_xvars : Integer;
         num_xvars : Integer;
         max_width : Integer;

         type action_list is (wrote_xvar, wrote_type, wrote_space);
         last_action : action_list;

      begin

         -- first pass: count the number of xvars and record max width

         Open (src, In_File, src_file_name);

         num_xvars := 0;  -- number of xvars
         max_width := 0;  -- maximum widt of the xvars

         loop
            begin
               declare
                  re_numb   : String := "^ *"&symbol&"([0-9]+) +=";
                  this_line : String := get_line (src);
                  this_numb : String := grep (this_line, re_numb, 1, fail => "<no-match>");
               begin
                  if this_numb /= "<no-match>" then
                     num_xvars := num_xvars + 1;
                     max_width := max (max_width, this_numb'length);
                  end if;
               end;
            exception
               when end_error => exit;
            end;
         end loop;

         Close (src);

         max_xvars_width := max_width+1;

         if num_xvars /= 0 then

            -- second pass, write out declarations for all xvars

            Open (src, In_File, src_file_name);

            width   := max_width+3;  -- +3 = +1 for the symbol, +1 for the comma and +1 for the space
            lead_in := 3;            -- whitespace at start of each line

            target  := 85;           -- max length of a line

            count     := 0;          -- number of xvars written in this block
            max_count := 250;        -- max number of xvars in any one block

            Put (txt, spc (lead_in));
            num_chars := lead_in;

            tmp_xvars := 0;          -- total number of xvars processed

            loop
               begin
                  declare
                     re_numb   : String := "^ *"&symbol&"([0-9]+) +=";
                     this_line : String := get_line (src);
                     this_numb : String := grep (this_line, re_numb, 1, fail => "<no-match>");
                  begin
                     if this_numb /= "<no-match>" then

                        tmp_xvars := tmp_xvars + 1;

                        if (count < max_count) then
                           if tmp_xvars /= num_xvars
                              then Put (txt, str (symbol & cut (this_numb) & ",", width, pad=>' '));
                              else Put (txt, cut (symbol & cut (this_numb)));
                           end if;
                           num_chars := num_chars + width;
                           count := count + 1;
                           last_action := wrote_xvar;
                        else
                           Put (txt, str (symbol & cut (this_numb) & " : Real;", width+6, pad=>' '));
                           count := 0;
                           last_action := wrote_type;
                        end if;

                        if tmp_xvars /= num_xvars then
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
               exit when tmp_xvars = num_xvars;
            end loop;

            if last_action /= wrote_type then
               Put_Line (txt, " : Real;");
            end if;

            -- New_Line (txt);

            Close (src);

         end if;

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

      write_procedure_begin;

      add_declarations;

      Open (src, In_File, src_file_name);

      Put_line (txt, "begin");

      loop
         begin
            declare
               re_numb   : String := "^ *"&symbol&"([0-9]+) +=";
               this_line : String := get_line (src);
               this_line_len : Integer := this_line'length;
               this_numb : String := grep (this_line, re_numb, 1, fail => "<no-match>");
            begin
               find_equal_sign (found,found_at,this_line);

               if not found then

                  Put_Line (txt,this_line);

               else

                  var_beg:=1;
                  var_end:=found_at-1;

                  tail_beg := found_at+1;
                  tail_end := this_line_len;

                  if this_numb = "<no-match>"
                     then this_lead_in := var_end-var_beg+1;
                     else this_lead_in := max_xvars_width+1;
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

      Close (src);

      write_procedure_end;

      Close (txt);

   end rewrite_cdb;

   -----------------------------------------------------------------------------

   procedure Show_Usage is
   begin
      Put_line (" Usage : cdb2ada -i <src-file> -o <out-file> -s 'symbol' -n 'name for the procedure'");
      halt;
   end Show_Usage;

   -----------------------------------------------------------------------------

   procedure initialize is
   begin

      if (not find_command_arg ('i'))
      or (not find_command_arg ('o')) then
         Show_Usage;
      end if;

   end initialize;

begin

   initialize;

   rewrite_cdb;

end cdb2ada;
