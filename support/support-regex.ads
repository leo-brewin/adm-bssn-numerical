package Support.RegEx is

   fail_integer : Constant := -333;
   fail_real    : Constant := -333.3e33;

   -- some useful regex's
   --
   -- re_intg  : String := "([-+]?[0-9]+)";
   -- re_real  : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
   -- re_text  : String := "([a-zA-Z0-9 .-]+)";
   -- re_space : String := "( |\t)+";
   -- re_email : String := "([a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})";

   -- note: if the_line = "foo bah moo cow" and the_regex = "moo" then
   --       result = grep (the_line,the_regex,1) will return result = "moo"
   --       *but* the range of result will be based on where the target was found
   --       thus result'first = 9 and result'last = 11

   -- find a sub-string within a string
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : String := "<no match>") return String;

   -- find an integer within a string
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Integer := fail_integer) return Integer;

   -- find a real number within a string
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Real := fail_real) return Real;

   -- use this only to read string like "--target=True" or "--target=False" and versions thereof
   -- to test if a string matches a regex use the function "regex_match" below
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Boolean := False) return Boolean;

   -- use this to match a target against a regex
   function regex_match (the_line  : String;
                         the_regex : String) return Boolean;

   procedure grep (the_match : out String;
                   found     : out Boolean;
                   the_line  : String;
                   the_regex : String;
                   the_group : Integer);

   procedure grep (the_beg   : out Integer;
                   the_end   : out Integer;
                   found     : out Boolean;
                   the_line  : String;
                   the_regex : String;
                   the_group : Integer := 0);

end Support.RegEx;
