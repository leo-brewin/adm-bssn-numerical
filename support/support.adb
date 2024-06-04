package body Support is

   function "+" (Left : Integer; Right : Real) return Real is
   begin
      return Real(Left) + Right;
   end "+";

   function "+" (Left : Real; Right : Integer) return Real is
   begin
      return Left + Real(Right);
   end "+";

   function "-" (Left : Integer; Right : Real) return Real is
   begin
      return Real(Left) - Right;
   end "-";

   function "-" (Left : Real; Right : Integer) return Real is
   begin
      return Left - Real(Right);
   end "-";

   function "*" (Left : Integer; Right : Real) return Real is
   begin
      return Real(Left) * Right;
   end "*";

   function "*" (Left : Real; Right : Integer) return Real is
   begin
      return Left * Real(Right);
   end "*";

   function "/" (Left : Integer; Right : Real) return Real is
   begin
      return Real(Left) / Right;
   end "/";

   function "/" (Left : Real; Right : Integer) return Real is
   begin
      return Left / Real(Right);
   end "/";

   function "<" (Left : Real; Right : Integer) return Boolean is
   begin
      return Left < Real(Right);
   end "<";

   function "<" (Left : Integer; Right : Real) return Boolean is
   begin
      return Real(Left) < Right;
   end "<";

   function ">" (Left : Real; Right : Integer) return Boolean is
   begin
      return Left > Real(Right);
   end ">";

   function ">" (Left : Integer; Right : Real) return Boolean is
   begin
      return Real(Left) > Right;
   end ">";

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

   -- round(+1.23) --> +1 and round(-1.23) --> -1
   -- round(+1.78) --> +2 and round(-1.78) --> -2
   function round(item : real) return integer is
      result : integer;
   begin
      result := Integer(real'floor(item+0.5e0));
      return result;
   end;

   -- trunc(+6.66) --> +6 and trunc(-6.66) --> -6
   function trunc(item : real) return integer is
      result : integer;
   begin
      result := Integer(real'truncation(item));
      return result;
   end;

   -- floor(+6.66) --> +6 but floor(-6.66) --> -7
   function floor(item : real) return integer is
      result : integer;
   begin
      result := Integer(real'floor(item));
      return result;
   end;

end Support;
