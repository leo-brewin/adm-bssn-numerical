package Support.Cmdline is

   procedure get_command_arg
     (the_arg_string : out String;      -- the unprocessed argument i.e., -xfoo in -xfoo
      which_arg      :     Integer);    -- which argument

   function get_command_arg
     (which_arg     : Integer;          -- which argument
      default       : String)           -- default
      return          String;

   procedure put_command_args
     (item  : character;
      value : string);

---------------------------------------------------------------------------------------------------------

   procedure read_command_arg
     (value       : out Integer;           -- the foo in -xfoo
      found       : out Boolean;           -- did we find it?
      target_flag :     Character;         -- the x in -xfoo
      default     :     Integer := 0);     -- default

   procedure read_command_arg
     (value       : out Real;              -- the foo in -xfoo
      found       : out Boolean;           -- did we find it?
      target_flag :     Character;         -- the x in -xfoo
      default     :     Real := 0.0);      -- default

   procedure read_command_arg
     (value       : out String;            -- the foo in -xfoo
      found       : out Boolean;           -- did we find it?
      target_flag :     Character;         -- the x in -xfoo
      default     :     String := "null"); -- default

   procedure read_command_arg
     (value       : out String;            -- the foo in -xfoo
      found       : out Boolean;           -- did we find it?
      target_flag :     Character;         -- the x in -xfoo
      default     :     Character := '?'); -- default

   function read_command_arg
     (target_flag : Character;             -- the x in -xfoo
      default     : Integer := 0)          -- default
      return        Integer;

   function read_command_arg
     (target_flag : Character;             -- the x in -xfoo
      default     : Real := 0.0)           -- default
      return        Real;

   function read_command_arg
     (target_flag : Character;             -- the x in -xfoo
      default     : String := "null")      -- default
      return        String;

   function read_command_arg
     (target_flag : Character;             -- the x in -xfoo
      default     : Character := '?')      -- default
      return        Character;

   function find_command_arg (target_flag : Character) return boolean;

   function num_command_args  return integer;     -- number of command line arguments like -i -o
   function num_command_items return integer;     -- number of command line arguments of any kind, foo bar -i -o
   function echo_command_name return String;      -- the command name without any arguments
   function echo_command_line return String;      -- the full command line
   function echo_command_line_args return String; -- just the command line arguments

   -- echo details to standard output

   procedure echo_command_name;                   -- the command name without any arguments
   procedure echo_command_line;                   -- the full command line
   procedure echo_command_line_args;              -- just the command line arguments

end Support.Cmdline;
