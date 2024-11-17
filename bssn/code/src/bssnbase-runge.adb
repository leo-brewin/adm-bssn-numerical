with Support;  use Support;

package body BSSNBase.Runge is

   -- increments in data

   delta_gBar_ptr : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_ABar_ptr : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_N_ptr    : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_phi_ptr  : ConFactGridArray_ptr := new ConFactGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_trK_ptr  : TraceKGridArray_ptr  := new TraceKGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_Gi_ptr   : GammaGridArray_ptr   := new GammaGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   delta_gBar     : MetricGridArray  renames delta_gBar_ptr.all;
   delta_ABar     : ExtcurvGridArray renames delta_ABar_ptr.all;
   delta_N        : LapseGridArray   renames delta_N_ptr.all;
   delta_phi      : ConFactGridArray renames delta_phi_ptr.all;
   delta_trK      : TraceKGridArray  renames delta_trK_ptr.all;
   delta_Gi       : GammaGridArray   renames delta_Gi_ptr.all;

   -- data at start of time step

   old_gBar_ptr   : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_ABar_ptr   : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_N_ptr      : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_phi_ptr    : ConFactGridArray_ptr := new ConFactGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_trK_ptr    : TraceKGridArray_ptr  := new TraceKGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_Gi_ptr     : GammaGridArray_ptr   := new GammaGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   old_gBar       : MetricGridArray  renames old_gBar_ptr.all;
   old_ABar       : ExtcurvGridArray renames old_ABar_ptr.all;
   old_N          : LapseGridArray   renames old_N_ptr.all;
   old_phi        : ConFactGridArray renames old_phi_ptr.all;
   old_trK        : TraceKGridArray  renames old_trK_ptr.all;
   old_Gi         : GammaGridArray   renames old_Gi_ptr.all;

   -- the_time at start of time step

   old_time      : Real;

   procedure set_time_step is
      courant_time_step : Real;
   begin
      courant_time_step := courant * min ( dx, min (dy,dz) );
      time_step := min (courant_time_step, constant_time_step);
   end set_time_step;

   procedure set_time_step_min is
      courant_time_step : Real;
   begin
      courant_time_step := courant_min * min ( dx, min (dy,dz) );
      time_step_min := min (courant_time_step, constant_time_step);
   end set_time_step_min;

   procedure rk_step
     (ct : Real;
      cw : Real;
      params : slave_params_record)
   is
      i, j, k   : Integer;
      the_task  : Integer := params.slave_id;
      beg_point : Integer := params.params (1);
      end_point : Integer := params.params (2);
   begin

      for b in beg_point .. end_point loop

         i := grid_point_list (b).i;
         j := grid_point_list (b).j;
         k := grid_point_list (b).k;

               gBar (i,j,k) :=   old_gBar (i,j,k) + time_step * ct * dot_gBar (i,j,k);
               ABar (i,j,k) :=   old_ABar (i,j,k) + time_step * ct * dot_ABar (i,j,k);
                  N (i,j,k) :=   old_N    (i,j,k) + time_step * ct * dot_N    (i,j,k);
                phi (i,j,k) :=   old_phi  (i,j,k) + time_step * ct * dot_phi  (i,j,k);
                trK (i,j,k) :=   old_trK  (i,j,k) + time_step * ct * dot_trK  (i,j,k);
                 Gi (i,j,k) :=   old_Gi   (i,j,k) + time_step * ct * dot_Gi   (i,j,k);

         delta_gBar (i,j,k) := delta_gBar (i,j,k) + time_step * cw * dot_gBar (i,j,k);
         delta_ABar (i,j,k) := delta_ABar (i,j,k) + time_step * cw * dot_ABar (i,j,k);
         delta_N    (i,j,k) := delta_N    (i,j,k) + time_step * cw * dot_N    (i,j,k);
         delta_phi  (i,j,k) := delta_phi  (i,j,k) + time_step * cw * dot_phi  (i,j,k);
         delta_trK  (i,j,k) := delta_trK  (i,j,k) + time_step * cw * dot_trK  (i,j,k);
         delta_Gi   (i,j,k) := delta_Gi   (i,j,k) + time_step * cw * dot_Gi   (i,j,k);

      end loop;

      if the_task = 1 then

         the_time := old_time + time_step * ct;

      end if;

   end rk_step;

   procedure beg_runge_kutta
     (params : slave_params_record)
   is
      i, j, k   : Integer;
      the_task  : Integer := params.slave_id;
      beg_point : Integer := params.params (1);
      end_point : Integer := params.params (2);
   begin

      for b in beg_point .. end_point loop

         i := grid_point_list (b).i;
         j := grid_point_list (b).j;
         k := grid_point_list (b).k;

           old_gBar (i,j,k) := gBar (i,j,k);
           old_ABar (i,j,k) := ABar (i,j,k);
           old_N    (i,j,k) :=    N (i,j,k);
           old_phi  (i,j,k) :=  phi (i,j,k);
           old_trK  (i,j,k) :=  trK (i,j,k);
           old_Gi   (i,j,k) :=   Gi (i,j,k);

           dot_gBar (i,j,k) := (others => 0.0);
           dot_ABar (i,j,k) := (others => 0.0);
           dot_N    (i,j,k) := 0.0;
           dot_phi  (i,j,k) := 0.0;
           dot_trK  (i,j,k) := 0.0;
           dot_Gi   (i,j,k) := (others => 0.0);

         delta_gBar (i,j,k) := (others => 0.0);
         delta_ABar (i,j,k) := (others => 0.0);
         delta_N    (i,j,k) := 0.0;
         delta_phi  (i,j,k) := 0.0;
         delta_trK  (i,j,k) := 0.0;
         delta_Gi   (i,j,k) := (others => 0.0);

      end loop;

      if the_task = 1 then

         old_time := the_time;

      end if;

   end beg_runge_kutta;

   procedure end_runge_kutta
     (params : slave_params_record)
   is
      i, j, k   : Integer;
      the_task  : Integer := params.slave_id;
      beg_point : Integer := params.params (1);
      end_point : Integer := params.params (2);
   begin

      for b in beg_point .. end_point loop

         i := grid_point_list (b).i;
         j := grid_point_list (b).j;
         k := grid_point_list (b).k;

         gBar (i,j,k) := old_gBar (i,j,k) + delta_gBar (i,j,k);
         ABar (i,j,k) := old_ABar (i,j,k) + delta_ABar (i,j,k);
            N (i,j,k) := old_N    (i,j,k) + delta_N    (i,j,k);
          phi (i,j,k) := old_phi  (i,j,k) + delta_phi  (i,j,k);
          trK (i,j,k) := old_trK  (i,j,k) + delta_trK  (i,j,k);
           Gi (i,j,k) := old_Gi   (i,j,k) + delta_Gi   (i,j,k);

      end loop;

      if the_task = 1 then

         the_time := the_time + time_step;

      end if;

   end end_runge_kutta;

end BSSNBase.Runge;
