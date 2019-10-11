package ADMBase.Constraints is

   procedure set_constraints (point : GridPoint);  -- set the constraints for any point *not* on the boundary
   procedure set_constraints;                      -- set the constraints across the whole grid *including* the boundaries

end ADMBase.Constraints;
