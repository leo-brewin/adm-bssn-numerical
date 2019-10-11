with Metric.Kasner;                             use Metric.Kasner;

with BSSNBase.Coords;                           use BSSNBase.Coords;

package body BSSNBase.Initial is

   procedure create_data is
      t, x, y, z : Real;
   begin

      t := beg_time;

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               x := x_coord (i);
               y := y_coord (j);
               z := z_coord (k);

                  N (i,j,k) := set_3d_lapse (t,x,y,z);
                 Gi (i,j,k) := set_3d_Gi    (t,x,y,z);
                phi (i,j,k) := set_3d_phi   (t,x,y,z);
                trk (i,j,k) := set_3d_trK   (t,x,y,z);
               gBar (i,j,k) := set_3d_gBar  (t,x,y,z);
               ABar (i,j,k) := set_3d_ABar  (t,x,y,z);

            end loop;
         end loop;
      end loop;

   end create_data;

   procedure create_grid is
      a, b, c : Integer := 0;
      p, q, r, s, u, v : Integer := 0;
      x, y, z : Real;
   begin

      for i in 1..num_x loop
         for j in 1..num_y loop
            for k in 1..num_z loop

               x := x_coord (i);
               y := y_coord (j);
               z := z_coord (k);

               a := a + 1;

               grid_point_list (a) := (i,j,k,x,y,z);

               if (i>1) and (i<num_x) and
                  (j>1) and (j<num_y) and
                  (k>1) and (k<num_z)
               then
                  b := b+1;
                  interior (b) := a;
               else
                  c := c+1;
                  boundary (c) := a;
                  if k = num_z then
                     p := p + 1;
                     north_bndry (p) := a;
                  else
                     if k = 1 then
                        q := q + 1;
                        south_bndry (q) := a;
                     else
                        if j = num_y then
                           r := r + 1;
                           east_bndry (r) := a;
                        else
                           if j = 1 then
                              s := s + 1;
                              west_bndry (s) := a;
                           else
                              if i = num_x then
                                 u := u + 1;
                                 front_bndry (u) := a;
                              else
                                 if i = 1 then
                                    v := v + 1;
                                    back_bndry (v) := a;
                                 end if;
                              end if;
                           end if;
                        end if;
                     end if;
                  end if;
               end if;

            end loop;
         end loop;
      end loop;

      interior_num := b;
      boundary_num := c;

      north_bndry_num := p;
      south_bndry_num := q;
      east_bndry_num  := r;
      west_bndry_num  := s;
      front_bndry_num := u;
      back_bndry_num  := v;

      if boundary_num /= (north_bndry_num + south_bndry_num + east_bndry_num + west_bndry_num + front_bndry_num + back_bndry_num) then
         put_line ("> Error in create_grid: boundary not equal sum of parts");
         halt (1);
      end if;

      if grid_point_num /= interior_num + boundary_num then
         put_line ("> Error in create_grid: boundary + interior not equal to whole");
         halt (1);
      end if;

      if a /= grid_point_num then
         put_line ("> Error in create_grid: incorrect number of grid points");
         halt (1);
      end if;

   end create_grid;

end BSSNBase.Initial;
