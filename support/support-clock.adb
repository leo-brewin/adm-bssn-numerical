with Ada.Text_IO;                               use Ada.Text_IO;
with Ada.Calendar;

with Support.Strings;                           use Support.Strings;

package body Support.Clock is

   package Real_IO  is new Ada.Text_IO.Float_IO (Real);            use Real_IO;

   function get_date Return string is

      the_date    : String (1..17) := (others => '?');

      the_year    : integer;
      the_month   : integer;
      the_day     : integer;
      the_seconds : real;
      dur_seconds : duration;

      the_hour    : integer;
      the_minute  : integer;

      str_month   : string (1..3);

      first       : integer;

   begin

      Ada.Calendar.Split (Ada.Calendar.Clock, the_year, the_month, the_day, dur_seconds);

      the_seconds := Real (dur_seconds);

      the_hour    := trunc ( (the_seconds/3600.0) );
      the_minute  := round ( (the_seconds-3600.0*Real(the_hour))/60.0 );

      if the_minute = 60 then
         the_minute := 0;
         the_hour   := the_hour + 1;
      end if;

      case the_month is
         when  1 => str_month := "Jan";
         when  2 => str_month := "Feb";
         when  3 => str_month := "Mar";
         when  4 => str_month := "Apr";
         when  5 => str_month := "May";
         when  6 => str_month := "Jun";
         when  7 => str_month := "Jul";
         when  8 => str_month := "Aug";
         when  9 => str_month := "Sep";
         when 10 => str_month := "Oct";
         when 11 => str_month := "Nov";
         when 12 => str_month := "Dec";
         when others => str_month := "???";
      end case;

      writestr (the_date, str(the_hour,2)&":"&
                          str(the_minute,2)&" "&
                          str(the_day,2)&"-"&
                          str_month&"-"&
                          str(the_year,4));

      first := the_date'first;

      if the_date (first + 0) = ' ' then the_date (first + 0) := '0'; end if;
      if the_date (first + 3) = ' ' then the_date (first + 3) := '0'; end if;
      if the_date (first + 6) = ' ' then the_date (first + 6) := '0'; end if;

      return the_date;

   end get_date;

   procedure echo_date is
   begin
      put_line (get_date);
   end echo_date;

end Support.Clock;
