package body BSSNBase.ADM_BSSN is

   ----------------------------------------------------------------------------
   -- from BSSN to ADM

   function adm_gab   (gBar : MetricPointArray;
                       phi  : Real)
                       return MetricPointArray
   is
   begin
      return exp(4.0*phi) * gBar;
   end;

   function adm_Kab   (ABar : ExtcurvPointArray;
                       gBar : MetricPointArray;
                       phi  : Real;
                       trK  : Real)
                       return ExtcurvPointArray
   is
   begin
      return exp(4.0*phi)*(ABar + ExtcurvPointArray(trK*gBar/3.0));
   end;

   ----------------------------------------------------------------------------
   -- from ADM to BSSN

   function bssn_phi  (gab :  MetricPointArray)
                       return Real
   is
      g : Real := symm_det (gab);
   begin
      return log(g)/12.0;
   end;

   function bssn_trK  (Kab :  ExtcurvPointArray;
                       gab :  MetricpointArray)
                       return Real
   is
      iab : MetricPointArray := symm_inverse (gab);
   begin
      return symm_trace (Kab, iab);
   end;

   function bssn_gBar (gab :  MetricPointArray)
                       return MetricPointArray
   is
      g : Real := symm_det (gab);
   begin
      return gab / (g**(1.0/3.0));
   end;

   function bssn_ABar (Kab :  ExtcurvPointArray;
                       gab :  MetricPointArray)
                       return ExtcurvPointArray
   is
      g   : Real := symm_det (gab);
      trK : Real := bssn_trK (Kab, gab);
   begin
      return (Kab - ExtcurvPointArray(trK*gab/3.0))/(g**(1.0/3.0));
   end;

end BSSNBase.ADM_BSSN;
