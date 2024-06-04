-- for the Real type
with Support;                use Support;

-- for text io
with Ada.Text_IO;            use Ada.Text_IO;
with Support.Strings;        use Support.Strings;

-- for data io
with ADMBase.Data_IO;

-- for parsing of the command line arguments
with Support.RegEx;          use Support.RegEx;
with Support.CmdLine;        use Support.CmdLine;

-- for evolution of initial data
with ADMBase;                use ADMBase;
with ADMBase.Evolve;
with ADMBase.Runge;

procedure ADMEvolve is

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

      if find_command_arg("-h") then

         Put_Line (" Usage: admevolve [-Cc:cmin] [-pNum] [-PInterval] [-Mmax] [-Ncores] \");
         Put_Line ("                  [-tEndTime] [-Fdt] [-Ddata] [-Oresults] [-h]");
         Put_Line ("   -Cc:cmin   : Set the Courant factor to c with minimum cmin, default: c=0.25, cmin=0.025");
         Put_Line ("   -pNum      : Report results every Num time steps, default: p=10");
         Put_Line ("   -PInterval : Report results after Interval time, default: P=1000.0");
         Put_line ("   -Mmax      : Halt after max time steps, default: M=1000");
         Put_Line ("   -NNumCores : Use NumCores on multi-core cpus, default: max. number of cores");
         Put_Line ("   -tEndTime  : Halt at this time, default: t=11.0");
         Put_Line ("   -Fdt       : Force fixed time steps of dt, default: variable time step set by Courant");
         Put_Line ("   -Ddata     : Where to find the initial data, default: data/");
         Put_Line ("   -Oresults  : Where to save the results, default: results/");
         Put_Line ("   -h         : This message.");

         Support.Halt (0);

      else

         courant         := grep (read_command_arg ("-C","0.25"),re_real_seq_1,1,fail=>0.25);
         courant_min     := grep (read_command_arg ("-C","0.25:0.025"),re_real_seq_2,3,fail=>0.025);

         print_cycle     := read_command_arg ("-p",10);
         print_time_step := read_command_arg ("-P",0.10);

         max_loop        := read_command_arg ("-M",1000);

         end_time           := read_command_arg ("-t",11.0);
         constant_time_step := read_command_arg ("-F",1.0e66);

      end if;

   end initialize;

begin

   initialize;

   echo_command_line;

   -- two data formats: must match choice with that in adminitial.adb

   -- data in binary format
   -- ADMBase.Data_IO.read_grid;
   -- ADMBase.Data_IO.read_data;

   -- data in plain text format
   ADMBase.Data_IO.read_grid_fmt;
   ADMBase.Data_IO.read_data_fmt;

   ADMBase.Evolve.evolve_data;

end ADMEvolve;
