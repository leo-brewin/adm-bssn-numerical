package body BSSNBase is

   -- overloaded operators for MetricPointArray

   function "-" (Right : MetricPointArray) return MetricPointArray
   is
      tmp : MetricPointArray := Right;
   begin
      for i in Right'range(1) loop
         tmp (i) := - Right (i);
      end loop;
      return tmp;
   end "-";

   function "-" (Left : MetricPointArray; Right : MetricPointArray) return MetricPointArray
   is
      tmp : MetricPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) - Right (i);
      end loop;
      return tmp;
   end "-";

   function "+" (Left : MetricPointArray; Right : MetricPointArray) return MetricPointArray
   is
      tmp : MetricPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) + Right (i);
      end loop;
      return tmp;
   end "+";

   function "*" (Left : Real; Right : MetricPointArray) return MetricPointArray
   is
      tmp : MetricPointArray := Right;
   begin
      for i in Right'Range(1) loop
         tmp (i) := Left * Right (i);
      end loop;
      return tmp;
   end "*";

   function "/" (Left : MetricPointArray; Right : Real) return MetricPointArray
   is
      tmp : MetricPointArray := left;
   begin
      for i in Left'Range loop
         tmp (i) := Left (i) / Right;
      end loop;
      return tmp;
   end "/";

   -- overloaded operators for ExtcurvPointArray

   function "-" (Right : ExtcurvPointArray) return ExtcurvPointArray
   is
      tmp : ExtcurvPointArray := Right;
   begin
      for i in Right'range(1) loop
         tmp (i) := - Right (i);
      end loop;
      return tmp;
   end "-";

   function "-" (Left : ExtcurvPointArray; Right : ExtcurvPointArray) return ExtcurvPointArray
   is
      tmp : ExtcurvPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) - Right (i);
      end loop;
      return tmp;
   end "-";

   function "+" (Left : ExtcurvPointArray; Right : ExtcurvPointArray) return ExtcurvPointArray
   is
      tmp : ExtcurvPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) + Right (i);
      end loop;
      return tmp;
   end "+";

   function "*" (Left : Real; Right : ExtcurvPointArray) return ExtcurvPointArray
   is
      tmp : ExtcurvPointArray := Right;
   begin
      for i in Right'Range(1) loop
         tmp (i) := Left * Right (i);
      end loop;
      return tmp;
   end "*";

   function "/" (Left : ExtcurvPointArray; Right : Real) return ExtcurvPointArray
   is
      tmp : ExtcurvPointArray := left;
   begin
      for i in Left'Range loop
         tmp (i) := Left (i) / Right;
      end loop;
      return tmp;
   end "/";

   -- overloaded operators for GammaPointArray

   function "-" (Right : GammaPointArray) return GammaPointArray
   is
      tmp : GammaPointArray := Right;
   begin
      for i in Right'range(1) loop
         tmp (i) := - Right (i);
      end loop;
      return tmp;
   end "-";

   function "-" (Left : GammaPointArray; Right : GammaPointArray) return GammaPointArray
   is
      tmp : GammaPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) - Right (i);
      end loop;
      return tmp;
   end "-";

   function "+" (Left : GammaPointArray; Right : GammaPointArray) return GammaPointArray
   is
      tmp : GammaPointArray := Right;
   begin
      for i in Left'range(1) loop
         tmp (i) := Left (i) + Right (i);
      end loop;
      return tmp;
   end "+";

   function "*" (Left : Real; Right : GammaPointArray) return GammaPointArray
   is
      tmp : GammaPointArray := Right;
   begin
      for i in Right'Range(1) loop
         tmp (i) := Left * Right (i);
      end loop;
      return tmp;
   end "*";

   function "/" (Left : GammaPointArray; Right : Real) return GammaPointArray
   is
      tmp : GammaPointArray := left;
   begin
      for i in Left'Range loop
         tmp (i) := Left (i) / Right;
      end loop;
      return tmp;
   end "/";

   -- elementary operations on symmetric 3x3 matrices gab and Kab

   Function symm_inverse (gab :  MetricPointArray)
                          Return MetricPointArray
   is
      inv : MetricPointArray;
      det : Real;
   begin

      inv (xx) :=   gab (yy) * gab (zz) - gab (yz) * gab (yz);
      inv (xy) := - gab (xy) * gab (zz) + gab (xz) * gab (yz);
      inv (xz) :=   gab (xy) * gab (yz) - gab (xz) * gab (yy);
      inv (yy) :=   gab (xx) * gab (zz) - gab (xz) * gab (xz);
      inv (yz) := - gab (xx) * gab (yz) + gab (xy) * gab (xz);
      inv (zz) :=   gab (xx) * gab (yy) - gab (xy) * gab (xy);

      det := inv(xx)*gab(xx) + inv(xy)*gab(xy) + inv(xz)*gab(xz);

      inv (xx) := inv (xx) / det;
      inv (xy) := inv (xy) / det;
      inv (xz) := inv (xz) / det;
      inv (yy) := inv (yy) / det;
      inv (yz) := inv (yz) / det;
      inv (zz) := inv (zz) / det;

      Return inv;

   end symm_inverse;

   Function symm_det (gab :  MetricPointArray)
                      Return Real
   is
      tmp_xx, tmp_xy, tmp_xz : Real;
   begin

      tmp_xx :=   gab (yy) * gab (zz) - gab (yz) * gab (yz);
      tmp_xy := - gab (xy) * gab (zz) + gab (xz) * gab (yz);
      tmp_xz :=   gab (xy) * gab (yz) - gab (xz) * gab (yy);

      Return tmp_xx*gab(xx) + tmp_xy*gab(xy) + tmp_xz*gab(xz);

   end symm_det;

   Function symm_trace (mat : ExtcurvPointArray;
                        iab : MetricPointArray)
                        Return Real
   is
      trace : Real;
   begin

      trace :=        iab(xx)*mat(xx) + iab(yy)*mat(yy) + iab(zz)*mat(zz)
               + 2.0*(iab(xy)*mat(xy) + iab(xz)*mat(xz) + iab(yz)*mat(yz));

      Return trace;

   end symm_trace;

   Function symm_raise_indices (Mdn : MetricPointArray;
                                iab : MetricPointArray)
                                Return MetricPointArray
   is
      t01, t02, t03, t04, t05, t06, t07, t08, t09 : Real;
      Mup : MetricPointArray;
   begin

      t01 := Mdn(xx)*iab(xx) + Mdn(xy)*iab(xy) + Mdn(xz)*iab(xz);
      t02 := Mdn(yy)*iab(yy) + Mdn(xy)*iab(xy) + Mdn(yz)*iab(yz);
      t03 := Mdn(zz)*iab(zz) + Mdn(xz)*iab(xz) + Mdn(yz)*iab(yz);
      t04 := Mdn(xy)*iab(xx) + Mdn(yy)*iab(xy) + Mdn(yz)*iab(xz);
      t05 := Mdn(xz)*iab(xx) + Mdn(yz)*iab(xy) + Mdn(zz)*iab(xz);
      t06 := Mdn(xx)*iab(xy) + Mdn(xy)*iab(yy) + Mdn(xz)*iab(yz);
      t07 := Mdn(xz)*iab(xy) + Mdn(yz)*iab(yy) + Mdn(zz)*iab(yz);
      t08 := Mdn(xx)*iab(xz) + Mdn(xy)*iab(yz) + Mdn(xz)*iab(zz);
      t09 := Mdn(xy)*iab(xz) + Mdn(yy)*iab(yz) + Mdn(yz)*iab(zz);

      Mup (xx) := iab(xx)*t01 + iab(xy)*t04 + iab(xz)*t05;
      Mup (xy) := iab(xy)*t01 + iab(yy)*t04 + iab(yz)*t05;
      Mup (xz) := iab(xz)*t01 + iab(yz)*t04 + iab(zz)*t05;
      Mup (yy) := iab(xy)*t06 + iab(yy)*t02 + iab(yz)*t07;
      Mup (yz) := iab(xz)*t06 + iab(yz)*t02 + iab(zz)*t07;
      Mup (zz) := iab(xz)*t08 + iab(yz)*t09 + iab(zz)*t03;

      return Mup;

   end symm_raise_indices;

   Function symm_raise_indices (Mdn : ExtcurvPointArray;
                                iab : MetricPointArray)
                                Return ExtcurvPointArray
   is
      t01, t02, t03, t04, t05, t06, t07, t08, t09 : Real;
      Mup : ExtcurvPointArray;
   begin

      t01 := Mdn(xx)*iab(xx) + Mdn(xy)*iab(xy) + Mdn(xz)*iab(xz);
      t02 := Mdn(yy)*iab(yy) + Mdn(xy)*iab(xy) + Mdn(yz)*iab(yz);
      t03 := Mdn(zz)*iab(zz) + Mdn(xz)*iab(xz) + Mdn(yz)*iab(yz);
      t04 := Mdn(xy)*iab(xx) + Mdn(yy)*iab(xy) + Mdn(yz)*iab(xz);
      t05 := Mdn(xz)*iab(xx) + Mdn(yz)*iab(xy) + Mdn(zz)*iab(xz);
      t06 := Mdn(xx)*iab(xy) + Mdn(xy)*iab(yy) + Mdn(xz)*iab(yz);
      t07 := Mdn(xz)*iab(xy) + Mdn(yz)*iab(yy) + Mdn(zz)*iab(yz);
      t08 := Mdn(xx)*iab(xz) + Mdn(xy)*iab(yz) + Mdn(xz)*iab(zz);
      t09 := Mdn(xy)*iab(xz) + Mdn(yy)*iab(yz) + Mdn(yz)*iab(zz);

      Mup (xx) := iab(xx)*t01 + iab(xy)*t04 + iab(xz)*t05;
      Mup (xy) := iab(xy)*t01 + iab(yy)*t04 + iab(yz)*t05;
      Mup (xz) := iab(xz)*t01 + iab(yz)*t04 + iab(zz)*t05;
      Mup (yy) := iab(xy)*t06 + iab(yy)*t02 + iab(yz)*t07;
      Mup (yz) := iab(xz)*t06 + iab(yz)*t02 + iab(zz)*t07;
      Mup (zz) := iab(xz)*t08 + iab(yz)*t09 + iab(zz)*t03;

      return Mup;

   end symm_raise_indices;

end BSSNBase;
