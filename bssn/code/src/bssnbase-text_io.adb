with Support.Clock;           use Support.Clock;
with Support.CmdLine;         use Support.CmdLine;
with Support.Strings;         use Support.Strings;

with BSSNBase.ADM_BSSN;       use BSSNBase.ADM_BSSN;

with BSSNBase.Coords;         use BSSNBase.Coords;
with BSSNBase.Constraints;    use BSSNBase.Constraints;

-- for creation of directories if needed
with Ada.Directories;

package body BSSNBase.Text_IO is

   data_directory    : String := read_command_arg ("--DataDir","data/");
   results_directory : String := read_command_arg ("--OutputDir","results/");

   -- returns 'xx', 'xy' etc. these are the values of type symmetric
   -- used when printing indices of symmetric matrices
   function str (source : in symmetric) return string is
   begin
      return lower_case (source'Image);
   end str;

   procedure write_results (sample_index_list : GridIndexList;
                            sample_index_num  : Integer;
                            file_name         : String)
   is

      num_data_max : constant := 15;

      txt          : File_Type;

      num_dimen    : constant := 3;

      num_rows     : Integer;
      num_cols     : Integer;
      num_vars     : Integer;
      the_date     : String := get_date;

      ijk          : Array (1 .. 3) of Integer;
      ijk_max      : Array (1 .. 3) of Integer;
      ijk_min      : Array (1 .. 3) of Integer;

      xyz          : Array (1 .. 3) of Real;
      xyz_max      : Array (1 .. 3) of Real;
      xyz_min      : Array (1 .. 3) of Real;

      data         : Array (1 .. num_data_max) of Real;
      data_max     : Array (1 .. num_data_max) of Real;
      data_min     : Array (1 .. num_data_max) of Real;

      procedure check_NaN (a : Integer) is
      begin

         if data (a) /= data (a) then
            raise Data_Error with "NaN detected in data ("&str(a,0)&") "&
                                  "at (x,y,z) = ("&
                                   str(xyz(1))&","&
                                   str(xyz(2))&","&
                                   str(xyz(3))&")";
         end if;

      end check_NaN;

      procedure get_data (a : Integer)
      is

         point   : GridPoint;
         i, j, k : Integer;
         x, y, z : Real;

         gab : MetricPointArray;
         Kab : ExtcurvPointArray;

      begin

         point := grid_point_list (sample_index_list (a));

         i := point.i;
         j := point.j;
         k := point.k;

         x := point.x;
         y := point.y;
         z := point.z;

         -- save selected data

         ijk := (i, j, k);
         xyz := (x, y, z);

         -- ADM data

         gab := adm_gab (gBar(i,j,k), phi(i,j,k));
         Kab := adm_Kab (ABar(i,j,k), gBar(i,j,k), phi(i,j,k), trK(i,j,k));

         data ( 1) := gab (xx);
         data ( 2) := gab (yy);
         data ( 3) := gab (zz);
         data ( 4) := Kab (xx);
         data ( 5) := Kab (yy);
         data ( 6) := Kab (zz);
         data ( 7) := Ham (i,j,k);
         data ( 8) := Mom (i,j,k)(1);
         data ( 9) := Mom (i,j,k)(2);
         data (10) := Mom (i,j,k)(3);
         data (11) := get_detg (i,j,k);
         data (12) := get_trABar (i,j,k);

         num_vars := 12;  -- number of phyical data in each row

         -- BSSN data

         -- data ( 1) := gBar (i,j,k)(xx);
         -- data ( 2) := gBar (i,j,k)(yy);
         -- data ( 3) := gBar (i,j,k)(zz);
         -- data ( 4) := ABar (i,j,k)(xx);
         -- data ( 5) := ABar (i,j,k)(yy);
         -- data ( 6) := ABar (i,j,k)(zz);
         -- data ( 7) := Ham (i,j,k);
         -- data ( 8) := Mom (i,j,k)(1);
         -- data ( 9) := Mom (i,j,k)(2);
         -- data (10) := Mom (i,j,k)(3);
         -- data (11) := get_detg (i,j,k);
         -- data (12) := get_trABar (i,j,k);
         --
         -- num_vars := 12;  -- number of phyical data in each row

      end get_data;

   begin

      if sample_index_num = 0 then
         return;
      end if;

      -- First pass : get min/max for the data -----------------------------------

      ijk_max := (others => -666666);
      ijk_min := (others => +666666);

      xyz_max := (others => -666.6e66);
      xyz_min := (others => +666.6e66);

      data_max := (others => -666.6e66);
      data_min := (others => +666.6e66);

      for a in 1 .. sample_index_num loop

         get_data (a);

         for b in 1 .. num_vars loop
            check_NaN (b);
         end loop;

         for b in 1 .. 3 loop
            ijk_max (b) := max ( ijk_max (b), ijk (b) );
            ijk_min (b) := min ( ijk_min (b), ijk (b) );
         end loop;

         for b in 1 .. 3 loop
            xyz_max (b) := max ( xyz_max (b), xyz (b) );
            xyz_min (b) := min ( xyz_min (b), xyz (b) );
         end loop;

         for b in 1 .. num_vars loop
            data_max (b) := max ( data_max (b), data (b) );
            data_min (b) := min ( data_min (b), data (b) );
         end loop;

      end loop;

      -- Second pass : save the data ---------------------------------------------

      Create (txt, Out_File, cut(file_name));

      Put_Line (txt, "# 7 more lines before the data");

      -- dimensions of the grid, number of vars, time & date

      num_cols := 3 + 3 + num_vars;       -- number of columns in body of data
      num_rows := sample_index_num;       -- number of rows in body of data

      Put_Line (txt, "# " & str (num_rows, 0)  & " rows of data");
      Put_Line (txt, "# " & str (num_cols, 0)  & " columns of data");
      Put_Line (txt, "# " & str (the_time, 15) & " cauchy time");
      Put_Line (txt, "# " &     (the_date)     & " today's date");

      -- max and min values for each variable

      Put (txt,"# ");
      for i in 1 .. 3 loop
         Put (txt, str(ijk_max(i),3) & spc (1));
      end loop;
      for i in 1 .. 3 loop
         Put (txt, str(xyz_max(i),10) & spc (1));
      end loop;
      for i in 1 .. num_vars loop
         Put (txt, str(data_max(i),15) & spc (1));
      end loop;
      Put_Line (txt," : max");

      Put (txt,"# ");
      for i in 1 .. 3 loop
         Put (txt, str(ijk_min(i),3) & spc (1));
      end loop;
      for i in 1 .. 3 loop
         Put (txt, str(xyz_min(i),10) & spc (1));
      end loop;
      for i in 1 .. num_vars loop
         Put (txt, str(data_min(i),15) & spc (1));
      end loop;
      Put_Line (txt," : min");

      -- the data names

      Put (txt,"# ");
      Put (txt, centre ("i",4,1));
      Put (txt, centre ("j",4,1));
      Put (txt, centre ("k",4,1));
      Put (txt, centre ("x",11));
      Put (txt, centre ("y",11));
      Put (txt, centre ("z",11));
      Put (txt, centre ("gxx",16));
      Put (txt, centre ("gyy",16));
      Put (txt, centre ("gzz",16));
      Put (txt, centre ("Kxx",16));
      Put (txt, centre ("Kyy",16));
      Put (txt, centre ("Kzz",16));
      Put (txt, centre ("Ham",16));
      Put (txt, centre ("Mom(x)",16));
      Put (txt, centre ("Mom(y)",16));
      Put (txt, centre ("Mom(z)",16));
      Put (txt, centre ("detg",16));
      Put (txt, centre ("trABar",16));
      New_Line (txt);

      -- Put (txt,"# ");
      -- Put (txt, centre ("i",4,1));
      -- Put (txt, centre ("j",4,1));
      -- Put (txt, centre ("k",4,1));
      -- Put (txt, centre ("x",11));
      -- Put (txt, centre ("y",11));
      -- Put (txt, centre ("z",11));
      -- Put (txt, centre ("gBarxx",16));
      -- Put (txt, centre ("gBaryy",16));
      -- Put (txt, centre ("gBarzz",16));
      -- Put (txt, centre ("ABarxx",16));
      -- Put (txt, centre ("ABaryy",16));
      -- Put (txt, centre ("ABarzz",16));
      -- Put (txt, centre ("Ham",16));
      -- Put (txt, centre ("Mom(x)",16));
      -- Put (txt, centre ("Mom(y)",16));
      -- Put (txt, centre ("Mom(z)",16));
      -- Put (txt, centre ("detg",16));
      -- Put (txt, centre ("trABar",16));
      -- New_Line (txt);

      -- the data on the grid

      for a in 1 .. num_rows loop

         get_data (a);

         Put (txt, spc (2));

         for b in 1 .. 3 loop
            Put (txt, str (ijk (b), 3) & spc (1));
         end loop;

         for b in 1 .. 3 loop
            Put (txt, str (xyz (b), 10) & spc (1));
         end loop;

         for b in 1 .. num_vars loop
            Put (txt, str (data (b), 15) & spc (1));
         end loop;

         New_Line (txt);

      end loop;

      Close (txt);

   end write_results;

   procedure write_results is
      num_loop_str : String := str (num_loop, "%05d");
   begin

      set_constraints;

      Ada.Directories.create_path (results_directory & "/xy/");
      Ada.Directories.create_path (results_directory & "/xz/");
      Ada.Directories.create_path (results_directory & "/yz/");

      write_results (xy_index_list, xy_index_num, results_directory & "/xy/" & num_loop_str & ".txt");
      write_results (xz_index_list, xz_index_num, results_directory & "/xz/" & num_loop_str & ".txt");
      write_results (yz_index_list, yz_index_num, results_directory & "/yz/" & num_loop_str & ".txt");

   end write_results;

   procedure write_history (point : GridPoint;
                            file_name : String)
   is
      txt : File_Type;

      i, j, k : Integer;
      x, y, z : Real;

      gab : MetricPointArray;
      Kab : ExtcurvPointArray;
   begin

      i := sample_point.i;
      j := sample_point.j;
      k := sample_point.k;

      x := sample_point.x;
      y := sample_point.y;
      z := sample_point.z;

      begin

         Open (txt, Append_File, file_name);

         exception when Name_Error =>

            Create (txt, Out_File, file_name);

            Put_Line (txt, "# 4 more lines before the data");

            Put_Line (txt, "# 13 columns of data");

            Put_Line (txt,"# (" & str (i,0) & ", "  &
                                  str (j,0) & ", "  &
                                  str (k,0) & ") = grid indices of target");

            Put_Line (txt,"# (" & str (x,10) & ", " &
                                  str (y,10) & ", " &
                                  str (z,10) & ") = grid coords of target");
            Put_Line (txt, "# "                  &
                           centre ("Time",10)    &
                           centre ("gxx",11)     &
                           centre ("gyy",11)     &
                           centre ("gzz",11)     &
                           centre ("Kxx",11)     &
                           centre ("Kyy",11)     &
                           centre ("Kzz",11)     &
                           centre ("Ham",11)     &
                           centre ("Mom(x)",11)  &
                           centre ("Mom(y)",11)  &
                           centre ("Mom(z)",11)  &
                           centre ("detg",11)    &
                           centre ("trABar",11));

      end;

      -- ADM data

      gab := adm_gab (gBar(i,j,k), phi(i,j,k));
      Kab := adm_Kab (ABar(i,j,k), gBar(i,j,k), phi(i,j,k), trK(i,j,k));

      Put (txt, spc (1) & str (the_time));
      Put (txt, spc (1) & str (gab (xx)));
      Put (txt, spc (1) & str (gab (yy)));
      Put (txt, spc (1) & str (gab (zz)));
      Put (txt, spc (1) & str (Kab (xx)));
      Put (txt, spc (1) & str (Kab (yy)));
      Put (txt, spc (1) & str (Kab (zz)));
      Put (txt, spc (1) & str (Ham (i,j,k)));
      Put (txt, spc (1) & str (Mom (i,j,k)(1)));
      Put (txt, spc (1) & str (Mom (i,j,k)(2)));
      Put (txt, spc (1) & str (Mom (i,j,k)(3)));
      Put (txt, spc (1) & str (get_detg (i,j,k)));
      Put (txt, spc (1) & str (get_trABar (i,j,k)));
      New_Line (txt);

      Close (txt);

   end write_history;

   procedure write_history is
   begin

      write_history (sample_point,results_directory & "/history.txt");

   end write_history;

   procedure write_summary
   is
      i, j, k : Integer;

      gab : MetricPointArray;
      Kab : ExtcurvPointArray;
   begin

      i := sample_point.i;
      j := sample_point.j;
      k := sample_point.k;

      set_constraints;

      gab := adm_gab (gBar(i,j,k), phi(i,j,k));
      Kab := adm_Kab (ABar(i,j,k), gBar(i,j,k), phi(i,j,k), trK(i,j,k));

      Put (spc (1) & str (num_loop,4));
      Put (spc (1) & str (the_time,10));
      Put (spc (1) & str (time_step,10));
      Put (spc (1) & str (gab (xx),10));
      Put (spc (1) & str (gab (zz),10));
      Put (spc (1) & str (Kab (xx),10));
      Put (spc (1) & str (Kab (zz),10));
      Put (spc (1) & str (Ham (i,j,k),10));
      New_Line;

   end write_summary;

   dashes : String := dash (83);

   procedure write_summary_header is
   begin

      Put_Line (dashes);
      Put (" ");
      Put (centre("loop",5));
      Put (centre("time",11));
      Put (centre("step",11));
      Put (centre("gxx",11));
      Put (centre("gzz",11));
      Put (centre("Kxx",11));
      Put (centre("Kzz",11));
      Put (centre("Ham.",11));
      New_Line;
      Put_Line (dashes);

   end write_summary_header;

   procedure write_summary_trailer is
   begin

      Put_Line (dashes);

   end write_summary_trailer;

   procedure create_text_io_lists is

      a : Integer := 0;

      num_xy  : Integer := 0;
      num_xz  : Integer := 0;
      num_yz  : Integer := 0;

      x, y, z : Real;

   begin

      a := 0;

      num_xy := 0;
      num_xz := 0;
      num_yz := 0;

      for i in 1 .. num_x loop
         for j in 1 .. num_y loop
            for k in 1 .. num_y loop

               x := x_coord (i);
               y := y_coord (j);
               z := z_coord (k);

               a := a + 1;

               -- xy plane
               if abs (z) < dz/2.0 then
                  num_xy := num_xy + 1;
                  xy_index_list (num_xy) := a;
               end if;

               -- xz plane
               if abs (y) < dy/2.0 then
                  num_xz := num_xz + 1;
                  xz_index_list (num_xz) := a;
               end if;

               -- yz plane
               if abs (x) < dx/2.0 then
                  num_yz := num_yz + 1;
                  yz_index_list (num_yz) := a;
               end if;

               -- the sample point = the origin, used in write_history
               if abs (x) < dx/2.0 and
                  abs (y) < dy/2.0 and
                  abs (z) < dz/2.0 then

                  sample_point := (i,j,k,0.0,0.0,0.0);

               end if;

            end loop;
         end loop;
      end loop;

      xy_index_num := num_xy;
      xz_index_num := num_xz;
      yz_index_num := num_yz;

   end create_text_io_lists;

end BSSNBase.Text_IO;
