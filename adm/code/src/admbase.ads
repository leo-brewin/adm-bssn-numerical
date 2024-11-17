-- for the Real type
with Support;                                   use Support;

-- for basic text io
with Ada.Text_IO;                               use Ada.Text_IO;

with Ada.Numerics.Generic_Elementary_Functions;

package ADMBase is

   -- type Real is digits 18; -- defined in support.ads

   package Real_IO    is new Ada.Text_IO.Float_IO (Real);                      use Real_IO;
   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);                 use Integer_IO;
   package Maths      is new Ada.Numerics.Generic_Elementary_Functions (Real); use Maths;

   max_num_x : Constant := 128;
   max_num_y : Constant := 128;
   max_num_z : Constant := 128;

   max_num_points : Constant := max_num_x * max_num_y * max_num_z;

   type params_array is Array (1..18) of Integer;   -- data beg/end pairs for each task

   type slave_params_record is Record
           slave_id : Integer;        -- unique task identifier
           params   : params_array;   -- data array limits
        end record;

   type slave_params_array is Array (Integer range <>) of slave_params_record;
   -- type slave_tasks_array  is Array (1..num_slaves) of SlaveTask;  -- SlaveTask is defined later in admbase-evolve codes
                                                                      -- num_slaves read from the command line, unknown at this point

   ----------------------------------------------------------------------------

   type symmetric         is (xx,xy,xz,yy,yz,zz);  -- for symmetric 3x3 arrays

   type MetricPointArray  is Array (symmetric) of Real;
   type MetricGridArray   is Array (Integer range <>, Integer range <>, Integer range <>) of MetricPointArray;

   type ExtcurvPointArray is Array (symmetric) of Real;
   type ExtcurvGridArray  is Array (Integer range <>, Integer range <>, Integer range <>) of ExtcurvPointArray;

   type LapseGridArray    is Array (Integer range <>, Integer range <>, Integer range <>) of Real;

   type HamConstraintGridArray is Array (Integer range <>, Integer range <>, Integer range <>) of Real;

   type MomConstraintPointArray is Array (1..3) of Real;
   type MomConstraintGridArray  is Array (Integer range <>, Integer range <>, Integer range <>) of MomConstraintPointArray;

   type MetricGridArray_ptr  is access MetricGridArray;
   type ExtcurvGridArray_ptr is access ExtcurvGridArray;
   type LapseGridArray_ptr   is access LapseGridArray;

   type HamConstraintGridArray_ptr is access HamConstraintGridArray;
   type MomConstraintGridArray_ptr is access MomConstraintGridArray;

   gab_ptr     : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   Kab_ptr     : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   N_ptr       : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   dot_gab_ptr : MetricGridArray_ptr  := new MetricGridArray  (1..max_num_x, 1..max_num_y, 1..max_num_z);
   dot_Kab_ptr : ExtcurvGridArray_ptr := new ExtcurvGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   dot_N_ptr   : LapseGridArray_ptr   := new LapseGridArray   (1..max_num_x, 1..max_num_y, 1..max_num_z);

   Ham_ptr     : HamConstraintGridArray_ptr := new HamConstraintGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);
   Mom_ptr     : MomConstraintGridArray_ptr := new MomConstraintGridArray (1..max_num_x, 1..max_num_y, 1..max_num_z);

   gab         : MetricGridArray  renames gab_ptr.all;
   Kab         : ExtcurvGridArray renames Kab_ptr.all;
   N           : LapseGridArray   renames N_ptr.all;

   dot_gab     : MetricGridArray  renames dot_gab_ptr.all;
   dot_Kab     : ExtcurvGridArray renames dot_Kab_ptr.all;
   dot_N       : LapseGridArray   renames dot_N_ptr.all;

   Ham         : HamConstraintGridArray renames Ham_ptr.all;
   Mom         : MomConstraintGridArray renames Mom_ptr.all;

   ----------------------------------------------------------------------------

   dx, dy, dz : Real;
   num_x, num_y, num_z : Integer;

   type GridPoint is record
      i, j, k : Integer;
      x, y, z : Real;
   end record;

   type GridPointList     is Array (Integer range <>) of GridPoint;
   type GridIndexList     is Array (Integer range <>) of Integer;

   type GridPointList_ptr is access GridPointList;
   type GridIndexList_ptr is access GridIndexList;

   grid_point_list_ptr : GridPointList_ptr := new GridPointList (1..max_num_points);

   grid_point_list : GridPointList renames grid_point_list_ptr.all;
   grid_point_num  : Integer;

   interior_ptr    : GridIndexList_ptr := new GridIndexList (1..max_num_points);
   boundary_ptr    : GridIndexList_ptr := new GridIndexList (1..2*max_num_x*max_num_y
                                                               +2*max_num_x*max_num_z
                                                               +2*max_num_y*max_num_z);

   north_bndry_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_y);
   south_bndry_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_y);
   east_bndry_ptr  : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_z);
   west_bndry_ptr  : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_z);
   front_bndry_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_y*max_num_z);
   back_bndry_ptr  : GridIndexList_ptr := new GridIndexList (1..max_num_y*max_num_z);

   interior        : GridIndexList renames interior_ptr.all;
   boundary        : GridIndexList renames boundary_ptr.all;

   north_bndry     : GridIndexList renames north_bndry_ptr.all;
   south_bndry     : GridIndexList renames south_bndry_ptr.all;
   east_bndry      : GridIndexList renames east_bndry_ptr.all;
   west_bndry      : GridIndexList renames west_bndry_ptr.all;
   front_bndry     : GridIndexList renames front_bndry_ptr.all;
   back_bndry      : GridIndexList renames back_bndry_ptr.all;

   interior_num    : Integer;
   boundary_num    : Integer;

   north_bndry_num : Integer;
   south_bndry_num : Integer;
   east_bndry_num  : Integer;
   west_bndry_num  : Integer;
   front_bndry_num : Integer;
   back_bndry_num  : Integer;

   ----------------------------------------------------------------------------

   the_time : Real := 0.0;
   beg_time : Real := 0.0;  -- used only by adminitial
   end_time : Real := 1.0;  -- used only by admevolve

   num_loop : Integer := 0;       -- number of time steps so far
   max_loop : Integer := 100;     -- maximum allowed number of time steps

   courant     : Real := 0.25;    -- used to set the current time step
   courant_min : Real := 0.025;   -- used to set the minimum time step

   print_cycle     : Integer := -1;          -- time steps between results
   print_time      : Real    := 666.6e66;    -- time at which results will be written
   print_time_step : Real    := 666.6e66;    -- time step bewteen results

   time_step     : Real := 0.01;             -- time step :)
   time_step_min : Real := 0.001;            -- minimum allowed tme step
   constant_time_step : Real := 1.0e66;      -- constant time step, default is to use the courant time step

   num_cpus   : Integer := 1;
   num_slaves : Integer := 1;

   ----------------------------------------------------------------------------

   function "-" (Right : MetricPointArray) return MetricPointArray;
   function "-" (Right : ExtcurvPointArray) return ExtcurvPointArray;

   function "-" (Left : MetricPointArray; Right : MetricPointArray) return MetricPointArray;
   function "+" (Left : MetricPointArray; Right : MetricPointArray) return MetricPointArray;
   function "*" (Left : Real; Right : MetricPointArray) return MetricPointArray;
   function "/" (Left : MetricPointArray; Right : Real) return MetricPointArray;

   function "-" (Left : ExtcurvPointArray; Right : ExtcurvPointArray) return ExtcurvPointArray;
   function "+" (Left : ExtcurvPointArray; Right : ExtcurvPointArray) return ExtcurvPointArray;
   function "*" (Left : Real; Right : ExtcurvPointArray) return ExtcurvPointArray;
   function "/" (Left : ExtcurvPointArray; Right : Real) return ExtcurvPointArray;

   Function symm_inverse (gab :  MetricPointArray)
                          Return MetricPointArray;

   Function symm_det (gab :  MetricPointArray)
                      Return Real;

   Function symm_trace (mat : ExtcurvPointArray;
                        iab : MetricPointArray)
                        Return Real;

   Function symm_raise_indices (Mdn : MetricPointArray;
                                iab : MetricPointArray)
                                Return MetricPointArray;

   Function symm_raise_indices (Mdn : ExtcurvPointArray;
                                iab : MetricPointArray)
                                Return ExtcurvPointArray;
end ADMBase;
