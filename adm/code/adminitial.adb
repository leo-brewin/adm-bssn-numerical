with Ada.Text_IO;            use Ada.Text_IO;

-- for access to Halt
with Support;

-- for parsing of the command line arguments
with Support.RegEx;          use Support.RegEx;
with Support.CmdLine;        use Support.CmdLine;

-- for time functions
with Support.Clock;          use Support.Clock;

-- for setup of initial data
with ADMBase;                use ADMBase;
with ADMBase.Initial;

-- for data io
with ADMBase.Data_IO;

with Metric.Kasner;          use Metric.Kasner;

procedure ADMInitial is

   procedure initialize is
      re_intg : String := "([-+]?[0-9]+)";
      re_real : String := "([-+]?[0-9]*[.]?[0-9]+([eE][-+]?[0-9]+)?)"; -- note counts as 2 groups (1.234(e+56))
      re_intg_seq : String := re_intg&"x"&re_intg&"x"&re_intg;
      re_real_seq : String := re_real&":"&re_real&":"&re_real;
   begin

      if find_command_arg("--Help") then

         Put_Line (" Usage: adminitial [options]");
         Put_Line ("   --GridNum   20x20x20    : Create a grid with 20 by 20 by 20 grid points.");
         Put_Line ("   --GridDelta 0.1:0.1:0.1 : Grid spacings are Dx, Dy and Dz.");
         Put_Line ("   --KasnerPi  p1:p2:p3    : p1, p2, and p3 are the Kasner parameters, default: p1=p2=2/3, p3=-1/3");
         Put_line ("   --DataDir   data        : Where to save the data.");
         Put_Line ("   --InitialT  1.0         : Set the initial time.");
         Put_Line ("   --Help                  : This message.");

         Support.Halt (0);

      else

         beg_time := read_command_arg ("--InitialT",1.0);

         dx       := grep (read_command_arg ("--GridDelta","0.1:0.1:0.1"),re_real_seq,1,fail=>0.1);
         dy       := grep (read_command_arg ("--GridDelta","0.1:0.1:0.1"),re_real_seq,3,fail=>0.1);
         dz       := grep (read_command_arg ("--GridDelta","0.1:0.1:0.1"),re_real_seq,5,fail=>0.1);

         num_x    := grep (read_command_arg ("--GridNum","20x20x20"),re_intg_seq,1,fail=>20);
         num_y    := grep (read_command_arg ("--GridNum","20x20x20"),re_intg_seq,2,fail=>20);
         num_z    := grep (read_command_arg ("--GridNum","20x20x20"),re_intg_seq,3,fail=>20);

         the_time := beg_time;

         grid_point_num := num_x * num_y * num_z;

      end if;

   end initialize;

begin

   initialize;

   echo_date;
   echo_command_line;

   report_kasner_params;

   ADMBase.Initial.create_grid;
   ADMBase.Initial.create_data;

   -- two ways to save the data

   -- these use binary format for the data, not for human consumption
   -- ADMBase.Data_IO.write_grid;
   -- ADMBase.Data_IO.write_data;
   --
   -- ADMBase.Data_IO.read_grid;
   -- ADMBase.Data_IO.read_data;

   -- these use plain text format for the data, safe for humans
   ADMBase.Data_IO.write_grid_fmt;
   ADMBase.Data_IO.write_data_fmt;

   ADMBase.Data_IO.read_grid_fmt;
   ADMBase.Data_IO.read_data_fmt;

end ADMInitial;
