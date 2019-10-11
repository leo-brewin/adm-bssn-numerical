pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__bssnevolve.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__bssnevolve.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E011 : Short_Integer; pragma Import (Ada, E011, "system__soft_links_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__soft_links__initialize_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__io_exceptions_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "ada__numerics_E");
   E146 : Short_Integer; pragma Import (Ada, E146, "ada__strings_E");
   E126 : Short_Integer; pragma Import (Ada, E126, "gnat_E");
   E135 : Short_Integer; pragma Import (Ada, E135, "interfaces__c_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "system__os_lib_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__tags_E");
   E054 : Short_Integer; pragma Import (Ada, E054, "ada__streams_E");
   E081 : Short_Integer; pragma Import (Ada, E081, "system__file_control_block_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__finalization_root_E");
   E074 : Short_Integer; pragma Import (Ada, E074, "ada__finalization_E");
   E073 : Short_Integer; pragma Import (Ada, E073, "system__file_io_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "ada__streams__stream_io_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "system__storage_pools_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "system__finalization_masters_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "system__storage_pools__subpools_E");
   E133 : Short_Integer; pragma Import (Ada, E133, "ada__calendar_E");
   E141 : Short_Integer; pragma Import (Ada, E141, "ada__calendar__time_zones_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "ada__real_time_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "ada__text_io_E");
   E148 : Short_Integer; pragma Import (Ada, E148, "ada__strings__maps_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "ada__strings__maps__constants_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "ada__strings__unbounded_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "system__regpat_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "system__regexp_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "ada__directories_E");
   E254 : Short_Integer; pragma Import (Ada, E254, "system__tasking__initialization_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "system__tasking__protected_objects_E");
   E264 : Short_Integer; pragma Import (Ada, E264, "system__tasking__protected_objects__entries_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "system__tasking__queuing_E");
   E272 : Short_Integer; pragma Import (Ada, E272, "system__tasking__stages_E");
   E125 : Short_Integer; pragma Import (Ada, E125, "support_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "bssnbase_E");
   E234 : Short_Integer; pragma Import (Ada, E234, "bssnbase__adm_bssn_E");
   E236 : Short_Integer; pragma Import (Ada, E236, "bssnbase__constraints_E");
   E238 : Short_Integer; pragma Import (Ada, E238, "bssnbase__coords_E");
   E230 : Short_Integer; pragma Import (Ada, E230, "bssnbase__runge_E");
   E246 : Short_Integer; pragma Import (Ada, E246, "bssnbase__time_derivs_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "support__strings_E");
   E240 : Short_Integer; pragma Import (Ada, E240, "support__clock_E");
   E193 : Short_Integer; pragma Import (Ada, E193, "support__regex_E");
   E189 : Short_Integer; pragma Import (Ada, E189, "support__cmdline_E");
   E129 : Short_Integer; pragma Import (Ada, E129, "bssnbase__data_io_E");
   E232 : Short_Integer; pragma Import (Ada, E232, "bssnbase__text_io_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "bssnbase__evolve_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E264 := E264 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F1;
      end;
      E131 := E131 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "ada__directories__finalize_spec");
      begin
         F2;
      end;
      E183 := E183 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__regexp__finalize_spec");
      begin
         F3;
      end;
      E159 := E159 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "ada__strings__unbounded__finalize_spec");
      begin
         F4;
      end;
      E052 := E052 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "ada__text_io__finalize_spec");
      begin
         F5;
      end;
      E165 := E165 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__storage_pools__subpools__finalize_spec");
      begin
         F6;
      end;
      E167 := E167 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__finalization_masters__finalize_spec");
      begin
         F7;
      end;
      E185 := E185 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "ada__streams__stream_io__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__file_io__finalize_body");
      begin
         E073 := E073 - 1;
         F9;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Exception_Tracebacks : Integer;
      pragma Import (C, Exception_Tracebacks, "__gl_exception_tracebacks");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, True, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, False, False, False, True, True, False, False, 
           True, False, False, True, True, True, True, False, 
           False, False, False, False, True, True, False, True, 
           True, False, True, True, True, True, False, True, 
           False, False, False, True, False, False, True, False, 
           True, False, False, True, False, False, False, True, 
           True, False, False, True, False, True, False, False, 
           False, True, False, True, True, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, True, True, True, True, False, 
           False, True, False, False, False, False, True, True, 
           True, False, False, False),
         Count => (0, 0, 0, 0, 3, 4, 1, 0, 0, 0),
         Unknown => (False, False, False, False, False, False, True, False, False, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Exception_Tracebacks := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E023 := E023 + 1;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E019 := E019 + 1;
      E011 := E011 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E055 := E055 + 1;
      Ada.Numerics'Elab_Spec;
      E120 := E120 + 1;
      Ada.Strings'Elab_Spec;
      E146 := E146 + 1;
      Gnat'Elab_Spec;
      E126 := E126 + 1;
      Interfaces.C'Elab_Spec;
      E135 := E135 + 1;
      System.Os_Lib'Elab_Body;
      E078 := E078 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E057 := E057 + 1;
      Ada.Streams'Elab_Spec;
      E054 := E054 + 1;
      System.File_Control_Block'Elab_Spec;
      E081 := E081 + 1;
      System.Finalization_Root'Elab_Spec;
      E076 := E076 + 1;
      Ada.Finalization'Elab_Spec;
      E074 := E074 + 1;
      System.File_Io'Elab_Body;
      E073 := E073 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      E185 := E185 + 1;
      System.Storage_Pools'Elab_Spec;
      E173 := E173 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E167 := E167 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E165 := E165 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E133 := E133 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E141 := E141 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E204 := E204 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E052 := E052 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E148 := E148 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E151 := E151 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E159 := E159 + 1;
      System.Regpat'Elab_Spec;
      E196 := E196 + 1;
      System.Regexp'Elab_Spec;
      E183 := E183 + 1;
      Ada.Directories'Elab_Spec;
      Ada.Directories'Elab_Body;
      E131 := E131 + 1;
      System.Tasking.Initialization'Elab_Body;
      E254 := E254 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E262 := E262 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E264 := E264 + 1;
      System.Tasking.Queuing'Elab_Body;
      E268 := E268 + 1;
      System.Tasking.Stages'Elab_Body;
      E272 := E272 + 1;
      E125 := E125 + 1;
      Bssnbase'Elab_Spec;
      E119 := E119 + 1;
      E234 := E234 + 1;
      E236 := E236 + 1;
      E238 := E238 + 1;
      bssnbase.runge'elab_body;
      E230 := E230 + 1;
      E246 := E246 + 1;
      E200 := E200 + 1;
      E240 := E240 + 1;
      Support.Regex'Elab_Body;
      E193 := E193 + 1;
      Support.Cmdline'Elab_Body;
      E189 := E189 + 1;
      bssnbase.data_io'elab_body;
      E129 := E129 + 1;
      bssnbase.text_io'elab_spec;
      bssnbase.text_io'elab_body;
      E232 := E232 + 1;
      E202 := E202 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_bssnevolve");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/support.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-adm_bssn.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-constraints.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-coords.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-runge.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-time_derivs.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/support-strings.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/support-clock.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/support-regex.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/support-cmdline.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-data_io.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-text_io.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnbase-evolve.o
   --   /Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/bssnevolve.o
   --   -L/Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/
   --   -L/Users/leo/GitHub/leo-brewin/adm-bssn-numerical/bssn/code/obj/
   --   -L/usr/local/gnat/lib/gcc/x86_64-apple-darwin17.7.0/8.3.1/adalib/
   --   -shared
   --   -lgnarl-2019
   --   -lgnat-2019
--  END Object file/option list   

end ada_main;
