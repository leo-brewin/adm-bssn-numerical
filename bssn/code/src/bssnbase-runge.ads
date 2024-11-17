package BSSNBase.Runge is

   procedure set_time_step;
   procedure set_time_step_min;

   procedure rk_step
     (ct : Real;
      cw : Real;
      params : slave_params_record);

   procedure beg_runge_kutta
     (params : slave_params_record);

   procedure end_runge_kutta
     (params : slave_params_record);

end BSSNBase.Runge;
