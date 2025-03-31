with Ada.Text_IO;                               use Ada.Text_IO;
with Ada.Command_Line;                          use Ada.Command_Line;

with Support.RegEx;                             use Support.RegEx;

package body Support.Cmdline is

   re_quote : String := """([^""]+)""";  -- any characters inside matching quotes
   re_text  : String := "([^ ]+)";  -- any character except a space
   re_intg  : String := "([-+]?[0-9]+)";
   re_real  : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
   re_bool  : String := "(True|False|true|false|TRUE|FALSE)";
   re_space : String := "( *=? *)";  -- the text between the flag and its value, allow spaces or =
   ----------------------------------------------------------------------------

   function get_command_arg (which_arg : Integer;
                             default   : String := "???") return String
   is
   begin
      if which_arg <= Argument_Count
         then return trim (Argument (which_arg));
         else return trim (default);
      end if;
   end get_command_arg;

   function get_command_arg (which_arg : Integer;
                             default   : Real := 0.0) return Real
   is
   begin
      if which_arg <= Argument_Count
         then return readstr (Argument (which_arg));
         else return default;
      end if;
   end get_command_arg;

   function get_command_arg (which_arg : Integer;
                             default   : Integer := 0) return Integer
   is
   begin
      if which_arg <= Argument_Count
         then return readstr (Argument (which_arg));
         else return default;
      end if;
   end get_command_arg;

   procedure put_command_arg (target_flag : String;
                              value       : String)
   is
   begin
      extra_cmd_args := extra_cmd_args & unb (" ") & unb (target_flag)
                                       & unb (" ") & unb (value);
   end put_command_arg;

   ----------------------------------------------------------------------------

   function echo_command_name (prefix : String := "") return String
   is
   begin

      return prefix & Command_Name;

   end echo_command_name;

   function echo_command_line (prefix : String := "") return String
   is
      the_string : Unbounded_String;
   begin

      the_string := unb(Command_Name);

      for i in 1 .. Argument_Count loop
         the_string := the_string & unb(" ") & unb(Argument (i));
      end loop;

      return trim(str(prefix & the_string & extra_cmd_args));

   end echo_command_line;

   function echo_command_line_args return String
   is
      the_string : Unbounded_String;
   begin

      the_string := unb("");

      for i in 1 .. Argument_Count loop
         the_string := the_string & unb(" ") & unb(Argument (i));
      end loop;

      return trim(str(the_string & extra_cmd_args));

   end echo_command_line_args;

   ----------------------------------------------------------------------------

   procedure echo_command_name (prefix : String := "") is
   begin
      Put_Line (prefix & echo_command_name);
   end echo_command_name;

   procedure echo_command_line (prefix : String := "") is
   begin
      Put_Line (prefix & echo_command_line);
   end echo_command_line;

   procedure echo_command_line_args is
   begin
      Put_Line (echo_command_line_args);
   end echo_command_line_args;

   ----------------------------------------------------------------------------

   function find_command_arg (target_flag : String) return Boolean
   is
   begin

      return regex_match (" "&echo_command_line_args," "&target_flag);

   end find_command_arg;

   ----------------------------------------------------------------------------

   function read_command_arg (target_flag : String;
                              default     : Integer := 0) return Integer
   is
   begin

      if Argument_Count = 0
         then return default;
         else return grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_intg,3,fail=>default);
      end if;

   end read_command_arg;

   function read_command_arg (target_flag : String;
                              default     : Real := 0.0) return Real
   is
   begin

      if Argument_Count = 0
         then return default;
         else return grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_real,3,fail=>default);
      end if;

   end read_command_arg;

   function read_command_arg (target_flag : String;
                              default     : String := "<null>") return String
   is
      try_again : String := "<try-again>";
   begin

      if Argument_Count = 0
         then return default;
         else
            declare
               tmp : String := grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_quote,3,fail=>try_again);
            begin
               if tmp /= try_again
                  then return tmp;
                  else return grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_text,3,fail=>default);
               end if;
            end;
      end if;

   end read_command_arg;

   function read_command_arg (target_flag : String;
                              default     : Boolean) return Boolean
   is
   begin
      if Argument_Count = 0
         then return default;
         else return grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_bool,3,fail=>default);
      end if;

   end read_command_arg;

   function read_command_arg (target_flag : String;
                              default     : Character := '?') return Character
   is
      default_str : String (1..1);
   begin

      default_str (1) := default;

      if Argument_Count = 0
         then return default;
         else
            declare
               value : String := grep (" "&echo_command_line_args," ("&target_flag&")"&re_space&re_text,3,fail=>default_str);
            begin
               return value (1);
            end;
      end if;

   end read_command_arg;

   ----------------------------------------------------------------------------

   function num_command_items return integer
   is
   begin
      return Argument_Count;
   end num_command_items;

end Support.Cmdline;
