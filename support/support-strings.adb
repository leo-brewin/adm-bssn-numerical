with Ada.Text_IO;                               use Ada.Text_IO;
with Ada.Strings;                               use Ada.Strings;
with Ada.Strings.Fixed;                         use Ada.Strings.Fixed;
with Ada.Characters.Handling;
-- with Ada.Characters.Latin_1;

package body Support.Strings is

   package Real_IO    is new Ada.Text_IO.Float_IO (Real);                      use Real_IO;
   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);                 use Integer_IO;

   function str (source : Real;
                 width  : Integer := 10) return string
   is
      result : string (1..width) := (others => Ada.Characters.Latin_1.NUL);
   begin
      ----------------------------------------------------------------------
      -- Intel x86_64 chips allows 18 decimal digits with 4 digit exponents
      ----------------------------------------------------------------------
      -- so may need up to 4 digits in the exponent + 1 for the sign = 5
      -- if source = 0.0 then
      --    Put (result,source,width-7,3);
      -- elsif abs (source) < 1.0 then
      --    if abs (source) >= 1.0e-99 then
      --       Put (result,source,width-7,3);
      --    elsif abs (source) >= 1.0e-999 then
      --       Put (result,source,width-8,4);
      --    else
      --       Put (result,source,width-9,5);
      --    end if;
      -- else
      --    if abs (source) < 1.0e100 then
      --       Put (result,source,width-7,3);
      --    elsif abs (source) < 1.0e1000 then
      --       Put (result,source,width-8,4);
      --    else
      --       Put (result,source,width-9,5);
      --    end if;
      -- end if;
      -- return result;

      ----------------------------------------------------------------------
      -- macOS Silicon arm64 allows 15 decimal digits with 3 digit exponents
      ----------------------------------------------------------------------
      if source = 0.0 then
         Put (result,source,width-7,3);
      elsif abs (source) < 1.0 then
         if abs (source) >= 1.0e-99 then
            Put (result,source,width-7,3);
         else
            Put (result,source,width-8,4);
         end if;
      else
         if abs (source) < 1.0e100 then
            Put (result,source,width-7,3);
         else
            Put (result,source,width-8,4);
         end if;
      end if;
      return result;

   end str;

   function str (source : Integer;
                 width  : Integer := 0) return string
   is
      result : string (1..width) := (others => Ada.Characters.Latin_1.NUL);
      wide_result : string (1..Integer'width) := (others => Ada.Characters.Latin_1.NUL);
   begin
      if width = 0 then
         Put (wide_result,source);
         return trim(wide_result,left);  -- flush left, returns a string just large enough to contain the integer
      else
         Put (result,source);
         return result;
      end if;
   end str;

   function str (source : string;
                 width  : integer;
                 pad    : Character := Ada.Characters.Latin_1.NUL) return string
   is
      len_src : integer;
      tmp_out : string (1..width) := (others => pad);
      tmp_src : string := cut (source);
   begin
      len_src := get_strlen (tmp_src);
      if len_src <= width then         -- source fits in the window
         tmp_out (1..len_src) := tmp_src (tmp_src'first..tmp_src'first+len_src-1);
         return tmp_out;
      else                             -- source too wide for the window
         return tmp_src (tmp_src'first..tmp_src'first+width-1);
      end if;
   end str;

   function str (source : character;
                 width  : integer := 1) return string
   is
      tmp_str : String (1..width) := (others => Ada.Characters.Latin_1.NUL);
   begin
      tmp_str (1) := source;
      return tmp_str;
   end str;

   function str (source : in string) return string is
   begin
      return cut(source); -- return the leading part of the string, trailing null's are tiresome
   end str;

   function fill_str (the_num  : Integer;          -- the number to print
                      width    : Integer;          -- width of the printed number
                      fill_chr : Character := ' ') -- the fill character
                      return     String
   is
      the_str : String (1 .. width);
   begin
      writestr (the_str, str (the_num, width));
      for i in 1 .. width loop
         if the_str (i) = ' '
            then the_str (i) := fill_chr;
            else exit;
         end if;
      end loop;
      return the_str;
   end fill_str;

   function spc (width : integer) return string is
      spaces : constant string (1..width) := (others => ' ');
   begin
      return spaces;
   end spc;

   function cut (the_line : string) return string is
      result : constant string := the_line;
   begin
      return result(result'first..result'first+get_strlen(result)-1);
   end cut;

   procedure null_string (source : in out string) is
   begin
      source := (others => Ada.Characters.Latin_1.NUL);
   end null_string;

   function get_strlen (source : in string) return integer is
      length : Integer := 0;
   begin
      for i in source'range loop
         exit when source(i) = Ada.Characters.Latin_1.NUL;
         length := i-source'first+1;
      end loop;
      return length;
   end get_strlen;

   procedure set_strlen (source : in out string;
                         length :        integer) is
   begin
      for i in source'first+length..source'last loop
         source(i) := Ada.Characters.Latin_1.NUL;
      end loop;
   end set_strlen;

   function make_str (n : Integer; m : Integer) return String is
      the_str : String (1 .. m);
   begin
      writestr (the_str, str (n, m));
      for i in 1 .. m loop
         if the_str (i) = ' ' then
            the_str (i) := '0';
         end if;
      end loop;
      return the_str;
   end make_str;

   procedure readstr (source :     string;
                      target : out integer) is
      last : integer;
   begin
      get (source,target,last);
   end readstr;

   procedure readstr (source :     string;
                      target : out real) is
      last : integer;
   begin
      get (source,target,last);
   end readstr;

   procedure writestr (target : out string;
                       source :     integer) is
   begin
      put (target,source);
   end writestr;

   procedure writestr (target : out string;
                       source :     real) is
   begin
      put (target,source);
   end writestr;

   procedure writestr (target : out string;
                       source :     string) is
      len_substr : Integer;
      len_source : Integer;
      len_target : Integer;
      beg_source : Integer;
      end_source : Integer;
      beg_target : Integer;
      end_target : Integer;
   begin
      null_string (target);
      len_source := get_strlen (source);  -- source length minus trailing null chars
      len_target := target'length;        -- target lenght, maximum lenght of final string
      len_substr := min (len_source,len_target);
      beg_source := source'first;
      end_source := source'first+len_substr-1;
      beg_target := target'first;
      end_target := target'first+len_substr-1;
      target (beg_target..end_target) := source (beg_source..end_source);
   end writestr;

   function centre (the_string : String;
                    the_length : Integer;
                    the_offset : Integer := 0) return String is
      the_string_length : Integer;
      the_result : String := spc(the_length);
      start, finish : Integer;
      left_space, right_space : Integer;
   begin
      the_string_length := get_strlen (the_string);
      left_space  := max (0,(the_length-the_string_length)/2);
      right_space := max (0,the_length - left_space - the_string_length);
      left_space  := max (0,min(left_space+the_offset,the_length-the_string_length));
      right_space := max (0,min(right_space-the_offset,the_length-the_string_length));
      start  := max (1,min(the_length,left_space+1));
      finish := max (1,min(the_length,the_length-right_space));
      for i in start..finish loop
         the_result (i) := the_string (i-start+1);
      end loop;
      return the_result;
   end centre;

   ------------------------------------------------------------------------------
   -- LCB: my code is faster than the Ada.Strings.Fixed.Trim code
   --      see the examples in tests/strings/lcb02.adb
   ------------------------------------------------------------------------------

   procedure trim_head (the_string : in out String) is
      j                : Integer;
      found            : Boolean;
      the_string_len   : Integer;
      the_beg, the_end : Integer;
      tmp_string       : String := the_string;
   begin

      --  delete leading whitespace

      found := False;

      the_string_len := get_strlen(the_string);

      the_beg := the_string'first;
      the_end := the_beg + the_string_len-1;

      for i in the_beg .. the_end loop
         if the_string (i) /= ' ' then
            j     := i;
            found := True;
            exit;
         end if;
      end loop;

      if found
         then writestr (tmp_string,the_string(j..the_end));  --  the_string has non-empty content
         else null_string (tmp_string);                      --  the_string consists entirely of white space
      end if;

      the_string := tmp_string;

      -- writestr(the_string,Ada.Strings.Fixed.trim (cut(the_string),left));

   end trim_head;

   procedure trim_tail (the_string : in out String) is
      j                : Integer;
      found            : Boolean;
      the_string_len   : Integer;
      the_beg, the_end : Integer;
      tmp_string       : String := the_string;
   begin

      --  delete trailing whitespace

      found := False;
      null_string (tmp_string);

      the_string_len := get_strlen(the_string);

      the_beg := the_string'first;
      the_end := the_beg + the_string_len-1;

      for i in reverse the_beg .. the_end loop
         if the_string (i) /= ' ' then
            j     := i;
            found := True;
            exit;
         end if;
      end loop;

      if found
         then set_strlen (the_string,j);  --  the_string has non-empty content
         else null_string (the_string);   --  the_string consists entirely of white space
      end if;

      -- writestr(the_string,Ada.Strings.Fixed.trim (cut(the_string),right));

   end trim_tail;

   function trim_head (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim_head (tmp_string);
      return cut (tmp_string);
   end trim_head;

   function trim_tail (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim_tail (tmp_string);
      return cut (tmp_string);
   end trim_tail;

   procedure trim (the_string : in out String) is
   begin

      trim_head (the_string);
      trim_tail (the_string);

      -- writestr(the_string,Ada.Strings.Fixed.trim (cut(the_string),both));

   end trim;

   function trim (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim (tmp_string);
      return cut (tmp_string);
   end trim;

   function lower_case (source : String) return String is
   begin
      return Ada.Characters.Handling.To_Lower (source);
   end lower_case;

   function upper_case (source : String) return String is
   begin
      return Ada.Characters.Handling.To_Upper (source);
   end upper_case;

end Support.Strings;
