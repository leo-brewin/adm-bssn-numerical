package ADMBase.Time_Derivs is

   procedure set_finite_diff_factors;

   procedure set_time_derivatives_intr
     (params : slave_params_record);

   procedure set_time_derivatives_bndry_ns
     (params : slave_params_record);

   procedure set_time_derivatives_bndry_ew
     (params : slave_params_record);

   procedure set_time_derivatives_bndry_fb
     (params : slave_params_record);

   procedure set_time_derivatives
     (point : GridPoint);

   procedure set_time_derivatives;

end ADMBase.Time_Derivs;
