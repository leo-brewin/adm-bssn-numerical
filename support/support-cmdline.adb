with Ada.Text_IO;                               use Ada.Text_IO;
with Ada.Command_Line;                          use Ada.Command_Line;
with Support.Strings;                           use Support.Strings;
with Support.RegEx;                             use Support.RegEx;
with Ada.Characters.Latin_1;

package body Support.Cmdline is

   max_arg_length : Constant := 256;  -- maximum length of the argument for each each flag

   type flags is ('0','1','2','3','4','5','6','7','8','9',
                  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
                  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');

   type cmd_args_record is record
      image  : Character;
      exists : Boolean := False;
      index  : Integer := 0;
      value  : String (1..max_arg_length) := (others => Ada.Characters.Latin_1.NUL);
   end record;

   cmd_args : array (flags) of cmd_args_record;

   function to_flags (the_char : character) return flags is
      result : flags;
      found  : Boolean := False;
   begin

      for i in flags'range loop
         if flags'Image(i)(2) = the_char then  -- note 'Image will return a quoted string
            found := True;                     --       so we need to access character (2) to get the flag
            result := i;
            exit;
         end if;
      end loop;

      if not found
         then raise constraint_error with "invalid flag: -"&the_char;
         else return result;
      end if;

   end to_flags;

   ----------------------------------------------------------------------------

   procedure get_command_arg (the_arg_string : out string; which_arg : integer) is
   begin
      writestr (the_arg_string, trim (Argument (which_arg)));
   end get_command_arg;

   function get_command_arg (which_arg : Integer;
                             default   : String) return String
   is
   begin
      if which_arg <= Argument_Count
         then return trim (Argument (which_arg));
         else return trim (default);
      end if;
   end get_command_arg;

   ----------------------------------------------------------------------------

   function echo_command_name return String
   is
   begin

      return Command_Name;

   end echo_command_name;

   function echo_command_line return String
   is
      the_len : Integer := 0;
   begin

      -- how long will our string be?

      the_len := get_strlen (cut(Command_Name));
      for i in 1 .. Argument_Count loop
         the_len := the_len + get_strlen (' '&cut(Argument (i)));
      end loop;

      -- now build the return string

      if the_len > 0 then
         declare
            the_string : String (1..the_len);
         begin
            writestr(the_string,cut(Command_Name));
            for i in 1 .. Argument_Count loop
               writestr (the_string,cut(the_string)&' '&cut(Argument (i)));
            end loop;
            return the_string;
         end;
      else
         return "-- empty command line --";  -- can't see how this could happen...
      end if;

   end echo_command_line;

   function echo_command_line_args return String
   is
      the_len : Integer := 0;
   begin

      -- how long will our string be?

      the_len := 0;
      for i in 1 .. Argument_Count loop
         the_len := the_len + get_strlen (' '&cut(Argument (i)));
      end loop;

      -- now build the return string

      if the_len > 0 then
         declare
            the_string : String (1..the_len);
         begin
            null_string (the_string);
            for i in 1 .. Argument_Count loop
               writestr (the_string,cut(the_string)&' '&cut(Argument (i)));
            end loop;
            return trim(the_string);
         end;
      else
         return "-- empty command line --";  -- can't see how this could happen...
      end if;

   end echo_command_line_args;

   ----------------------------------------------------------------------------

   procedure echo_command_name is
   begin
      Put_Line (echo_command_name);
   end echo_command_name;

   procedure echo_command_line is
   begin
      Put_Line (echo_command_line);
   end echo_command_line;

   procedure echo_command_line_args is
   begin
      Put_Line (echo_command_line_args);
   end echo_command_line_args;

   ----------------------------------------------------------------------------

   procedure get_command_args
   is
   begin

      for i in 1 .. Argument_Count loop
         declare
            the_arg  : String  := Argument (i);
            the_len  : Integer := the_arg'last;
            the_flag : flags;
         begin
            if the_len > 1 then
               if the_arg (1) = '-' then
                  the_flag := to_flags (the_arg (2));
                  cmd_args (the_flag) := (exists => True,
                                          image  => the_arg (2),
                                          index  => i,
                                          value  => str (the_arg (3..the_len),max_arg_length));
               end if;
            end if;
         end;
      end loop;

   end get_command_args;

   procedure put_command_args (item : character; value : string) is
      target : flags := to_flags (item);
   begin

      cmd_args (target) := (exists => True,
                            image  => item,
                            index  => Argument_Count + 1,  -- put this item after all real command line args
                            value  => str (value,max_arg_length));

   end put_command_args;

   procedure read_command_arg
     (value       : out Integer;
      found       : out Boolean;
      target_flag :     Character;
      default     :     Integer := 0)
   is
      target  : flags  := to_flags (target_flag);
      re_intg : String := "^[ \t]*([-+]?[0-9]+)";
   begin

      found := cmd_args (target).exists;

		if found then
         if get_strlen(cmd_args(target).value) > 0
			   then readstr (cut(cmd_args(target).value),value);  -- normal case, e.g.,  -i127
            else
               if cmd_args(target).index < Argument_Count
                  then value := grep (Argument(cmd_args(target).index+1), re_intg, 1, fail => default);
                  else value := default;                             -- forgot value, e.g., -i
               end if;
         end if;
			else value := default;
		end if;

   end read_command_arg;

   procedure read_command_arg
     (value       : out Real;
      found       : out Boolean;
      target_flag :     Character;
      default     :     Real := 0.0)
   is
      target  : flags  := to_flags (target_flag);
      re_real : String := "^[ \t]*([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
   begin

      found := cmd_args (target).exists;

		if found then
         if get_strlen(cmd_args(target).value) > 0
			   then readstr (cut(cmd_args(target).value),value);  -- normal case, e.g.,  -f3.14159
            else
               if cmd_args(target).index < Argument_Count
                  then value := grep (Argument(cmd_args(target).index+1), re_real, 1, fail => default);
                  else value := default;                             -- forgot value, e.g., -f
               end if;
         end if;
			else value := default;
		end if;

   end read_command_arg;

   procedure read_command_arg
     (value       : out String;
      found       : out Boolean;
      target_flag :     Character;
      default     :     String := "null")
   is
      target : flags := to_flags (target_flag);
   begin

      found := cmd_args (target).exists;

      if found
         then writestr (value, cut (cmd_args(target).value));
         else writestr (value, cut (default));
      end if;

      if get_strlen(value) = 0 then
         if found then
            if cmd_args(target).index < Argument_Count
               then writestr (value, Argument(cmd_args(target).index+1) );
               else writestr (value, cut (default));   -- forgot value, e.g., -f
            end if;
         else
            writestr (value, cut(default));   -- forgot value, e.g., -f
         end if;
      end if;

   end read_command_arg;

   procedure read_command_arg
     (value       : out String;
      found       : out Boolean;
      target_flag :     Character;
      default     :     Character := '?')
   is
      target : flags := to_flags (target_flag);
   begin

      found := cmd_args (target).exists;

      if found
         then writestr (value, cut (cmd_args(target).value));
         else writestr (value, str (default));
      end if;

      if get_strlen(value) = 0 then
         if found then
            if cmd_args(target).index < Argument_Count
               then writestr (value, str (Argument(cmd_args(target).index+1)(1)) );
               else writestr (value, str (default));                             -- forgot value, e.g., -f
            end if;
         else
            writestr (value, str (default));   -- forgot value, e.g., -f
         end if;
      end if;

   end read_command_arg;

   ----------------------------------------------------------------------------

   function read_command_arg
     (target_flag : Character;
      default     : Integer := 0) return Integer
   is
      found : Boolean;
      value : Integer;
   begin
      read_command_arg (value,found,target_flag,default);
      if found
         then return value;
         else return default;
      end if;
   end read_command_arg;

   function read_command_arg
     (target_flag : Character;
      default     : Real := 0.0) return Real
   is
      found : Boolean;
      value : Real;
   begin
      read_command_arg (value,found,target_flag,default);
      if found
         then return value;
         else return default;
      end if;
   end read_command_arg;

   function read_command_arg
     (target_flag : Character;
      default     : String := "null") return String
   is
      found : Boolean;
      value : String (1..max_arg_length);
   begin
      read_command_arg (value,found,target_flag,default);
      if found
         then return cut(value);
         else return default;
      end if;
   end read_command_arg;

   function read_command_arg
     (target_flag : Character;
      default     : Character := '?') return Character
   is
      found : Boolean;
      value : String (1..max_arg_length);
   begin
      read_command_arg (value,found,target_flag,default);
      if found
         then return value (1);
         else return default;
      end if;
   end read_command_arg;

   function find_command_arg(target_flag : Character) return Boolean
   is
      target : flags := to_flags (target_flag);
   begin

      return cmd_args (target).exists;

   end find_command_arg;

   ----------------------------------------------------------------------------

   function num_command_args return integer
   is
      num : Integer := 0;
   begin

      for i in flags'range loop
         if cmd_args (i).exists then
            num := num + 1;
         end if;
      end loop;

      return num;

   end num_command_args;

   ----------------------------------------------------------------------------

   function num_command_items return integer
   is
   begin
      return Argument_Count;
   end num_command_items;

begin

   get_command_args;

end Support.Cmdline;
