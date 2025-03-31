with Ada.Real_Time;    use Ada.Real_Time;

package body Support.Timer is

   beg_clock : Ada.Real_Time.Time;
   end_clock : Ada.Real_Time.Time;

   procedure beg_timer is
   begin
      beg_clock := Ada.Real_Time.Clock;
   end beg_timer;

   procedure end_timer is
   begin
      end_clock := Ada.Real_Time.Clock;
   end end_timer;

   function get_elapsed return Real
   is
   begin
      return Real (To_Duration(end_clock-beg_clock));
   end get_elapsed;

end Support.Timer;
