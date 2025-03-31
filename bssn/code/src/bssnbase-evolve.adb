with Support.Clock;                             use Support.Clock;
with Support.Timer;                             use Support.Timer;
with Support.CmdLine;                           use Support.CmdLine;
with Support.Strings;                           use Support.Strings;
with BSSNBase.Data_IO;                           use BSSNBase.Data_IO;
with BSSNBase.Text_IO;                           use BSSNBase.Text_IO;
with BSSNBase.Runge;                             use BSSNBase.Runge;
with BSSNBase.Time_Derivs;                       use BSSNBase.Time_Derivs;
with Ada.Exceptions;

with Ada.Synchronous_Barriers;
use  Ada.Synchronous_Barriers;

package body BSSNBase.Evolve is

   function set_slave_params (num_slaves : Integer) return slave_params_array
   is

      n_point : constant Integer := grid_point_num;
      n_intr  : constant Integer := interior_num;
      n_bndry : constant Integer := boundary_num;
      n_north : constant Integer := north_bndry_num;
      n_south : constant Integer := south_bndry_num;
      n_east  : constant Integer := east_bndry_num;
      n_west  : constant Integer := west_bndry_num;
      n_front : constant Integer := front_bndry_num;
      n_back  : constant Integer := back_bndry_num;

      slave_params : slave_params_array (1..num_slaves);

   begin

      -- case num_slaves is
      --
      --    when  1 | 2 | 4 | 8 | 16 => null;
      --
      --    when others => Put_Line ("> Error: range error in num_slaves, should be 1,2,4,8 or 16");
      --                   Put_Line ("> num_slaves = " & str(num_slaves,0));
      --                   halt (1);
      --
      -- end case;

      -- here we sub-divide the list of cells across the tasks.
      -- it is *essential* that the every cell appears in *exactly* one sub-list.
      -- if a cell appears in more than one sub-list then it will be processed by more
      -- than one task. doing so wastes time, but far more worrying is that such multiple
      -- processing may cause data to be overwritten and corrupted!

      for i in slave_params'Range loop
         slave_params (i).slave_id := i;
      end loop;

      slave_params (1).params ( 1) := 1;
      slave_params (1).params ( 3) := 1;
      slave_params (1).params ( 5) := 1;
      slave_params (1).params ( 7) := 1;
      slave_params (1).params ( 9) := 1;
      slave_params (1).params (11) := 1;
      slave_params (1).params (13) := 1;
      slave_params (1).params (15) := 1;
      slave_params (1).params (17) := 1;

      for i in 2 .. num_slaves loop

         slave_params (i-1).params ( 2) :=   (i-1)*n_point/num_slaves;
         slave_params (i)  .params ( 1) := 1 + slave_params (i-1).params (2);

         slave_params (i-1).params ( 4) :=   (i-1)*n_intr/num_slaves;
         slave_params (i)  .params ( 3) := 1 + slave_params (i-1).params (4);

         slave_params (i-1).params ( 6) :=   (i-1)*n_bndry/num_slaves;
         slave_params (i)  .params ( 5) := 1 + slave_params (i-1).params (6);

         slave_params (i-1).params ( 8) :=   (i-1)*n_north/num_slaves;
         slave_params (i)  .params ( 7) := 1 + slave_params (i-1).params (8);

         slave_params (i-1).params (10) :=   (i-1)*n_south/num_slaves;
         slave_params (i)  .params ( 9) := 1 + slave_params (i-1).params (10);

         slave_params (i-1).params (12) :=   (i-1)*n_east/num_slaves;
         slave_params (i)  .params (11) := 1 + slave_params (i-1).params (12);

         slave_params (i-1).params (14) :=   (i-1)*n_west/num_slaves;
         slave_params (i)  .params (13) := 1 + slave_params (i-1).params (14);

         slave_params (i-1).params (16) :=   (i-1)*n_front/num_slaves;
         slave_params (i)  .params (15) := 1 + slave_params (i-1).params (16);

         slave_params (i-1).params (18) :=   (i-1)*n_back/num_slaves;
         slave_params (i)  .params (17) := 1 + slave_params (i-1).params (18);

      end loop;

      slave_params (num_slaves).params ( 2) := n_point;
      slave_params (num_slaves).params ( 4) := n_intr;
      slave_params (num_slaves).params ( 6) := n_bndry;
      slave_params (num_slaves).params ( 8) := n_north;
      slave_params (num_slaves).params (10) := n_south;
      slave_params (num_slaves).params (12) := n_east;
      slave_params (num_slaves).params (14) := n_west;
      slave_params (num_slaves).params (16) := n_front;
      slave_params (num_slaves).params (18) := n_back;

      -- use this to verify the slave params are set correctly

      -- put_line (str(grid_point_num));
      -- for i in slave_params'Range loop
      --    put ("Slave "&str(i,2)&" params: ");
      --    for j in slave_params(i).params'Range loop
      --       put (str(slave_params(i).params(j),7)&' ');
      --    end loop;
      --    new_line;
      -- end loop;
      -- halt;

      return slave_params;

   end set_slave_params;

   procedure report_elapsed_cpu (num_points, num_loop : Integer) is
      cpu_time : Real := get_elapsed;
   begin
      put_line("> Elapsed time (secs)    : "&str(cpu_time,10));
      put_line("> Time per node per step : "&str(cpu_time/(Real(num_points)*Real(num_loop)),10));
   end report_elapsed_cpu;

   procedure evolve_data_rendezvous is

      task type SlaveTask is
         entry resume;
         entry pause;
         entry release;
         entry set_params (slave_params : slave_params_record);
      end SlaveTask;

      task body SlaveTask is
         params : slave_params_record;
      begin

         -- collect parameters for this task ------------------------

         accept set_params (slave_params : slave_params_record) do
            params := slave_params;
         end;

         loop

            select

               -- start the runge kutta --------------------------------

               accept resume;   beg_runge_kutta (params);                  accept pause;

               -- 1st step of runge-kutta ------------------------------

               accept resume;   set_time_derivatives_intr (params);        accept pause;
               accept resume;   set_time_derivatives_bndry_fb (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ew (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ns (params);    accept pause;
               accept resume;   rk_step (1.0 / 2.0, 1.0 / 6.0, params);    accept pause;

               -- 2nd step of runge-kutta ------------------------------

               accept resume;   set_time_derivatives_intr (params);        accept pause;
               accept resume;   set_time_derivatives_bndry_fb (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ew (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ns (params);    accept pause;
               accept resume;   rk_step (1.0 / 2.0, 1.0 / 3.0, params);    accept pause;

               -- 3rd step of runge-kutta ------------------------------

               accept resume;   set_time_derivatives_intr (params);        accept pause;
               accept resume;   set_time_derivatives_bndry_fb (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ew (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ns (params);    accept pause;
               accept resume;   rk_step (1.0, 1.0 / 3.0, params);          accept pause;

               -- 4th step of runge-kutta ------------------------------

               accept resume;   set_time_derivatives_intr (params);        accept pause;
               accept resume;   set_time_derivatives_bndry_fb (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ew (params);    accept pause;
               accept resume;   set_time_derivatives_bndry_ns (params);    accept pause;
               accept resume;   rk_step (0.0, 1.0 / 6.0, params);          accept pause;

               -- finish the runge kutta -------------------------------

               accept resume;   end_runge_kutta (params);                  accept pause;

            or

               -- time to release the tasks? ---------------------------

               accept release;
               exit;

            or

               terminate;  -- a safeguard, just to ensure tasks don't hang

            end select;

         end loop;

         exception
            when whoops : others =>
               Put_Line ("> Exception raised in task body");
               Put_Line (Ada.Exceptions.Exception_Information (whoops));
               halt (1);

      end SlaveTask;

      type slave_tasks_array is Array (1..num_slaves) of SlaveTask;

      slave_tasks  : slave_tasks_array;
      slave_params : slave_params_array := set_slave_params (num_slaves);

      procedure prepare_slaves is
      begin

         for i in slave_params'Range loop
            slave_tasks (i).set_params (slave_params(i));
         end loop;

      end prepare_slaves;

      procedure release_slaves is
      begin

         for i in slave_tasks'Range loop
            slave_tasks(i).release;
         end loop;

      end release_slaves;

      procedure advance_slaves is
      begin

         for i in slave_tasks'Range loop
            slave_tasks(i).resume;
         end loop;

         for i in slave_tasks'Range loop
            slave_tasks(i).pause;
         end loop;

      end advance_slaves;

      procedure runge_kutta_step is
      begin

         advance_slaves;         -- set interior time derivatives
         advance_slaves;         -- set boundary time derivatives on front & back faces
         advance_slaves;         -- set boundary time derivatives on east & west faces
         advance_slaves;         -- set boundary time derivatives on north & south faces

         -- use this to show that all d/dt are correct
         -- for the Kasner initial data, all d/dt should be equal across all grid points
         -- note the changes that arise if the order in which the boundaries are set is changed
         -- note: use this test on a small grid, e.g., 5x5x5

         -- declare
         --    i,j,k : Integer;
         -- begin
         --    for a in 1..grid_point_num loop
         --       i := grid_point_list (a).i;
         --       j := grid_point_list (a).j;
         --       k := grid_point_list (a).k;
         --       put_line (str(i)&' '&str(j)&' '&str(k)&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(1))&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(4))&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(6)));
         --    end loop;
         --    halt;
         -- end;

         advance_slaves;         -- Runge-Kutta step

      end runge_kutta_step;

      procedure evolve_one_step is
      begin

         -- 4th order RK ---

         advance_slaves;         -- prepare for a new Runge-Kutta step

         runge_kutta_step;       -- the four Runge-Kutta steps
         runge_kutta_step;
         runge_kutta_step;
         runge_kutta_step;

         advance_slaves;         -- complete the Runge-Kutta step

      end evolve_one_step;

      looping : Boolean;

   begin

      prepare_slaves;

      num_loop := 0;
      looping  := (num_loop < max_loop);

      print_time := the_time + print_time_step;

      set_time_step;
      set_time_step_min;
      set_finite_diff_factors;

      set_time_derivatives;

      create_text_io_lists;

      write_summary_header;

      write_results;
      write_summary;
      write_history;

      beg_timer;

      loop

         evolve_one_step;

         num_loop := num_loop + 1;
         looping  := (num_loop < max_loop) and (the_time < end_time - 0.5*time_step);

         if (print_cycle > 0 and then (num_loop rem print_cycle) = 0)
         or (abs (the_time-print_time) < 0.5*time_step)
         or (the_time > print_time)
         or (not looping)
         then

            write_results;
            write_summary;
            write_history;

            print_time := print_time + print_time_step;

            set_time_step;

            if time_step < time_step_min then
               raise Constraint_error with "time step too small";
            end if;

            if print_time_step < time_step then
               raise Constraint_Error with "print time step < time step";
            end if;

         end if;

         exit when not looping;

      end loop;

      end_timer;

      release_slaves;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_rendezvous");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            halt (1);

   end evolve_data_rendezvous;

   procedure evolve_data_prot_object is

      num_tasks  : Integer := num_slaves;

      -- this protected object based on the solution to
      -- exercise 20.9 Q.2 in Barnes 2012

      protected task_control is
         entry pause_task;
         entry resume_main;
         entry resume_tasks;
         entry request_stop;
         function  should_stop Return Boolean;
      private
         stop_tasks : Boolean := False;
      end task_control;

      protected body task_control is

         entry pause_task when resume_tasks'count > 0 is
         begin
            null;
         end pause_task;

         entry resume_tasks when pause_task'count = 0 is
         begin
            null;
         end resume_tasks;

         entry resume_main when pause_task'count = num_tasks is
         begin
            null;
         end resume_main;

         entry request_stop when pause_task'count = num_tasks is
         begin
            stop_tasks := True;
         end request_stop;

         function should_stop Return Boolean is
         begin
            return stop_tasks;
         end should_stop;

      end task_control;

      task type SlaveTask is
         entry set_params (slave_params : slave_params_record);
      end SlaveTask;

      task body SlaveTask is
         params : slave_params_record;
      begin

         -- collect parameters for this task ------------------------

         accept set_params (slave_params : slave_params_record) do
            params := slave_params;
         end;

         loop

            -- start the runge kutta --------------------------------

            beg_runge_kutta (params);                  task_control.pause_task;

            -- 1st step of runge-kutta ------------------------------

            set_time_derivatives_intr (params);        task_control.pause_task;
            set_time_derivatives_bndry_fb (params);    task_control.pause_task;
            set_time_derivatives_bndry_ew (params);    task_control.pause_task;
            set_time_derivatives_bndry_ns (params);    task_control.pause_task;
            rk_step (1.0 / 2.0, 1.0 / 6.0, params);    task_control.pause_task;

            -- 2nd step of runge-kutta ------------------------------

            set_time_derivatives_intr (params);        task_control.pause_task;
            set_time_derivatives_bndry_fb (params);    task_control.pause_task;
            set_time_derivatives_bndry_ew (params);    task_control.pause_task;
            set_time_derivatives_bndry_ns (params);    task_control.pause_task;
            rk_step (1.0 / 2.0, 1.0 / 3.0, params);    task_control.pause_task;

            -- 3rd step of runge-kutta ------------------------------

            set_time_derivatives_intr (params);        task_control.pause_task;
            set_time_derivatives_bndry_fb (params);    task_control.pause_task;
            set_time_derivatives_bndry_ew (params);    task_control.pause_task;
            set_time_derivatives_bndry_ns (params);    task_control.pause_task;
            rk_step (1.0, 1.0 / 3.0, params);          task_control.pause_task;

            -- 4th step of runge-kutta ------------------------------

            set_time_derivatives_intr (params);        task_control.pause_task;
            set_time_derivatives_bndry_fb (params);    task_control.pause_task;
            set_time_derivatives_bndry_ew (params);    task_control.pause_task;
            set_time_derivatives_bndry_ns (params);    task_control.pause_task;
            rk_step (0.0, 1.0 / 6.0, params);          task_control.pause_task;

            -- finish the runge kutta -------------------------------

            end_runge_kutta (params);                  task_control.pause_task;

            -- time to release the tasks? ---------------------------

            exit when task_control.should_stop;

         end loop;

         exception
            when whoops : others =>
               Put_Line ("> Exception raised in task body");
               Put_Line (Ada.Exceptions.Exception_Information (whoops));
               halt (1);

      end SlaveTask;

      type slave_tasks_array is Array (1..num_slaves) of SlaveTask;

      slave_tasks  : slave_tasks_array;
      slave_params : slave_params_array := set_slave_params (num_slaves);

      procedure prepare_slaves is
      begin

         for i in slave_params'Range loop
            slave_tasks (i).set_params (slave_params(i));
         end loop;

      end prepare_slaves;

      procedure advance_slaves is
      begin

         task_control.resume_main;
         task_control.resume_tasks;  -- one for each pause in the main task loop

      end advance_slaves;

      procedure runge_kutta_step is
      begin

         advance_slaves;         -- set interior time derivatives
         advance_slaves;         -- set boundary time derivatives on front & back faces
         advance_slaves;         -- set boundary time derivatives on east & west faces
         advance_slaves;         -- set boundary time derivatives on north & south faces

         -- use this to show that all d/dt are correct
         -- for the Kasner initial data, all d/dt should be equal across all grid points
         -- note the changes that arise if the order in which the boundaries are set is changed
         -- note: use this test on a small grid, e.g., 5x5x5

         -- declare
         --    i,j,k : Integer;
         -- begin
         --    for a in 1..grid_point_num loop
         --       i := grid_point_list (a).i;
         --       j := grid_point_list (a).j;
         --       k := grid_point_list (a).k;
         --       put_line (str(i)&' '&str(j)&' '&str(k)&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(1))&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(4))&' '&
         --                 str(BSSNBase.dot_gBar(i,j,k)(6)));
         --    end loop;
         --    halt;
         -- end;

         advance_slaves;               -- do one sub-step of Runge-Kutta

      end runge_kutta_step;

      procedure evolve_one_step is
      begin

         -- 4th order RK ---

         advance_slaves;               -- prepare for a new Runge-Kutta step

         runge_kutta_step;             -- the four sub-steps of one Runge-Kutta step
         runge_kutta_step;
         runge_kutta_step;
         runge_kutta_step;

         advance_slaves;               -- complete the Runge-Kutta step

      end evolve_one_step;

      procedure release_slaves is
      begin

         task_control.request_stop;
         evolve_one_step;              -- one extra step to flush out tasks

      end release_slaves;

      looping : Boolean;

   begin

      prepare_slaves;

      num_loop := 0;
      looping  := (num_loop < max_loop);

      print_time := the_time + print_time_step;

      set_time_step;
      set_time_step_min;
      set_finite_diff_factors;

      set_time_derivatives;

      create_text_io_lists;

      write_summary_header;

      write_results;
      write_summary;
      write_history;

      beg_timer;

      loop

         evolve_one_step;

         num_loop := num_loop + 1;
         looping  := (num_loop < max_loop) and (the_time < end_time - 0.5*time_step);

         if (print_cycle > 0 and then (num_loop rem print_cycle) = 0)
         or (abs (the_time-print_time) < 0.5*time_step)
         or (the_time > print_time)
         or (not looping)
         then

            write_results;
            write_summary;
            write_history;

            print_time := print_time + print_time_step;

            set_time_step;

            if time_step < time_step_min then
               raise Constraint_error with "time step too small";
            end if;

            if print_time_step < time_step then
               raise Constraint_Error with "print time step < time step";
            end if;

         end if;

         exit when not looping;

      end loop;

      end_timer;

      release_slaves;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_prot_object");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            halt (1);

   end evolve_data_prot_object;

   procedure evolve_data_transient_tasks is

      slave_params : slave_params_array := set_slave_params (num_slaves);

      -----------------------------------------------------------------------------
      -- this version just for the calls other than to RK

      procedure run_parallel (num_slaves : Integer;
                              run_serial : access procedure (slave_params : slave_params_record))
      is

         task type SlaveTask is
            entry start_task (slave_params : slave_params_record);
         end SlaveTask;

         task body SlaveTask is
            the_params   : slave_params_record;
            the_slave_id : Integer;
         begin

            -- collect parameters for this task ------------------------

            accept start_task (slave_params : slave_params_record) do
               the_params   := slave_params;
               the_slave_id := slave_params.slave_id;
            end;

            run_serial (the_params);

            exception
               when whoops : others =>
                  Put_Line ("> Exception raised in task body of task "&str(the_slave_id));
                  Put_Line (Ada.Exceptions.Exception_Information (whoops));
                  halt (1);              -- will kill all tasks

         end SlaveTask;

         slave_tasks : array (1..num_slaves) of SlaveTask;

      begin

         for i in slave_params'Range loop
            slave_tasks(i).start_task (slave_params(i));
         end loop;

      end run_parallel;

      -----------------------------------------------------------------------------
      -- this version just for the calls to RK

      procedure run_parallel (num_slaves : Integer;
                              run_serial : access procedure (ct, cw       : Real;
                                                             slave_params : slave_params_record);
                              ct, cw     : Real)
      is

         task type SlaveTask is
            entry start_task (slave_params : slave_params_record);
         end SlaveTask;

         task body SlaveTask is
            the_params   : slave_params_record;
            the_slave_id : Integer;
         begin

            -- collect parameters for this task ------------------------

            accept start_task (slave_params : slave_params_record) do
               the_params   := slave_params;
               the_slave_id := slave_params.slave_id;
            end;

            run_serial (ct, cw, the_params);

            exception
               when whoops : others =>
                  Put_Line ("> Exception raised in task body of task "&str(the_slave_id));
                  Put_Line (Ada.Exceptions.Exception_Information (whoops));
                  halt (1);              -- will kill all tasks

         end SlaveTask;

         slave_tasks : array (1..num_slaves) of SlaveTask;

      begin

         for i in slave_params'Range loop
            slave_tasks(i).start_task (slave_params(i));
         end loop;

      end run_parallel;

      procedure evolve_one_step is
      begin

         -- 4th order RK ---

         run_parallel (num_slaves, beg_runge_kutta'access);

         -- 1st step of runge-kutta ------------------------------

         run_parallel (num_slaves, set_time_derivatives_intr'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_fb'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ew'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ns'access);
         run_parallel (num_slaves, rk_step'access, 1.0 / 2.0, 1.0 / 6.0);

         -- 2nd step of runge-kutta ------------------------------

         run_parallel (num_slaves, set_time_derivatives_intr'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_fb'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ew'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ns'access);
         run_parallel (num_slaves, rk_step'access, 1.0 / 2.0, 1.0 / 3.0);

         -- 3rd step of runge-kutta ------------------------------

         run_parallel (num_slaves, set_time_derivatives_intr'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_fb'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ew'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ns'access);
         run_parallel (num_slaves, rk_step'access, 1.0, 1.0 / 3.0);

         -- 4th step of runge-kutta ------------------------------

         run_parallel (num_slaves, set_time_derivatives_intr'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_fb'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ew'access);
         run_parallel (num_slaves, set_time_derivatives_bndry_ns'access);
         run_parallel (num_slaves, rk_step'access, 0.0, 1.0 / 6.0);

         -- finish the runge kutta -------------------------------

         run_parallel (num_slaves, end_runge_kutta'access);

      end evolve_one_step;

      looping : Boolean;

   begin

      num_loop := 0;
      looping  := (num_loop < max_loop);

      print_time := the_time + print_time_step;

      set_time_step;
      set_time_step_min;
      set_finite_diff_factors;

      set_time_derivatives;

      create_text_io_lists;

      write_summary_header;

      write_results;
      write_summary;
      write_history;

      beg_timer;

      loop

         evolve_one_step;

         num_loop := num_loop + 1;
         looping  := (num_loop < max_loop) and (the_time < end_time - 0.5*time_step);

         if (print_cycle > 0 and then (num_loop rem print_cycle) = 0)
         or (abs (the_time-print_time) < 0.5*time_step)
         or (the_time > print_time)
         or (not looping)
         then

            write_results;
            write_summary;
            write_history;

            print_time := print_time + print_time_step;

            set_time_step;

            if time_step < time_step_min then
               raise Constraint_error with "time step too small";
            end if;

            if print_time_step < time_step then
               raise Constraint_Error with "print time step < time step";
            end if;

         end if;

         exit when not looping;

      end loop;

      end_timer;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_rendezvous");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            halt (1);

   end evolve_data_transient_tasks;

   procedure evolve_data_sync_barrier is

      sync_barrier : Synchronous_Barrier (num_slaves);
      notified     : Boolean := False;

      task type SlaveTask is
         entry parallel;
         entry serial;
         entry release;
         entry set_params (slave_params : slave_params_record);
      end SlaveTask;

      task body SlaveTask is
         params : slave_params_record;
      begin

         -- collect parameters for this task ------------------------

         accept set_params (slave_params : slave_params_record) do
            params := slave_params;
         end;

         loop

            select

               accept parallel;

               -- start the runge kutta --------------------------------

               beg_runge_kutta (params);                  Wait_For_Release (sync_barrier, notified);

               -- 1st step of runge-kutta ------------------------------

               set_time_derivatives_intr (params);        Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_fb (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ew (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ns (params);    Wait_For_Release (sync_barrier, notified);
               rk_step (1.0 / 2.0, 1.0 / 6.0, params);    Wait_For_Release (sync_barrier, notified);

               -- 2nd step of runge-kutta ------------------------------

               set_time_derivatives_intr (params);        Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_fb (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ew (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ns (params);    Wait_For_Release (sync_barrier, notified);
               rk_step (1.0 / 2.0, 1.0 / 3.0, params);    Wait_For_Release (sync_barrier, notified);

               -- 3rd step of runge-kutta ------------------------------

               set_time_derivatives_intr (params);        Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_fb (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ew (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ns (params);    Wait_For_Release (sync_barrier, notified);
               rk_step (1.0, 1.0 / 3.0, params);          Wait_For_Release (sync_barrier, notified);

               -- 4th step of runge-kutta ------------------------------

               set_time_derivatives_intr (params);        Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_fb (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ew (params);    Wait_For_Release (sync_barrier, notified);
               set_time_derivatives_bndry_ns (params);    Wait_For_Release (sync_barrier, notified);
               rk_step (0.0, 1.0 / 6.0, params);          Wait_For_Release (sync_barrier, notified);

               -- finish the runge kutta -------------------------------

               end_runge_kutta (params);                  -- Wait_For_Release (sync_barrier, notified);
                                                          -- note: the above Wait_For_Release is redundant
                                                          --       why? beacuse the following "accept serial"
                                                          --       will do the same job

               accept serial;

            or

               -- time to release the tasks? ---------------------------

               accept release;
               exit;

            or

               terminate;  -- a safeguard, just to ensure tasks don't hang

            end select;

         end loop;

         exception
            when whoops : others =>
               Put_Line ("> Exception raised in task body");
               Put_Line (Ada.Exceptions.Exception_Information (whoops));
               halt (1);

      end SlaveTask;

      type slave_tasks_array is Array (1..num_slaves) of SlaveTask;

      slave_tasks  : slave_tasks_array;
      slave_params : slave_params_array := set_slave_params (num_slaves);

      procedure prepare_slaves is
      begin

         for i in slave_params'Range loop
            slave_tasks (i).set_params (slave_params(i));
         end loop;

      end prepare_slaves;

      procedure release_slaves is
      begin

         for i in slave_tasks'Range loop
            slave_tasks(i).release;
         end loop;

      end release_slaves;

      procedure advance_slaves is
      begin

         -- will start all slaves working on the body of the Runge-Kutta computations

         for i in slave_tasks'Range loop
            slave_tasks(i).parallel;
         end loop;

         -- now all slaves are running in parallel

         -- force the main thread to pause while waiting for all
         -- slaves to accept this batch of entry calls

         for i in slave_tasks'Range loop
            slave_tasks(i).serial;
         end loop;

         -- now running on just the main thread
         -- all slaves are paused

      end advance_slaves;

      procedure evolve_one_step is
      begin

         advance_slaves;

      end evolve_one_step;

      looping : Boolean;

   begin

      prepare_slaves;

      num_loop := 0;
      looping  := (num_loop < max_loop);

      print_time := the_time + print_time_step;

      set_time_step;
      set_time_step_min;
      set_finite_diff_factors;

      set_time_derivatives;

      create_text_io_lists;

      write_summary_header;

      write_results;
      write_summary;
      write_history;

      beg_timer;

      loop

         evolve_one_step;

         num_loop := num_loop + 1;
         looping  := (num_loop < max_loop) and (the_time < end_time - 0.5*time_step);

         if (print_cycle > 0 and then (num_loop rem print_cycle) = 0)
         or (abs (the_time-print_time) < 0.5*time_step)
         or (the_time > print_time)
         or (not looping)
         then

            write_results;
            write_summary;
            write_history;

            print_time := print_time + print_time_step;

            set_time_step;

            if time_step < time_step_min then
               raise Constraint_error with "time step too small";
            end if;

            if print_time_step < time_step then
               raise Constraint_Error with "print time step < time step";
            end if;

         end if;

         exit when not looping;

      end loop;

      end_timer;

      release_slaves;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_rendezvous");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            halt (1);

   end evolve_data_sync_barrier;

end BSSNBase.Evolve;
