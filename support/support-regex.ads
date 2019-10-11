package Support.RegEx is

   -- re_intg  : String := "([-+]?[0-9]+)";
   -- re_real  : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
   -- re_text  : String := "([a-zA-Z0-9 .-]+)";
   -- re_space : String := "( |\t)+";
   -- re_email : String := "([a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})";

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : String := "<no match>") return String;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Integer := -333) return Integer;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Real := -333.3e33) return Real;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer := 1;
                  the_match : Integer := 1) return Boolean;

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
