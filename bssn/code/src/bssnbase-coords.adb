package body BSSNBase.Coords is

   function x_coord (i : Integer) return Real is
   begin
      return Real(i-1)*dx;
   end x_coord;

   function y_coord (j : Integer) return Real is
   begin
      return Real(j-1)*dy;
   end y_coord;

   function z_coord (k : Integer) return Real is
   begin
      return Real(k-1)*dz;
   end z_coord;

end BSSNBase.Coords;
