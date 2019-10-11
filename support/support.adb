package body Support is

   function max (a : in Real; b : in Real) return Real is
   begin
      if a > b
         then return a;
         else return b;
      end if;
   end;

   function min (a : in Real; b : in Real) return Real is
   begin
      if a < b
         then return a;
         else return b;
      end if;
   end;

   function max (a : in Integer; b : in Integer) return Integer is
   begin
      if a > b
         then return a;
         else return b;
      end if;
   end;

   function min (a : in Integer; b : in Integer) return Integer is
   begin
      if a < b
         then return a;
         else return b;
      end if;
   end;

end Support;
