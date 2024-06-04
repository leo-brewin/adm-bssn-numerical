package Support.RegEx is

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
                  fail      : Integer := -333) return Integer;

   -- find a real number within a string
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Real := -half_huge_real) return Real;

   -- LCB: use this only to read string like "--target=True" or "--target=False" and versions thereof
   --      to test if a string matches a regex use the function regex_match below
   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer ; -- := 1;  -- temporary fix to catch codes that use the old version of lcb-regex
                  the_match : Integer ; -- := 1;  -- for those codes that fail, replace grep (...) with regex_match (...)
                                                  -- after I've found and fixed all codes I will return to the optional args
                  fail      : Boolean := False) return Boolean;

   -- LCB: use this to match a target against a regex
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
