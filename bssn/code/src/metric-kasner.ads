with Support;      use Support;
with BSSNBase;      use BSSNBase;

package Metric.Kasner is

   ----------------------------------------------------------------------------
   -- ADM data

   function set_3d_lapse (t, x, y, z : Real) return Real;
   function set_3d_metric (t, x, y, z : Real) return MetricPointArray;
   function set_3d_extcurv (t, x, y, z : Real) return ExtcurvPointArray;

   function set_3d_lapse (t : Real; point : GridPoint) return Real;
   function set_3d_metric (t : Real; point : GridPoint) return MetricPointArray;
   function set_3d_extcurv (t : Real; point : GridPoint) return ExtcurvPointArray;

   ----------------------------------------------------------------------------
   -- BSSN data

   function set_3d_phi (t, x, y, z : Real) return Real;
   function set_3d_trK (t, x, y, z : Real) return Real;
   function set_3d_gBar (t, x, y, z : Real) return MetricPointArray;
   function set_3d_Abar (t, x, y, z : Real) return ExtcurvPointArray;
   function set_3d_Gi (t, x, y, z : Real) return GammaPointArray;

   function set_3d_phi (t : Real; point : GridPoint) return Real;
   function set_3d_trK (t : Real; point : GridPoint) return Real;
   function set_3d_gBar (t : Real; point : GridPoint) return MetricPointArray;
   function set_3d_Abar (t : Real; point : GridPoint) return ExtcurvPointArray;
   function set_3d_Gi (t : Real; point : GridPoint) return GammaPointArray;

   ----------------------------------------------------------------------------
   procedure get_pi (p1, p2, p3 : out Real);
   procedure report_kasner_params;

end Metric.Kasner;
