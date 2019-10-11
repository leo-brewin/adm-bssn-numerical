package ADMBase.Time_Derivs is

   procedure set_finite_diff_factors;

   procedure set_time_derivatives_intr
     (params : SlaveParams);

   procedure set_time_derivatives_bndry_ns
     (params : SlaveParams);

   procedure set_time_derivatives_bndry_ew
     (params : SlaveParams);

   procedure set_time_derivatives_bndry_fb
     (params : SlaveParams);

   procedure set_time_derivatives
     (point : GridPoint);

   procedure set_time_derivatives;

end ADMBase.Time_Derivs;
