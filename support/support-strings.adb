with Ada.Text_IO;                               use Ada.Text_IO;
with Ada.Strings;                               use Ada.Strings;
with Ada.Strings.Fixed;                         use Ada.Strings.Fixed;
with Ada.Characters.Handling;

with GNAT.Formatted_String;                     use GNAT.Formatted_String;

package body Support.Strings is

   package Real_IO    is new Ada.Text_IO.Float_IO (Real);                      use Real_IO;
   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);                 use Integer_IO;
   package Boolean_IO is new Ada.Text_IO.Enumeration_IO (Boolean);             use Boolean_IO;

   ------------------------------------------------------------------------------------------------
   -- comparison between strings and unbounded strings

   -- strings:

   --    str_1:=str_1 & str_2;        -- a definite constraint error
   --    str_1:=str_2 & str_3;        -- a possible constraint error
   --    return str_1 & str_2;        -- okay
   --    some_proc( str_1 & str_2 );  -- okay
   --    char := the_string(3);       -- okay
   --    the_string(3) := char;       -- okay

   -- unbounded strings:

   --    str_1:=str_1 & str_2;        -- okay
   --    str_1:=str_2 & str_3;        -- okay
   --    return str_1 & str_2;        -- okay
   --    some_proc( str_1 & str_2 );  -- okay
   --    char := the_string(3);       -- illegal, must use: char := element(the_string,3);
   --    the_string(3) := char;       -- illegal, must use: replace_element(the_string,3,char);

   -- there is one other very significant difference between strings and unbounded strings.
   -- when using get_line to read lines of text from a file, get_line does not clear the string
   -- before it copies the text to the string. for strings this means that trailing characters
   -- may remain in the string (possibly from a previous read). this does not occur with unbounded
   -- strings.
   --
   -- string:="1234567890";
   -- get_line(file,string);   <-- suppose the line contained just "abc"
   -- put_line(string);        --> "abc4567890"
   --
   -- unbound:=to_unbounded_string("1234567890");
   -- get_line(file,unbound);
   -- put_line(unbound);       --> "abc"

   ------------------------------------------------------------------------------------------------

   function spc (width : in integer) return string is
      spaces : constant string(1..width) := (others => ' ');
   begin
      return spaces;
   end spc;

   function dash (count : in integer) return string is
      dashes : constant string(1..count) := (others => '-');
   begin
      return dashes;
   end dash;

   function rep (source : Character; count : in integer) return string is
      the_text : constant string(1..count) := (others => source);
   begin
      return the_text;
   end rep;

   function str (source : in Real;
                 width  : in Integer := 10) return string is
      result : string(1..width);
   begin
      -- 4932 = largest exponent for 18 dec. digits
      -- so may need up to 4 digits in the exponent + 1 for the sign = 5
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

   function str (source : in Real;
                 width  : in Integer;
                 aft    : in Integer) return string is
      result : string(1..width);
   begin
      Put(result,source,aft,0);
      return result;
   end str;

   function str (source : in Integer;
                 width  : in Integer := 0) return string is
      result : string(1..width);
      wide_result : string(1..Integer'width);
   begin
      if width = 0 then
         Put(wide_result,source);
         return trim(wide_result,left);  -- flush left, returns a string just large enough to contain the integer
      else
         Put(result,source);
      return result;
      end if;
   end str;

   function str (source : in string) return string is
   begin
      return cut(source); -- return the leading part of the string, trailing null's are tiresome
   end str;

   function str (source : in character) return string is
      result : string(1..1);
   begin
      result(1) := source;
      return result;
   end str;

   function str (source : in character;
                 width  : in integer) return string is
      result : string(1..width);
   begin
      for i in 1..width loop
         result(i) := source;
      end loop;
      return result;
   end str;

   -- return a string of a given width
   -- right pad to fill width, truncate right most characters if too wide
   function str (source : in string;
                 width  : in integer;
                 pad    : Character := Ada.Characters.Latin_1.NUL) return string is
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

   function str (source : in boolean) return string is
   begin
      if source
         then return " True";
         else return "False";
      end if;
   end str;

   -- allow use of C-style formats
   -- uses GNAT.Formatted_String
   -- see g-forstr.ads for a detailed description of the format syntax

   function str (the_string : String;
                 the_format : String) return String
   is

   begin

      declare
         fmt : Formatted_String := +the_format;  -- the + is an op. that converts from String to Formatted_String
         len : Integer          := get_strlen (the_format);
      begin
         case the_format (len) is
            when 's'    => fmt := fmt & the_string;
            when others => raise Constraint_error with "> only s supported";
         end case;
         return ((-fmt));  -- do *not* clear trailing spaces
                           -- the - is an op. that converts from Formatted_String to String
      end;

   end str;

   function str (the_number : Integer;
                 the_format : String) return String
   is

   begin

      declare
         fmt : Formatted_String := +the_format;  -- the + is an op. that converts from String to Formatted_String
         len : Integer          := get_strlen (the_format);
         the_intg  : Integer    := the_number;
         the_float : Long_Float := Long_Float (the_number);
      begin
         case the_format (len) is
            when 'd' | 'i'             => fmt := fmt & the_intg;
            when 'f' | 'F' | 'e' | 'E' => fmt := fmt & the_float;
            when others => raise Constraint_error with "> only d,i,f,F,e,E supported";
         end case;
         return (trim_tail(cut(-fmt)));  -- clear trailing spaces
                                         -- the - is an op. that converts from Formatted_String to String
      end;

   end str;

   function str (the_number : Real;
                 the_format : String) return String
   is

   begin

      declare
         fmt : Formatted_String := +the_format;  -- the + is an op. that converts from String to Formatted_String
         len : Integer          := get_strlen (the_format);
         the_intg  : Integer    := Round (the_number);
         the_float : Long_Float := Long_Float (the_number);
      begin
         case the_format (len) is
            when 'd' | 'i'             => fmt := fmt & the_intg;
            when 'f' | 'F' | 'e' | 'E' => fmt := fmt & the_float;
            when others => raise Constraint_error with "> only d,i,f,F,e,E supported";
         end case;
         return (trim_tail(cut(-fmt)));  -- clear trailing spaces
                                         -- the - is an op. that converts from Formatted_String to String
      end;

   end str;

   ------------------------------------------------------------------------------------------------

   procedure null_string (source : in out unbounded_string) is
   begin
      source:=to_unbounded_string("");
   end null_string;

   function get_strlen (source : in unbounded_string) return integer is
   begin
      return length(source);
   end get_strlen;

   ------------------------------------------------------------------------------------------------

   procedure null_string (source : in out string) is
   begin
      source := (others => Ada.Characters.Latin_1.NUL);
   end null_string;

   function get_strlen (source : in string) return integer is
      length : Integer :=0;
   begin
      for i in source'range loop
         exit when source(i) = Ada.Characters.Latin_1.NUL;
         length := i-source'first+1;
      end loop;
      return length;
   end;

   procedure set_strlen (source : in out string;
                         length : integer) is
   begin
      for i in source'first+length..source'last loop
         source(i) := Ada.Characters.Latin_1.NUL;
      end loop;
   end set_strlen;

   ------------------------------------------------------------------------------------------------

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

   ------------------------------------------------------------------------------------------------

   function upper_case (the_char : Character) return Character is
   begin
      return Ada.Characters.Handling.To_Upper (the_char);
   end upper_case;

   function lower_case (the_char : Character) return Character is
   begin
      return Ada.Characters.Handling.To_Lower (the_char);
   end lower_case;

   function upper_case (the_string : String) return String is
      the_uc_string : String := the_string;
   begin
      return Ada.Characters.Handling.To_Upper (the_string);
   end upper_case;

   function lower_case (the_string : String) return String is
   begin
      return Ada.Characters.Handling.To_Lower (the_string);
   end lower_case;

   ------------------------------------------------------------------------------
   -- returns true only when the content of the two words are exactly equal

   function str_match (left : String; right : String) return Boolean is
      Result : Boolean;
   begin

      Result := False;

      if get_strlen(left) /= get_strlen(right) then
         Result := False;
      else
         if cut(left) = cut(right)
            then Result := True;
            else Result := False;
         end if;
      end if;

      return Result;

   end str_match;

   -- returns true only when the right string matches the leading part of the left string
   -- note: *all* of the right string must be found in the head of the left string

   -- is the right string a leading sub-string of the left string?

   -- str_match_head ("abcdef","abc") -> true
   -- str_match_head ("abcdef","abc") -> false
   -- str_match_head ("abcdef","abcdefghijk") -> false

   function str_match_head (left : String; right : String) return Boolean is
      result : Boolean;
   begin

      if get_strlen (left) < get_strlen (right) then
         result := False;
      else
         result := True;
         for i in 1 .. get_strlen (right) loop
            if left (left'first+i-1) /= right (right'first+i-1) then
               result := False;
               exit;
            end if;
         end loop;
      end if;

      return result;

   end str_match_head;

   -- returns true only when the characters of left, from offset, match exactly those of right.
   -- offset >= 0 is the starting position, relative to left'first, in the left string.

   -- an offset = 0 will test for a match on the *heads* of the pair of strings

   function sub_str_match (left : String; offset : integer; right : String) return Boolean is
      result : Boolean;
   begin

      if get_strlen (left) < get_strlen (right) + offset then
         result := False;
      else
         result := True;
         for i in 1 .. get_strlen (right) loop
            if left (left'first+i+offset-1) /= right (right'first+i-1) then
               result := False;
               exit;
            end if;
         end loop;
      end if;

      return result;

   end sub_str_match;

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
         then writestr(tmp_string,the_string(j..the_end));  --  the_string has non-empty content
         else null_string (tmp_string);  --  the_string consists entirely of white space
      end if;

      the_string := tmp_string;

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

   end trim_tail;

   function trim_head (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim_head (tmp_string);
      return cut(tmp_string);
   end trim_head;

   function trim_tail (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim_tail (tmp_string);
      return cut(tmp_string);
   end trim_tail;

   procedure trim (the_string : in out String) is
   begin

      trim_head (the_string);
      trim_tail (the_string);

   end trim;

   function trim (the_string : String) return String is
      tmp_string : String := the_string;
   begin
      trim (tmp_string);
      return cut(tmp_string);
   end trim;

   function cut(the_line : string) return string is
      result : constant string := the_line;
   begin
      return result(result'first..result'first+get_strlen(result)-1);
   end cut;

   function cut(the_char : character) return string is
      result : string(1..1);
   begin
      result(1) := the_char;
      return result;
   end cut;

   function "=" (left : string; right : string) return boolean is
      tmp_left  : constant string := cut(left);
      tmp_right : constant string := cut(right);
      len_left  : integer;
      len_right : integer;
   begin
      len_left := get_strlen(tmp_left);
      len_right := get_strlen(tmp_right);
      if len_left /= len_right then
         return false;
      else
         -- can't use the following in this "=" function as that would be an infinite recursion
         -- if tmp_left = tmp_right
         --    then return true;
         --    else return false;
         -- end if;
         for i in tmp_left'range loop
            if tmp_left(i) /= tmp_right(i) then -- assume both strings have 'first = 1
               return false;
            end if;
         end loop;
         return true;
      end if;
   end "=";

   ------------------------------------------------------------------------------------------------

   procedure tex_format (result : out String; num : Real; n, m : Integer) is
   begin
      writestr (result, str (num, n, m));
      trim (result);
   end tex_format;

   procedure tex_format (result : out String; num : Real; n : Integer) is
      i              : Integer;
      tmp            : Real;
   	the_num        : Real;
   	is_negative    : Boolean := False;
      log10          : Integer;
      tmp_01, tmp_02 : String (1 .. 80);
   begin

   	the_num := num;

   	-- without this test, negative numbers would be returned with the wrong exponent
   	-- (e.g., -6.7e-2 would be returned as -6.7x10^{-1})

   	if the_num < 0 then
   		is_negative := True;
   		the_num := -the_num;
   	end if;

      -- this routine will only be called very occassionaly so we can aford some
      -- computational inefficiency

      -- log10 := Integer (Log (abs (the_num)) / Log (10.0e0)); -- no, requires the whole maths library
      -- log10 := Real'Exponent(the_num); -- no, yields exponent wrt Machine_Radix ie. base 2

      if the_num > 10.0 then
         tmp := the_num;
         log10 := 0;
         while (tmp > 10.0) and (log10 < 4933) loop -- 4932 = largest exponent for 18 dec. digits
            tmp := tmp/10.0;
            log10 := log10+1;
         end loop;
      elsif the_num < 1.0 then
         tmp := 1.0e0/the_num;
         log10 := -1;
         while (tmp > 10.0) and (log10 > -4933) loop
            tmp := tmp/10.0;
            log10 := log10-1;
         end loop;
      else
         log10 := 0;
      end if;
      if log10 = -4933 then
         log10 := 0;
         the_num := 0.0;
      end if;

      if log10 = 0 then

   		if is_negative
            then writestr (tmp_01, str (-the_num, (n + 7)));
   		   else writestr (tmp_01, str ( the_num, (n + 7)));
   		end if;
         trim (tmp_01);
         i := get_strlen (tmp_01);
         set_strlen (tmp_01, max (0, i - 4)); --  strips off trailing e+12 exponent
         writestr (result, cut(tmp_01));
         trim (result);

      else

   		if is_negative
            then writestr (tmp_01, str (-the_num, (n + 7)));
   		   else writestr (tmp_01, str ( the_num, (n + 7)));
   		end if;
         if log10 < 0
            then writestr (tmp_02, '-' & str (-log10, 0));
            else writestr (tmp_02, '+' & str ( log10, 0));
         end if;
         trim (tmp_01);
         trim (tmp_02);
         i := get_strlen (tmp_01);
         set_strlen (tmp_01, max (0, i - 4)); --  strips off trailing e+12 exponent
         writestr (result, cut(tmp_01) & "\times10^{" & cut(tmp_02) & '}');
         trim (result);

      end if;

   end tex_format;

   procedure tex_format (result : out String; num : Integer; n : Integer) is
      tmp : string := spc (n);
   begin

      Put (tmp,num);
      set_strlen (result,n);
      writestr (result, trim(tmp,left));

   end tex_format;

   function tex_format (num : Real; n, m : Integer) return String is
   begin
      return trim (str (num, n, m) );
   end tex_format;

   function tex_format (num : Real; n : Integer) return String is
      result : String (1..80);
   begin
      tex_format (result,num,n);
      return trim (result);
   end tex_format;

   function tex_format (num : Integer; n : Integer) return String is
      tmp : string := spc (n);
   begin

      Put(tmp,num);
      return trim(tmp,left);

   end tex_format;

   ------------------------------------------------------------------------------------------------

   procedure readstr(source :     string;
                     target : out integer) is
      last : integer;
   begin
      get(source,target,last);
   end readstr;

   procedure readstr(source :     string;
                     target : out real) is
      last : integer;
   begin
      get(source,target,last);
   end readstr;

   procedure readstr(source :     string;
                     target : out Boolean) is
      last : integer;
   begin
      get(source,target,last);
   end readstr;

   procedure writestr(target : out string;
                      source :     integer) is
   begin
      put(target,source);
   end writestr;

   procedure writestr(target : out string;
                      source :     real) is
   begin
      put(target,source);
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

   ------------------------------------------------------------------------------------------------

   function readstr (the_string : String) return Integer is
      the_integer : Integer;
   begin
      readstr (the_string,the_integer);
      return the_integer;
   end readstr;

   function readstr (the_string : String) return Real is
      the_real : Real;
   begin
      readstr (the_string,the_real);
      return the_real;
   end readstr;

   function readstr (the_string : String) return Boolean is
      the_boolean : Boolean;
   begin
      readstr (the_string,the_boolean);
      return the_boolean;
   end readstr;

end Support.Strings;
