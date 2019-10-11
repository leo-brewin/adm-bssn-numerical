package BSSNBase.Constraints is

   function get_detg (i, j, k : Integer) return Real;
   function get_detg (point : GridPoint) return Real;

   function get_trABar (i, j, k : Integer) return Real;
   function get_trABar (point : GridPoint) return Real;

   procedure set_constraints (point : GridPoint);  -- set the constraints for any point *not* on the boundary
   procedure set_constraints;                      -- set the constraints across the whole grid *including* the boundaries

end BSSNBase.Constraints;
