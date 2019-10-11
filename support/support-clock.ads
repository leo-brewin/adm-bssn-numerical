with Ada.Real_Time;

package Support.Clock is

   beg_clock : Ada.Real_Time.Time;
   end_clock : Ada.Real_Time.Time;

   function get_date return String;

   function get_elapsed (beg_clock : Ada.Real_Time.Time;
                         end_clock : Ada.Real_Time.Time) return Real;

   procedure reset_elapsed_cpu;

   procedure report_elapsed_cpu (num_points, num_loop : Integer);

end Support.Clock;
