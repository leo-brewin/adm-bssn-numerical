with Ada.Strings.Unbounded;                     use Ada.Strings.Unbounded;
with Support.Strings;                           use Support.Strings;

package Support.Cmdline is

   function get_command_arg (which_arg : Integer;
                             default   : String := "???") return String;

   function get_command_arg (which_arg : Integer;
                             default   : Real := 0.0) return Real;

   function get_command_arg (which_arg : Integer;
                             default   : Integer := 0) return Integer;

   procedure put_command_arg (target_flag : String;
                              value       : String);

   function echo_command_name (prefix : String := "") return String;     -- the command name without any arguments
   function echo_command_line (prefix : String := "") return String;     -- the full command line
   function echo_command_line_args                    return String;     -- just the command line arguments

   procedure echo_command_name (prefix : String := "");                  -- the command name without any arguments
   procedure echo_command_line (prefix : String := "");                  -- the full command line
   procedure echo_command_line_args;                                     -- just the command line arguments

   function read_command_arg (target_flag : String;
                              default     : Integer := 0) return Integer;

   function read_command_arg (target_flag : String;
                              default     : Real := 0.0) return Real;

   function read_command_arg (target_flag : String;
                              default     : String := "<null>") return String;

   function read_command_arg (target_flag : String;
                              default     : Character := '?') return Character;

   function read_command_arg (target_flag : String;
                              default     : Boolean) return Boolean;

   function find_command_arg (target_flag : String) return Boolean;

   function num_command_items return integer;     -- number of command line arguments of any kind, foo bar -i -o = abc.txt

private

   extra_cmd_args : Unbounded_String := unb ("");

end Support.Cmdline;
