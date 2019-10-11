with Support;      use Support;
with ADMBase;      use ADMBase;

package Metric.Kasner is

   function set_3d_lapse (t, x, y, z : Real) return Real;
   function set_3d_metric (t, x, y, z : Real) return MetricPointArray;
   function set_3d_extcurv (t, x, y, z : Real) return ExtcurvPointArray;

   function set_3d_lapse (t : Real; point : GridPoint) return Real;
   function set_3d_metric (t : Real; point : GridPoint) return MetricPointArray;
   function set_3d_extcurv (t : Real; point : GridPoint) return ExtcurvPointArray;

   procedure get_pi (p1, p2, p3 : out Real);
   procedure report_kasner_params;

end Metric.Kasner;
