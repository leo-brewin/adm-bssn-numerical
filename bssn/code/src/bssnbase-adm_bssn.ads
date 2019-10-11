package BSSNBase.ADM_BSSN is

   function adm_gab   (gBar : MetricPointArray;
                       phi  : Real)
                       return MetricPointArray;

   function adm_Kab   (ABar : ExtcurvPointArray;
                       gBar : MetricPointArray;
                       phi  : Real;
                       trK  : Real)
                       return ExtcurvPointArray;

   function bssn_phi  (gab : MetricPointArray)
                       return Real;

   function bssn_trK  (Kab : ExtcurvPointArray;
                       gab : MetricpointArray)
                       return Real;

   function bssn_gBar (gab : MetricPointArray)
                       return MetricPointArray;

   function bssn_ABar (Kab : ExtcurvPointArray;
                       gab : MetricPointArray)
                       return ExtcurvPointArray;

end BSSNBase.ADM_BSSN;
