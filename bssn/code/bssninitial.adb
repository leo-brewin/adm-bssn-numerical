with Ada.Text_IO;             use Ada.Text_IO;

-- for access to Halt
with Support;

-- for parsing of the command line arguments
with Support.RegEx;           use Support.RegEx;
with Support.CmdLine;         use Support.CmdLine;

-- for setup of initial data
with BSSNBase;                use BSSNBase;
with BSSNBase.Initial;

-- for data io
with BSSNBase.Data_IO;

with Metric.Kasner;           use Metric.Kasner;

procedure BSSNInitial is

   procedure initialize is
      re_intg : String := "([-+]?[0-9]+)";
      re_real : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
      re_intg_seq : String := re_intg&"x"&re_intg&"x"&re_intg;
      re_real_seq : String := re_real&":"&re_real&":"&re_real;
   begin

      if find_command_arg("-h") then

         Put_Line (" Usage: bssninitial [-nPxQxR] [-dDx:Dy:Dz] [-pp1:p2:p3] [-Ddata] [-tTime] [-h]");
         Put_Line ("   -nPxQxR    : Create a grid with P by Q by NR grid points, default: P=Q=R=20");
         Put_Line ("   -dDx:Dy:Dz : Grid spacings are Dx, Dy and Dz, default: Dx=Dy=Dz=0.1");
         Put_Line ("   -pp1:p2:p3 : p1, p2, and p3 are the Kasner parameters, default: p1=p2=2/3, p3=-1/3");
         Put_line ("   -Ddata     : Where to save the data, default: data/");
         Put_Line ("   -tTime     : Set the initial time, default: T=1");
         Put_Line ("   -h         : This message.");

         Support.Halt (0);

      else

         beg_time := read_command_arg ("-t",1.0);

         dx       := grep (read_command_arg ("-d","0.1:0.1:0.1"),re_real_seq,1,fail=>0.1);
         dy       := grep (read_command_arg ("-d","0.1:0.1:0.1"),re_real_seq,3,fail=>0.1);
         dz       := grep (read_command_arg ("-d","0.1:0.1:0.1"),re_real_seq,5,fail=>0.1);

         num_x    := grep (read_command_arg ("-n","20x20x20"),re_intg_seq,1,fail=>20);
         num_y    := grep (read_command_arg ("-n","20x20x20"),re_intg_seq,2,fail=>20);
         num_z    := grep (read_command_arg ("-n","20x20x20"),re_intg_seq,3,fail=>20);

         the_time := beg_time;
         grid_point_num := num_x * num_y * num_z;

      end if;

   end initialize;

begin

   initialize;

   echo_command_line;
   report_kasner_params;

   BSSNBase.Initial.create_grid;
   BSSNBase.Initial.create_data;

   -- two ways to save the data

   -- these use binary format for the data, not for human consumption
   -- BSSNBase.Data_IO.write_grid;
   -- BSSNBase.Data_IO.write_data;
   --
   -- BSSNBase.Data_IO.read_grid;
   -- BSSNBase.Data_IO.read_data;

   -- these use plain text format for the data, safe for humans
   BSSNBase.Data_IO.write_grid_fmt;
   BSSNBase.Data_IO.write_data_fmt;

   BSSNBase.Data_IO.read_grid_fmt;
   BSSNBase.Data_IO.read_data_fmt;

end BSSNInitial;
