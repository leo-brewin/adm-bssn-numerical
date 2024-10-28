with Support.Clock;                             use Support.Clock;
with Support.CmdLine;                           use Support.CmdLine;
with Support.Strings;                           use Support.Strings;
with ADMBase.Data_IO;                           use ADMBase.Data_IO;
with ADMBase.Text_IO;                           use ADMBase.Text_IO;
with ADMBase.Runge;                             use ADMBase.Runge;
with ADMBase.Time_Derivs;                       use ADMBase.Time_Derivs;
with Ada.Exceptions;

package body ADMBase.Evolve is

   procedure evolve_data_rendezvous is

      task type SlaveTask is
         entry resume;
         entry pause;
         entry release;
         entry set_params (slave_params : SlaveParams);
      end SlaveTask;

      task body SlaveTask is
         params : SlaveParams;
      begin

         -- collect parameters for this task ------------------------

         accept set_params (slave_params : SlaveParams) do
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
               report_elapsed_cpu (grid_point_num, num_loop);
               halt (1);

      end SlaveTask;

      slave_tasks  : array (1..num_slaves) of SlaveTask;
      slave_params : array (1..num_slaves) of SlaveParams;

      procedure prepare_slaves is
         n_point : constant Integer := grid_point_num;
         n_intr  : constant Integer := interior_num;
         n_bndry : constant Integer := boundary_num;
         n_north : constant Integer := north_bndry_num;
         n_south : constant Integer := south_bndry_num;
         n_east  : constant Integer := east_bndry_num;
         n_west  : constant Integer := west_bndry_num;
         n_front : constant Integer := front_bndry_num;
         n_back  : constant Integer := back_bndry_num;
      begin

         case num_slaves is

            when  1 | 2 | 4 | 8 | 16 => null;

            when others => Put_Line ("> Error: range error in num_slaves, should be 1,2,4,8 or 16");
                           Put_Line ("> num_slaves = " & str(num_slaves,0));
                           halt (1);

         end case;

         -- here we sub-divide the list of cells across the tasks.
         -- it is *essential* that the every cell appears in *exactly* one sub-list.
         -- if a cell appears in more than one sub-list then it will be processed by more
         -- than one task. doing so wastes time, but far more worrying is that such multiple
         -- processing may cause data to be overwritten and corrupted!

         for i in slave_params'range loop
            slave_params (i)(1) := i;
         end loop;

         slave_params (1)( 2) := 1;
         slave_params (1)( 4) := 1;
         slave_params (1)( 6) := 1;
         slave_params (1)( 8) := 1;
         slave_params (1)(10) := 1;
         slave_params (1)(12) := 1;
         slave_params (1)(14) := 1;
         slave_params (1)(16) := 1;
         slave_params (1)(18) := 1;

         for i in 2 .. num_slaves loop

            slave_params (i-1)( 3) :=   (i-1)*n_point/num_slaves;
            slave_params (i)(2)    := 1 + slave_params (i-1)(3);

            slave_params (i-1)( 5) :=   (i-1)*n_intr/num_slaves;
            slave_params (i)(4)    := 1 + slave_params (i-1)(5);

            slave_params (i-1)( 7) :=   (i-1)*n_bndry/num_slaves;
            slave_params (i)(6)    := 1 + slave_params (i-1)(7);

            slave_params (i-1)( 9) :=   (i-1)*n_north/num_slaves;
            slave_params (i)(8)    := 1 + slave_params (i-1)(9);

            slave_params (i-1)(11) :=   (i-1)*n_south/num_slaves;
            slave_params (i)(10)    := 1 + slave_params (i-1)(11);

            slave_params (i-1)(13) :=   (i-1)*n_east/num_slaves;
            slave_params (i)(12)   := 1 + slave_params (i-1)(13);

            slave_params (i-1)(15) :=   (i-1)*n_west/num_slaves;
            slave_params (i)(14)   := 1 + slave_params (i-1)(15);

            slave_params (i-1)(17) :=   (i-1)*n_front/num_slaves;
            slave_params (i)(16)   := 1 + slave_params (i-1)(17);

            slave_params (i-1)(19) :=   (i-1)*n_back/num_slaves;
            slave_params (i)(18)   := 1 + slave_params (i-1)(19);

         end loop;

         slave_params (num_slaves)( 3) := n_point;
         slave_params (num_slaves)( 5) := n_intr;
         slave_params (num_slaves)( 7) := n_bndry;
         slave_params (num_slaves)( 9) := n_north;
         slave_params (num_slaves)(11) := n_south;
         slave_params (num_slaves)(13) := n_east;
         slave_params (num_slaves)(15) := n_west;
         slave_params (num_slaves)(17) := n_front;
         slave_params (num_slaves)(19) := n_back;

         for i in 1..num_slaves loop
            slave_tasks(i).set_params (slave_params(i));
         end loop;

         -- use this to verify the slave params are set correctly

         -- for i in slave_params'Range loop
         --    put ("Slave "&str(i,2)&" params: ");
         --    for j in slave_params(i)'Range loop
         --       put (str(slave_params(i)(j),7)&' ');
         --    end loop;
         --    new_line;
         -- end loop;
         -- halt;

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
         --                 str(ADMBase.dot_gab(i,j,k)(1))&' '&
         --                 str(ADMBase.dot_gab(i,j,k)(4))&' '&
         --                 str(ADMBase.dot_gab(i,j,k)(6)));
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

      reset_elapsed_cpu;

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

      release_slaves;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_rendezvous");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            report_elapsed_cpu (grid_point_num, num_loop);
            halt (1);

   end evolve_data_rendezvous;

   procedure evolve_data_prot_object is

      num_tasks  : Integer := num_slaves;

      -- this protected object based on the solution to
      -- exercise 20.9 Q.2 in Barnes 2012

      protected task_control is
         entry pause_task;
         entry sync_tasks;
         entry resume_tasks;
         procedure stop;
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

         entry sync_tasks when pause_task'count = num_tasks is
         begin
            null;
         end sync_tasks;

         procedure stop is
         begin
            stop_tasks := True;
         end stop;

         function should_stop Return Boolean is
         begin
            return stop_tasks;
         end should_stop;

      end task_control;

      task type SlaveTask is
         entry set_params (slave_params : SlaveParams);
      end SlaveTask;

      task body SlaveTask is
         params : SlaveParams;
      begin

         -- collect parameters for this task ------------------------

         accept set_params (slave_params : SlaveParams) do
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
               report_elapsed_cpu (grid_point_num, num_loop);
               halt (1);

      end SlaveTask;

      slave_tasks  : array (1..num_slaves) of SlaveTask;
      slave_params : array (1..num_slaves) of SlaveParams;

      procedure prepare_slaves is
         n_point : constant Integer := grid_point_num;
         n_intr  : constant Integer := interior_num;
         n_bndry : constant Integer := boundary_num;
         n_north : constant Integer := north_bndry_num;
         n_south : constant Integer := south_bndry_num;
         n_east  : constant Integer := east_bndry_num;
         n_west  : constant Integer := west_bndry_num;
         n_front : constant Integer := front_bndry_num;
         n_back  : constant Integer := back_bndry_num;
      begin

         case num_slaves is

            when  1 | 2 | 4 | 8 | 16 => null;

            when others => Put_Line ("> Error: range error in num_slaves, should be 1,2,4,8 or 16");
                           Put_Line ("> num_slaves = " & str(num_slaves,0));
                           halt (1);

         end case;

         -- here we sub-divide the list of cells across the tasks.
         -- it is *essential* that the every cell appears in *exactly* one sub-list.
         -- if a cell appears in more than one sub-list then it will be processed by more
         -- than one task. doing so wastes time, but far more worrying is that such multiple
         -- processing may cause data to be overwritten!

         for i in slave_params'range loop
            slave_params (i)(1) := i;
         end loop;

         slave_params (1)( 2) := 1;
         slave_params (1)( 4) := 1;
         slave_params (1)( 6) := 1;
         slave_params (1)( 8) := 1;
         slave_params (1)(10) := 1;
         slave_params (1)(12) := 1;
         slave_params (1)(14) := 1;
         slave_params (1)(16) := 1;
         slave_params (1)(18) := 1;

         for i in 2 .. num_slaves loop

            slave_params (i-1)( 3) :=   (i-1)*n_point/num_slaves;
            slave_params (i)(2)    := 1 + slave_params (i-1)(3);

            slave_params (i-1)( 5) :=   (i-1)*n_intr/num_slaves;
            slave_params (i)(4)    := 1 + slave_params (i-1)(5);

            slave_params (i-1)( 7) :=   (i-1)*n_bndry/num_slaves;
            slave_params (i)(6)    := 1 + slave_params (i-1)(7);

            slave_params (i-1)( 9) :=   (i-1)*n_north/num_slaves;
            slave_params (i)(8)    := 1 + slave_params (i-1)(9);

            slave_params (i-1)(11) :=   (i-1)*n_south/num_slaves;
            slave_params (i)(10)    := 1 + slave_params (i-1)(11);

            slave_params (i-1)(13) :=   (i-1)*n_east/num_slaves;
            slave_params (i)(12)   := 1 + slave_params (i-1)(13);

            slave_params (i-1)(15) :=   (i-1)*n_west/num_slaves;
            slave_params (i)(14)   := 1 + slave_params (i-1)(15);

            slave_params (i-1)(17) :=   (i-1)*n_front/num_slaves;
            slave_params (i)(16)   := 1 + slave_params (i-1)(17);

            slave_params (i-1)(19) :=   (i-1)*n_back/num_slaves;
            slave_params (i)(18)   := 1 + slave_params (i-1)(19);

         end loop;

         slave_params (num_slaves)( 3) := n_point;
         slave_params (num_slaves)( 5) := n_intr;
         slave_params (num_slaves)( 7) := n_bndry;
         slave_params (num_slaves)( 9) := n_north;
         slave_params (num_slaves)(11) := n_south;
         slave_params (num_slaves)(13) := n_east;
         slave_params (num_slaves)(15) := n_west;
         slave_params (num_slaves)(17) := n_front;
         slave_params (num_slaves)(19) := n_back;

         for i in 1..num_slaves loop
            slave_tasks (i).set_params (slave_params(i));
         end loop;

         -- use this to verify the slave params are set correctly

         -- for i in slave_params'Range loop
         --    put ("Slave "&str(i,2)&" params: ");
         --    for j in slave_params(i)'Range loop
         --       put (str(slave_params(i)(j),7)&' ');
         --    end loop;
         --    new_line;
         -- end loop;
         -- halt;

      end prepare_slaves;

      procedure release_slaves is
      begin

         -- need this to force all tasks to pause at the very last pause
         -- before the "exit when ..." line in the main task loop (i.e., after step 14)
         -- doing so then ensures each task catches the "should_stop" condition

         for i in 1..21 loop          -- there are 22 pause_task's in the SlaveTask main loop

            task_control.sync_tasks;
            task_control.resume_tasks;

         end loop;

         task_control.sync_tasks;
         task_control.stop;           -- all tasks sitting on the last pause_task, can now set the stop_task flag
         task_control.resume_tasks;   -- task restarts and then hits the "exit when" test

      end release_slaves;

      procedure advance_slaves is
      begin

         task_control.sync_tasks;
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
         --                 str(ADMBase.dot_gBar(i,j,k)(1))&' '&
         --                 str(ADMBase.dot_gBar(i,j,k)(4))&' '&
         --                 str(ADMBase.dot_gBar(i,j,k)(6)));
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

      reset_elapsed_cpu;

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

      release_slaves;

      write_summary_trailer;

      report_elapsed_cpu (grid_point_num, num_loop);

      exception
         when whoops : others =>
            Put_Line ("> Exception raised in evolve_data_prot_object");
            Put_Line (Ada.Exceptions.Exception_Information (whoops));
            report_elapsed_cpu (grid_point_num, num_loop);
            halt (1);

   end evolve_data_prot_object;

end ADMBase.Evolve;
