with Support.Strings;                           use Support.Strings;
with GNAT.Regpat;                               use GNAT.Regpat;

package body Support.RegEx is

   Matches : Match_Array (0 .. 10); -- Matches (0) = first & last for the whole regex
                                    -- Matches (1) = first & last for the first (...) match
                                    -- Matches (2) = first & last for the second (...) match

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : String := "<no match>") return String
   is
      the_beg : Integer := the_line'first;
      the_end : Integer := the_line'last;
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin

      -- look for a particular match

      for num in 1..the_match loop                             -- loop through successive matches
         Match (Regexp, the_line (the_beg..the_end), Matches); -- find the first match in this window (if it exists)
         if Matches(0).First > 0
            then the_beg := Matches(0).Last + 1;               -- skip over this match, shrink the search window
            else return fail;                                  -- no match, so bail out
         end if;
      end loop;

      if Matches(0).First > 0
         then return the_line (Matches(the_group).first..Matches(the_group).last);
         else return fail;
      end if;

      exception
         -- get here when user asked for a group that doesn't exist
         when others =>
            return "<no such group>";

   end grep;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Integer := -333) return Integer
   is
      result  : Integer;
      the_beg : Integer := the_line'first;
      the_end : Integer := the_line'last;
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin

      -- look for a particular match

      for num in 1..the_match loop                             -- loop through successive matches
         Match (Regexp, the_line (the_beg..the_end), Matches); -- find the first match in this window (if it exists)
         if Matches(0).First > 0
            then the_beg := Matches(0).Last + 1;               -- skip over this match, shrink the search window
            else return fail;                                  -- no match, so bail out
         end if;
      end loop;

      if Matches(0).First > 0
         then readstr (the_line (Matches(the_group).first..Matches(the_group).last),result);
         else result := fail;
      end if;

      return result;

      exception
         -- get here when user asked for a group that doesn't exist
         when others =>
            return -666;

   end grep;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer;
                  the_match : Integer := 1;
                  fail      : Real := -333.3e33) return Real
   is
      result  : Real;
      the_beg : Integer := the_line'first;
      the_end : Integer := the_line'last;
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin

      -- look for a particular match

      for num in 1..the_match loop                             -- loop through successive matches
         Match (Regexp, the_line (the_beg..the_end), Matches); -- find the first match in this window (if it exists)
         if Matches(0).First > 0
            then the_beg := Matches(0).Last + 1;               -- skip over this match, shrink the search window
            else return fail;                                  -- no match, so bail out
         end if;
      end loop;

      if Matches(0).First > 0
         then readstr (the_line (Matches(the_group).first..Matches(the_group).last),result);
         else result := fail;
      end if;

      return result;

      exception
         -- get here when user asked for a group that doesn't exist
         when others =>
            return -666.6e66;

   end grep;

   function grep (the_line  : String;
                  the_regex : String;
                  the_group : Integer := 1;
                  the_match : Integer := 1) return Boolean
   is
      the_beg : Integer := the_line'first;
      the_end : Integer := the_line'last;
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin

      -- look for a particular match

      for num in 1..the_match loop                             -- loop through successive matches
         Match (Regexp, the_line (the_beg..the_end), Matches); -- find the first match in this window (if it exists)
         if Matches(0).First > 0
            then the_beg := Matches(0).Last + 1;               -- skip over this match, shrink the search window
            else return False;                                 -- no match, so bail out
         end if;
      end loop;

      if Matches(0).First > 0
         then return True;
         else return False;
      end if;

      exception
         -- get here when user asked for a group that doesn't exist
         when others =>
            return False;

   end grep;

   procedure grep (the_match : out String;
                   found     : out Boolean;
                   the_line  : String;
                   the_regex : String;
                   the_group : Integer)
   is
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin
      Match (Regexp, the_line, Matches);
      if Matches(0).First > 0 then
         found := True;
         writestr (the_match,the_line (Matches(the_group).first..Matches(the_group).last));
      else
         found := False;
         null_string (the_match);
      end if;
   end grep;

   procedure grep (the_beg   : out Integer;
                   the_end   : out Integer;
                   found     : out Boolean;
                   the_line  : String;
                   the_regex : String;
                   the_group : Integer := 0)
   is
      Regexp  : constant Pattern_Matcher := Compile (the_regex);
   begin
      Match (Regexp, the_line, Matches);
      if Matches (0) = No_Match then
        found := false;
        the_beg := -1;
        the_end := -1;
     else
        found := true;
        the_beg := Matches(the_group).first;
        the_end := Matches(the_group).last;
     end if;
   end grep;

end Support.RegEx;
