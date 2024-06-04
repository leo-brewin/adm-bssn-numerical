with Ada.Strings.Unbounded;                     use Ada.Strings.Unbounded;
with Ada.Characters.Latin_1;

package Support.Strings is

   function spc (width : in integer) return string;

   function dash (count : in integer) return string;

   function rep (source : Character;
                 count  : in integer) return string;

   function str (source : in Real;
                 width  : in Integer := 10) return String;

   function str (source : in Real;
                 width  : in Integer;
                 aft    : in Integer) return String;

   function str (source : in Integer;
                 width  : in Integer := 0) return String;

   function str (source : in string) return String;

   function str (source : in character) return String;

   function str (source : in character;
                 width  : in integer) return string;

   function str (source : in string;
                 width  : in integer;
                 pad    : Character := Ada.Characters.Latin_1.NUL) return string;

   function str (source : in boolean) return string;

   ------------------------------------------------------------------------------------------------
   -- allow use of C-style formats
   -- uses GNAT.Formatted_String
   -- see g-forstr.ads for a detailed description of the format syntax

   function str (the_string : String;
                 the_format : String) return String;

   function str (the_number : Integer;
                 the_format : String) return String;

   function str (the_number : Real;
                 the_format : String) return String;

   ------------------------------------------------------------------------------------------------
   -- this pair of functions allows simple conversions between strings and unbounded strings

   function unb (the_str : String) return Unbounded_String
                 renames To_Unbounded_String;

   function str (the_unb : Unbounded_String) return String
                 renames To_String;

   ------------------------------------------------------------------------------------------------

   procedure null_string (source : in out unbounded_string);
   function  get_strlen  (source : in unbounded_string) return integer;

   ------------------------------------------------------------------------------------------------

   procedure null_string (source : in out string);

   function  get_strlen (source : in string) return Integer;

   procedure set_strlen (source : in out string;
   	                   length : in Integer);

   function centre (the_string : String;
                    the_length : Integer;
                    the_offset : Integer := 0) return String;

   function upper_case (the_char : Character) return Character;
   function lower_case (the_char : Character) return Character;

   function upper_case (the_string : String) return String;
   function lower_case (the_string : String) return String;

   function str_match      (left : String; right : String) return Boolean;
   function str_match_head (left : String; right : String) return Boolean;
   function sub_str_match  (left : String; offset : Integer; right : String) return Boolean;

   -- procedure to_string (the_string : in out String; the_char : Character);

   procedure trim_head (the_string : in out String);
   function  trim_head (the_string : String) return String;

   procedure trim_tail (the_string : in out String);
   function  trim_tail (the_string : String) return String;

   procedure trim (the_string : in out String);  -- very slow on long lines, avoid/re-write if possible
   function  trim (the_string : String) return String;

   function cut (the_line : string)    return string;
   function cut (the_char : character) return string;

   function "=" (left : string; right : string) return boolean;

   ------------------------------------------------------------------------------------------------

   procedure tex_format (result : out String; num : Real; n : Integer);
   procedure tex_format (result : out String; num : Real; n, m : Integer);
   procedure tex_format (result : out String; num : Integer; n : Integer);

   function tex_format (num : Real; n : Integer)    return String;
   function tex_format (num : Real; n, m : Integer) return String;
   function tex_format (num : Integer; n : Integer) return String;

   ------------------------------------------------------------------------------------------------

   procedure readstr (source :     string;
                      target : out integer);

   procedure readstr (source :     string;
                      target : out real);

   procedure readstr (source :     string;
                      target : out boolean);

   procedure writestr (target : out string;
                       source :     integer);

   procedure writestr (target : out string;
                       source :     real);

   procedure writestr (target : out string;
                       source :     string);

   function readstr (the_string : String) return Integer;
   function readstr (the_string : String) return Real;
   function readstr (the_string : String) return Boolean;

end Support.Strings;
