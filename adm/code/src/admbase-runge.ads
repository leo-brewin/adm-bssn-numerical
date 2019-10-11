package ADMBase.Runge is

   procedure set_time_step;
   procedure set_time_step_min;

   procedure rk_step
     (ct : Real;
      cw : Real;
      params : SlaveParams);

   procedure beg_runge_kutta
     (params : SlaveParams);

   procedure end_runge_kutta
     (params : SlaveParams);

end ADMBase.Runge;
