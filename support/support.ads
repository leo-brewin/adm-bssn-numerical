with GNAT.OS_Lib;

package Support is

   type Real is digits 15;  -- on macOS arm64 max. of 15 decimal digits
   -- type Real is digits 18;  -- on Intel x86_64 can have 18 decimal digits

   function "+" (Left : Integer; Right : Real) return Real;
   function "+" (Left : Real; Right : Integer) return Real;

   function "-" (Left : Integer; Right : Real) return Real;
   function "-" (Left : Real; Right : Integer) return Real;

   function "*" (Left : Integer; Right : Real) return Real;
   function "*" (Left : Real; Right : Integer) return Real;

   function "/" (Left : Integer; Right : Real) return Real;
   function "/" (Left : Real; Right : Integer) return Real;

   function "<" (Left : Real; Right : Integer) return Boolean;
   function "<" (Left : Integer; Right : Real) return Boolean;

   function ">" (Left : Real; Right : Integer) return Boolean;
   function ">" (Left : Integer; Right : Real) return Boolean;

   function max (a : in Real; b : in Real) return Real;
   function min (a : in Real; b : in Real) return Real;

   function max (a : in Integer; b : in Integer) return Integer;
   function min (a : in Integer; b : in Integer) return Integer;

   function round (item : Real) return Integer;
   function trunc (item : Real) return Integer;
   function floor (item : Real) return Integer;

   procedure halt (return_code : Integer := 0) renames GNAT.OS_Lib.OS_Exit;

end Support;
