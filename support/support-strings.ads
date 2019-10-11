with Ada.Characters.Latin_1;

package Support.Strings is

   function str (source : Real;                      -- the number to print
                 width  : Integer := 10)             -- width of the printed number
                 return   string;

   function str (source : Integer;                   -- the number to print
                 width  : Integer := 0)              -- width of the printed number
                 return   string;

   function str (source : string;
                 width  : integer;
                 pad    : Character := Ada.Characters.Latin_1.NUL) return string;

   function str (source : character;
                 width  : integer := 1) return string;

   function fill_str (the_num  : Integer;            -- the number to print
                      width    : Integer;            -- width of the printed number
                      fill_chr : Character := ' ')   -- the leading fill character
                      return     String;

   function spc (width : integer) return string;

   function cut (the_line : string)    return string;    -- delete (cut) trailing null characters

	procedure null_string (source : in out string);

	function  get_strlen (source : string) return Integer;

	procedure set_strlen (source : in out string;
		                   length :        Integer);

   procedure readstr (source :     string;
                      target : out integer);

   procedure readstr (source :     string;
                      target : out real);

   procedure writestr (target : out string;
                       source :     integer);

   procedure writestr (target : out string;
                       source :     real);

   procedure writestr (target : out string;
                       source :     string);

   function centre (the_string : String;
                    the_length : Integer;
                    the_offset : Integer := 0) return String;

   procedure trim_head (the_string : in out String);
   function  trim_head (the_string : String) return String;

   procedure trim_tail (the_string : in out String);
   function  trim_tail (the_string : String) return String;

   procedure trim (the_string : in out String);
   function  trim (the_string : String) return String;

   function lower_case (source : String) return String;
   function upper_case (source : String) return String;

end Support.Strings;
