with Ada.Numerics.Generic_Elementary_Functions;

-- for reporting Ksner parameters
with Ada.Text_IO;            use Ada.Text_IO;

-- for parsing of the command line arguments
with Support.RegEx;          use Support.RegEx;
with Support.CmdLine;        use Support.CmdLine;
with Support.Strings;        use Support.Strings;

package body Metric.Kasner is

   package Maths is new Ada.Numerics.Generic_Elementary_Functions (Real); use Maths;

   -- allow the pi to be set on the command line: --KasnerPi 0.666:0.666:-0.333

   re_real : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
   re_real_seq : String := re_real&":"&re_real&":"&re_real;

   p1 : Real := grep (read_command_arg ("--KasnerPi","0.666666666666666666:0.666666666666666666:-0.333333333333333333"),re_real_seq,1,fail=>  2.0/3.0);
   p2 : Real := grep (read_command_arg ("--KasnerPi","0.666666666666666666:0.666666666666666666:-0.333333333333333333"),re_real_seq,3,fail=>  2.0/3.0);
   p3 : Real := grep (read_command_arg ("--KasnerPi","0.666666666666666666:0.666666666666666666:-0.333333333333333333"),re_real_seq,5,fail=> -1.0/3.0);

   -- hard wired pi

   -- p1 : Real :=   2.0/3.0;
   -- p2 : Real :=   2.0/3.0;
   -- p3 : Real := - 1.0/3.0;

   function set_3d_lapse (t, x, y, z : Real) return Real is
   begin
      return 1.0;
   end set_3d_lapse;

   function set_3d_metric (t, x, y, z : Real) return MetricPointArray is
      gab : MetricPointArray := (others => 0.0);
   begin
      gab (xx) := t ** (2.0*p1);  -- gxx
      gab (yy) := t ** (2.0*p2);  -- gyy
      gab (zz) := t ** (2.0*p3);  -- gzz
      return gab;
   end set_3d_metric;

   function set_3d_extcurv (t, x, y, z : Real) return ExtcurvPointArray is
      N : Real;
      Kab : ExtcurvPointArray := (others => 0.0);
   begin
      N := set_3d_lapse (t, x, y, z);
      Kab (xx) := - p1 * (t ** (2.0*p1-1.0)) / N ;  -- Kxx := -(dgxx/dt)/(2N)
      Kab (yy) := - p2 * (t ** (2.0*p2-1.0)) / N ;  -- Kyy := -(dgyy/dt)/(2N)
      Kab (zz) := - p3 * (t ** (2.0*p3-1.0)) / N ;  -- Kzz := -(dgzz/dt)/(2N)
      return Kab;
   end set_3d_extcurv;

   ----------------------------------------------------------------------------

   function set_3d_lapse (t : Real; point : GridPoint) return Real is
   begin
      return 1.0;
   end set_3d_lapse;

   function set_3d_metric (t : Real; point : GridPoint) return MetricPointArray is
      x, y, z : Real;
   begin
      x := point.x;
      y := point.y;
      z := point.z;
      return set_3d_metric (t, x, y, z);
   end set_3d_metric;

   function set_3d_extcurv (t : Real; point : GridPoint) return ExtcurvPointArray is
      x, y, z : Real;
   begin
      x := point.x;
      y := point.y;
      z := point.z;
      return set_3d_extcurv (t, x, y, z);
   end set_3d_extcurv;

   ----------------------------------------------------------------------------

   procedure get_pi (p1, p2, p3 : out Real) is
   begin
      p1 := Metric.Kasner.p1;
      p2 := Metric.Kasner.p2;
      p3 := Metric.Kasner.p3;
   end get_pi;

   procedure report_kasner_params is
   begin
      Put_Line ("> Kasner p1 = "&str(p1,16));
      Put_Line ("> Kasner p2 = "&str(p2,16));
      Put_Line ("> Kasner p3 = "&str(p3,16));
   end report_kasner_params;

end Metric.Kasner;
