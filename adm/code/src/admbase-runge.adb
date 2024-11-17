with Support;  use Support;

package body ADMBase.Runge is

   -- increments in data

   delta_gab_ptr : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_Kab_ptr : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   delta_N_ptr   : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   delta_gab     : MetricGridArray  renames delta_gab_ptr.all;
   delta_Kab     : ExtcurvGridArray renames delta_Kab_ptr.all;
   delta_N       : LapseGridArray   renames delta_N_ptr.all;

   -- data at start of time step

   old_gab_ptr   : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_Kab_ptr   : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   old_N_ptr     : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   old_gab       : MetricGridArray  renames old_gab_ptr.all;
   old_Kab       : ExtcurvGridArray renames old_Kab_ptr.all;
   old_N         : LapseGridArray   renames old_N_ptr.all;

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

               gab (i,j,k) :=   old_gab (i,j,k) + time_step * ct * dot_gab (i,j,k);
               Kab (i,j,k) :=   old_Kab (i,j,k) + time_step * ct * dot_Kab (i,j,k);
                 N (i,j,k) :=   old_N   (i,j,k) + time_step * ct * dot_N   (i,j,k);

         delta_gab (i,j,k) := delta_gab (i,j,k) + time_step * cw * dot_gab (i,j,k);
         delta_Kab (i,j,k) := delta_Kab (i,j,k) + time_step * cw * dot_Kab (i,j,k);
         delta_N   (i,j,k) := delta_N   (i,j,k) + time_step * cw * dot_N   (i,j,k);

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

           old_gab (i,j,k) := gab (i,j,k);
           old_Kab (i,j,k) := Kab (i,j,k);
           old_N   (i,j,k) :=   N (i,j,k);

           dot_gab (i,j,k) := (others => 0.0);
           dot_Kab (i,j,k) := (others => 0.0);
           dot_N   (i,j,k) := 0.0;

         delta_gab (i,j,k) := (others => 0.0);
         delta_Kab (i,j,k) := (others => 0.0);
         delta_N   (i,j,k) := 0.0;

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

         gab (i,j,k) :=   old_gab (i,j,k) + delta_gab (i,j,k);
         Kab (i,j,k) :=   old_Kab (i,j,k) + delta_Kab (i,j,k);
           N (i,j,k) :=   old_N   (i,j,k) + delta_N   (i,j,k);

      end loop;

      if the_task = 1 then

         the_time := the_time + time_step;

      end if;

   end end_runge_kutta;

end ADMBase.Runge;
