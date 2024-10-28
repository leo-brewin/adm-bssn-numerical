-- for the Real type
with Support;                use Support;

-- for text io
with Ada.Text_IO;            use Ada.Text_IO;
with Support.Strings;        use Support.Strings;

-- for data io
with BSSNBase.Data_IO;

-- for parsing of the command line arguments
with Support.RegEx;          use Support.RegEx;
with Support.CmdLine;        use Support.CmdLine;

-- for evolution of initial data
with BSSNBase;               use BSSNBase;
with BSSNBase.Evolve;
with BSSNBase.Runge;

-- to get the number of avalaible cpus/cores
with System.Multiprocessors;

procedure BSSNEvolve is

   package Real_IO    is new Ada.Text_IO.Float_IO (Real);        use Real_IO;
   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);   use Integer_IO;

   procedure initialize is
      re_intg : String := "([-+]?[0-9]+)";
      re_real : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
      re_intg_seq : String := re_intg&"x"&re_intg&"x"&re_intg;
      re_real_seq_1 : String := re_real;
      re_real_seq_2 : String := re_real&":"&re_real;
      re_real_seq_3 : String := re_real&":"&re_real&":"&re_real;
   begin

      if find_command_arg("--Help") then

         Put_Line (" Usage: bssnevolve [options]");
         Put_Line ("   --Courant       0.25:0.025 : Set the Courant factor and its minimum value.");
         Put_Line ("   --PrintCycle    10         : Report results every this many time steps.");
         Put_Line ("   --PrintTimeStep 0.1        : Report results after this lapse of time. ");
         Put_line ("   --MaxTimeSteps  1000       : Maximum number of time steps.");
         Put_Line ("   --NumCores      4          : How many cores to use for multi-tasking.");
         Put_Line ("   --Tfinal        11.0       : Halt at this time.");
         Put_Line ("   --FixedTimeTeps 0.1        : Force fixed time steps.");
         Put_Line ("   --DataDir       data       : Where to find the initial data.");
         Put_Line ("   --OutputDir     results    : Where to save the results.");
         Put_Line ("   --UseRendezvous             : Use rendezvous calls for multitasking, otherwise");
         Put_Line ("                                use a protected object.");
         Put_Line ("   --Help                     : This message.");

         Support.Halt (0);

      else

         courant         := grep (read_command_arg ("--Courant","0.25"),re_real_seq_1,1,fail=>0.25);
         courant_min     := grep (read_command_arg ("--Courant","0.25:0.025"),re_real_seq_2,3,fail=>0.025);

         print_cycle     := read_command_arg ("--PrintCycle",10);
         print_time_step := read_command_arg ("--PrintTimeStep",0.10);

         max_loop        := read_command_arg ("--MaxTimeSteps",1000);

         end_time           := read_command_arg ("--Tfinal",11.0);
         constant_time_step := read_command_arg ("--FixedTimeStep",1.0e66);

         num_cpus   := Integer (System.Multiprocessors.Number_Of_CPUs);
         num_slaves := read_command_arg ("--NumCores",num_cpus);

      end if;

   end initialize;

begin

   initialize;

   echo_command_line;

   -- two data formats: must match choice with that in adminitial.adb

   -- data in binary format
   -- BSSNBase.Data_IO.read_grid;
   -- BSSNBase.Data_IO.read_data;

   -- data in plain text format
   BSSNBase.Data_IO.read_grid_fmt;
   BSSNBase.Data_IO.read_data_fmt;

   if find_command_arg("--UseRendezvous")
      then BSSNBase.Evolve.evolve_data_rendezvous;
      else BSSNBase.Evolve.evolve_data_prot_object;
   end if;

end BSSNEvolve;
