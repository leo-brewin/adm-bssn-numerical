with Support.CmdLine;        use Support.CmdLine;
with Support.Strings;        use Support.Strings;
with Ada.Streams.Stream_IO;
with Ada.Directories;

package body BSSNBase.Data_IO is

   data_directory    : String := read_command_arg ("--DataDir","data/");
   results_directory : String := read_command_arg ("--OutputDir","results/");

   procedure read_data (file_name : String := "data.txt") is
      use Ada.Directories;
      use Ada.Streams.Stream_IO;
      txt        : Ada.Streams.Stream_IO.File_Type;
      txt_access : Ada.Streams.Stream_IO.Stream_Access;
   begin

      Open (txt, In_File, data_directory & "/" & file_name);
      txt_access := Stream (txt);

      Real'Read (txt_access, the_time);

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               MetricPointArray'Read  (txt_access, gBar (i,j,k));
               ExtcurvPointArray'Read (txt_access, ABar (i,j,k));
               GammaPointArray'Read   (txt_access, Gi (i,j,k));
               Real'Read (txt_access, N (i,j,k));
               Real'Read (txt_access, phi (i,j,k));
               Real'Read (txt_access, trK (i,j,k));

            end loop;
         end loop;
      end loop;

      Close (txt);

   end read_data;

   procedure read_grid (file_name : String := "grid.txt") is
      use Ada.Directories;
      use Ada.Streams.Stream_IO;
      txt        : Ada.Streams.Stream_IO.File_Type;
      txt_access : Ada.Streams.Stream_IO.Stream_Access;
   begin

      Open (txt, In_File, data_directory & "/" & file_name);
      txt_access := Stream (txt);

      Integer'Read (txt_access, num_x);    -- number of grid points along x-axis
      Integer'Read (txt_access, num_y);    -- number of grid points along y-axis
      Integer'Read (txt_access, num_z);    -- number of grid points along z-axis

      Real'Read (txt_access, dx);          -- grid spacing along x-axis
      Real'Read (txt_access, dy);          -- grid spacing along y-axis
      Real'Read (txt_access, dz);          -- grid spacing along z-axis

      Integer'Read (txt_access, grid_point_num);
      Integer'Read (txt_access, interior_num);
      Integer'Read (txt_access, boundary_num);

      Integer'Read (txt_access, north_bndry_num);
      Integer'Read (txt_access, south_bndry_num);
      Integer'Read (txt_access, east_bndry_num);
      Integer'Read (txt_access, west_bndry_num);
      Integer'Read (txt_access, front_bndry_num);
      Integer'Read (txt_access, back_bndry_num);

      for i in 1..grid_point_num loop
         GridPoint'Read (txt_access, grid_point_list (i));
      end loop;

      for i in 1..interior_num loop
         Integer'Read (txt_access, interior (i));
      end loop;

      for i in 1..boundary_num loop
         Integer'Read (txt_access, boundary (i));
      end loop;

      for i in 1..north_bndry_num loop
         Integer'Read (txt_access, north_bndry (i));
      end loop;

      for i in 1..south_bndry_num loop
         Integer'Read (txt_access, south_bndry (i));
      end loop;

      for i in 1..east_bndry_num loop
         Integer'Read (txt_access, east_bndry (i));
      end loop;

      for i in 1..west_bndry_num loop
         Integer'Read (txt_access, west_bndry (i));
      end loop;

      for i in 1..front_bndry_num loop
         Integer'Read (txt_access, front_bndry (i));
      end loop;

      for i in 1..back_bndry_num loop
         Integer'Read (txt_access, back_bndry (i));
      end loop;

      Close (txt);

   end read_grid;

   procedure write_data (file_name : String := "data.txt") is
      use Ada.Directories;
      use Ada.Streams.Stream_IO;
      txt        : Ada.Streams.Stream_IO.File_Type;
      txt_access : Ada.Streams.Stream_IO.Stream_Access;
   begin

      Create_Path (Containing_Directory(data_directory & "/" & file_name));

      Create (txt, Out_File, data_directory & "/" & file_name);
      txt_access := Stream (txt);

      Real'Write (txt_access, the_time);

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               MetricPointArray'Write  (txt_access, gBar (i,j,k));
               ExtcurvPointArray'Write (txt_access, ABar (i,j,k));
               GammaPointArray'Write   (txt_access, Gi (i,j,k));
               Real'Write (txt_access, N (i,j,k));
               Real'Write (txt_access, phi (i,j,k));
               Real'Write (txt_access, trK (i,j,k));

            end loop;
         end loop;
      end loop;

      Close (txt);

   end write_data;

   procedure write_grid (file_name : String := "grid.txt") is
      use Ada.Directories;
      use Ada.Streams.Stream_IO;
      txt        : Ada.Streams.Stream_IO.File_Type;
      txt_access : Ada.Streams.Stream_IO.Stream_Access;
   begin

      Create_Path (Containing_Directory(data_directory & "/" & file_name));

      Create (txt, Out_File, data_directory & "/" & file_name);
      txt_access := Stream (txt);

      Integer'Write (txt_access, num_x);    -- number of grid points along x-axis
      Integer'Write (txt_access, num_y);    -- number of grid points along y-axis
      Integer'Write (txt_access, num_z);    -- number of grid points along z-axis

      Real'Write (txt_access, dx);          -- grid spacing along x-axis
      Real'Write (txt_access, dy);          -- grid spacing along y-axis
      Real'Write (txt_access, dz);          -- grid spacing along z-axis

      Integer'write (txt_access, grid_point_num);
      Integer'Write (txt_access, interior_num);
      Integer'Write (txt_access, boundary_num);

      Integer'Write (txt_access, north_bndry_num);
      Integer'Write (txt_access, south_bndry_num);
      Integer'Write (txt_access, east_bndry_num);
      Integer'Write (txt_access, west_bndry_num);
      Integer'Write (txt_access, front_bndry_num);
      Integer'Write (txt_access, back_bndry_num);

      for i in 1..grid_point_num loop
         GridPoint'Write (txt_access, grid_point_list (i));
      end loop;

      for i in 1..interior_num loop
         Integer'Write (txt_access, interior (i));
      end loop;

      for i in 1..boundary_num loop
         Integer'Write (txt_access, boundary (i));
      end loop;

      for i in 1..north_bndry_num loop
         Integer'Write (txt_access, north_bndry (i));
      end loop;

      for i in 1..south_bndry_num loop
         Integer'Write (txt_access, south_bndry (i));
      end loop;

      for i in 1..east_bndry_num loop
         Integer'Write (txt_access, east_bndry (i));
      end loop;

      for i in 1..west_bndry_num loop
         Integer'Write (txt_access, west_bndry (i));
      end loop;

      for i in 1..front_bndry_num loop
         Integer'Write (txt_access, front_bndry (i));
      end loop;

      for i in 1..back_bndry_num loop
         Integer'Write (txt_access, back_bndry (i));
      end loop;

      Close (txt);

   end write_grid;

   procedure read_data_fmt (file_name : String := "data.txt") is
      txt : File_Type;
   begin

      Open (txt, In_File, data_directory & "/" & file_name);

      Get (txt, the_time);   Skip_Line (txt);

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               for a in MetricPointArray'Range loop
                  Get (txt, gBar (i,j,k)(a));
               end loop;
               Skip_line (txt);

               for a in ExtcurvPointArray'Range loop
                  Get (txt, ABar (i,j,k)(a));
               end loop;
               Skip_line (txt);

               for a in GammaPointArray'Range loop
                  Get (txt, Gi (i,j,k)(a));
               end loop;
               Skip_line (txt);

               Get (txt, N (i,j,k));
               Get (txt, phi (i,j,k));
               Get (txt, trK (i,j,k));
               Skip_Line (txt);

            end loop;
         end loop;
      end loop;

      Close (txt);

   end read_data_fmt;

   procedure read_grid_fmt (file_name : String := "grid.txt") is
      txt : File_Type;
   begin

      Open (txt, In_File, data_directory & "/" & file_name);

      Get (txt, num_x);   -- number of grid points along x-axis
      Get (txt, num_y);   -- number of grid points along y-axis
      Get (txt, num_z);   -- number of grid points along z-axis
      Skip_Line (txt);

      Get (txt, dx);      -- grid spacing along x-axis
      Get (txt, dy);      -- grid spacing along y-axis
      Get (txt, dz);      -- grid spacing along z-axis
      Skip_Line (txt);

      Get (txt, grid_point_num);
      Get (txt, interior_num);
      Get (txt, boundary_num);
      Skip_Line (txt);

      Get (txt, north_bndry_num);
      Get (txt, south_bndry_num);
      Get (txt, east_bndry_num);
      Get (txt, west_bndry_num);
      Get (txt, front_bndry_num);
      Get (txt, back_bndry_num);
      Skip_Line (txt);

      for i in 1..grid_point_num loop
         Get (txt, grid_point_list (i).i);
         Get (txt, grid_point_list (i).j);
         Get (txt, grid_point_list (i).k);
         Skip_Line (txt);
         Get (txt, grid_point_list (i).x);
         Get (txt, grid_point_list (i).y);
         Get (txt, grid_point_list (i).z);
         Skip_Line (txt);
      end loop;

      for i in 1..interior_num loop
         Get (txt, interior (i));
         Skip_Line (txt);
      end loop;

      for i in 1..boundary_num loop
         Get (txt, boundary (i));
         Skip_Line (txt);
      end loop;

      for i in 1..north_bndry_num loop
         Get (txt, north_bndry (i));
         Skip_Line (txt);
      end loop;

      for i in 1..south_bndry_num loop
         Get (txt, south_bndry (i));
         Skip_Line (txt);
      end loop;

      for i in 1..east_bndry_num loop
         Get (txt, east_bndry (i));
         Skip_Line (txt);
      end loop;

      for i in 1..west_bndry_num loop
         Get (txt, west_bndry (i));
         Skip_Line (txt);
      end loop;

      for i in 1..front_bndry_num loop
         Get (txt, front_bndry (i));
         Skip_Line (txt);
      end loop;

      for i in 1..back_bndry_num loop
         Get (txt, back_bndry (i));
         Skip_Line (txt);
      end loop;

      Close (txt);

   end read_grid_fmt;

   procedure write_data_fmt (file_name : String := "data.txt") is
      txt : File_Type;
      use Ada.Directories;
   begin

      Create_Path (Containing_Directory(data_directory & "/" & file_name));

      Create (txt, Out_File, data_directory & "/" & file_name);

      Put_Line (txt, str(the_time,25));

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               for a in MetricPointArray'Range loop
                  Put (txt, str (gBar (i,j,k)(a),25) & spc (1));
               end loop;
               New_line (txt);

               for a in ExtcurvPointArray'Range loop
                  Put (txt, str (ABar (i,j,k)(a),25) & spc (1));
               end loop;
               New_line (txt);

               for a in GammaPointArray'Range loop
                  Put (txt, str (Gi (i,j,k)(a),25) & spc (1));
               end loop;
               New_line (txt);

               Put_Line (txt, str (N (i,j,k),25) & spc(1) &
                              str (phi (i,j,k),25) & spc(1) &
                              str (trK (i,j,k),25));

            end loop;
         end loop;
      end loop;

      Close (txt);

   end write_data_fmt;

   procedure write_grid_fmt (file_name : String := "grid.txt") is
      txt : File_Type;
      use Ada.Directories;
   begin

      Create_Path (Containing_Directory(data_directory & "/" & file_name));

      Create (txt, Out_File, data_directory & "/" & file_name);

      Put (txt, str (num_x) & spc (1));     -- number of grid points along x-axis
      Put (txt, str (num_y) & spc (1));     -- number of grid points along y-axis
      Put (txt, str (num_z));               -- number of grid points along z-axis
      New_Line (txt);

      Put (txt, str (dx,25) & spc (1));     -- grid spacing along x-axis
      Put (txt, str (dy,25) & spc (1));     -- grid spacing along y-axis
      Put (txt, str (dz,25));               -- grid spacing along z-axis
      New_Line (txt);

      Put (txt, str (grid_point_num) & spc (1));
      Put (txt, str (interior_num)   & spc (1));
      Put (txt, str (boundary_num));
      New_Line (txt);

      Put (txt, str (north_bndry_num) & spc (1));
      Put (txt, str (south_bndry_num) & spc (1));
      Put (txt, str (east_bndry_num)  & spc (1));
      Put (txt, str (west_bndry_num)  & spc (1));
      Put (txt, str (front_bndry_num) & spc (1));
      Put (txt, str (back_bndry_num));
      New_Line (txt);

      for i in 1..grid_point_num loop
         Put (txt, str (grid_point_list (i).i) & spc (1));
         Put (txt, str (grid_point_list (i).j) & spc (1));
         Put (txt, str (grid_point_list (i).k) & spc (1));
         New_Line (txt);
         Put (txt, str (grid_point_list (i).x,25) & spc (1));
         Put (txt, str (grid_point_list (i).y,25) & spc (1));
         Put (txt, str (grid_point_list (i).z,25));
         New_Line (txt);
      end loop;

      for i in 1..interior_num loop
         Put (txt, str (interior (i)));
         New_Line (txt);
      end loop;

      for i in 1..boundary_num loop
         Put (txt, str (boundary (i)));
         New_Line (txt);
      end loop;

      for i in 1..north_bndry_num loop
         Put (txt, str (north_bndry (i)));
         New_Line (txt);
      end loop;

      for i in 1..south_bndry_num loop
         Put (txt, str (south_bndry (i)));
         New_Line (txt);
      end loop;

      for i in 1..east_bndry_num loop
         Put (txt, str (east_bndry (i)));
         New_Line (txt);
      end loop;

      for i in 1..west_bndry_num loop
         Put (txt, str (west_bndry (i)));
         New_Line (txt);
      end loop;

      for i in 1..front_bndry_num loop
         Put (txt, str (front_bndry (i)));
         New_Line (txt);
      end loop;

      for i in 1..back_bndry_num loop
         Put (txt, str (back_bndry (i)));
         New_Line (txt);
      end loop;

      Close (txt);

   end write_grid_fmt;

end BSSNBase.Data_IO;
