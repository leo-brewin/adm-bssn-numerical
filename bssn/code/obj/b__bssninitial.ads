pragma Warnings (Off);
pragma Ada_95;
with System;
with System.Parameters;
with System.Secondary_Stack;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: Community 2019 (20190517-83)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_bssninitial" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#211609ee#;
   pragma Export (C, u00001, "bssninitialB");
   u00002 : constant Version_32 := 16#050ff2f0#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#0f7d71d4#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#76789da1#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#f4e097a7#;
   pragma Export (C, u00005, "ada__text_ioB");
   u00006 : constant Version_32 := 16#3913d0d6#;
   pragma Export (C, u00006, "ada__text_ioS");
   u00007 : constant Version_32 := 16#d90c4a0d#;
   pragma Export (C, u00007, "ada__exceptionsB");
   u00008 : constant Version_32 := 16#16307b94#;
   pragma Export (C, u00008, "ada__exceptionsS");
   u00009 : constant Version_32 := 16#5726abed#;
   pragma Export (C, u00009, "ada__exceptions__last_chance_handlerB");
   u00010 : constant Version_32 := 16#41e5552e#;
   pragma Export (C, u00010, "ada__exceptions__last_chance_handlerS");
   u00011 : constant Version_32 := 16#085b6ffb#;
   pragma Export (C, u00011, "systemS");
   u00012 : constant Version_32 := 16#ae860117#;
   pragma Export (C, u00012, "system__soft_linksB");
   u00013 : constant Version_32 := 16#4d58644d#;
   pragma Export (C, u00013, "system__soft_linksS");
   u00014 : constant Version_32 := 16#bd45c2cc#;
   pragma Export (C, u00014, "system__secondary_stackB");
   u00015 : constant Version_32 := 16#4dcf97e2#;
   pragma Export (C, u00015, "system__secondary_stackS");
   u00016 : constant Version_32 := 16#86dbf443#;
   pragma Export (C, u00016, "system__parametersB");
   u00017 : constant Version_32 := 16#40b73bd0#;
   pragma Export (C, u00017, "system__parametersS");
   u00018 : constant Version_32 := 16#ced09590#;
   pragma Export (C, u00018, "system__storage_elementsB");
   u00019 : constant Version_32 := 16#259825ff#;
   pragma Export (C, u00019, "system__storage_elementsS");
   u00020 : constant Version_32 := 16#75bf515c#;
   pragma Export (C, u00020, "system__soft_links__initializeB");
   u00021 : constant Version_32 := 16#5697fc2b#;
   pragma Export (C, u00021, "system__soft_links__initializeS");
   u00022 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00022, "system__stack_checkingB");
   u00023 : constant Version_32 := 16#86e40413#;
   pragma Export (C, u00023, "system__stack_checkingS");
   u00024 : constant Version_32 := 16#34742901#;
   pragma Export (C, u00024, "system__exception_tableB");
   u00025 : constant Version_32 := 16#55f506b9#;
   pragma Export (C, u00025, "system__exception_tableS");
   u00026 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00026, "system__exceptionsB");
   u00027 : constant Version_32 := 16#6038020d#;
   pragma Export (C, u00027, "system__exceptionsS");
   u00028 : constant Version_32 := 16#69416224#;
   pragma Export (C, u00028, "system__exceptions__machineB");
   u00029 : constant Version_32 := 16#d27d9682#;
   pragma Export (C, u00029, "system__exceptions__machineS");
   u00030 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00030, "system__exceptions_debugB");
   u00031 : constant Version_32 := 16#76d1963f#;
   pragma Export (C, u00031, "system__exceptions_debugS");
   u00032 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00032, "system__img_intB");
   u00033 : constant Version_32 := 16#0a808f39#;
   pragma Export (C, u00033, "system__img_intS");
   u00034 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00034, "system__tracebackB");
   u00035 : constant Version_32 := 16#5679b13f#;
   pragma Export (C, u00035, "system__tracebackS");
   u00036 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00036, "system__traceback_entriesB");
   u00037 : constant Version_32 := 16#0800998b#;
   pragma Export (C, u00037, "system__traceback_entriesS");
   u00038 : constant Version_32 := 16#bb296fbb#;
   pragma Export (C, u00038, "system__traceback__symbolicB");
   u00039 : constant Version_32 := 16#c84061d1#;
   pragma Export (C, u00039, "system__traceback__symbolicS");
   u00040 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00040, "ada__exceptions__tracebackB");
   u00041 : constant Version_32 := 16#20245e75#;
   pragma Export (C, u00041, "ada__exceptions__tracebackS");
   u00042 : constant Version_32 := 16#a0d3d22b#;
   pragma Export (C, u00042, "system__address_imageB");
   u00043 : constant Version_32 := 16#a9b7f2c1#;
   pragma Export (C, u00043, "system__address_imageS");
   u00044 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00044, "system__wch_conB");
   u00045 : constant Version_32 := 16#13264d29#;
   pragma Export (C, u00045, "system__wch_conS");
   u00046 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00046, "system__wch_stwB");
   u00047 : constant Version_32 := 16#3e376128#;
   pragma Export (C, u00047, "system__wch_stwS");
   u00048 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00048, "system__wch_cnvB");
   u00049 : constant Version_32 := 16#1c91f7da#;
   pragma Export (C, u00049, "system__wch_cnvS");
   u00050 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00050, "interfacesS");
   u00051 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00051, "system__wch_jisB");
   u00052 : constant Version_32 := 16#9ce1eefb#;
   pragma Export (C, u00052, "system__wch_jisS");
   u00053 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00053, "ada__streamsB");
   u00054 : constant Version_32 := 16#67e31212#;
   pragma Export (C, u00054, "ada__streamsS");
   u00055 : constant Version_32 := 16#92d882c5#;
   pragma Export (C, u00055, "ada__io_exceptionsS");
   u00056 : constant Version_32 := 16#d398a95f#;
   pragma Export (C, u00056, "ada__tagsB");
   u00057 : constant Version_32 := 16#12a0afb8#;
   pragma Export (C, u00057, "ada__tagsS");
   u00058 : constant Version_32 := 16#796f31f1#;
   pragma Export (C, u00058, "system__htableB");
   u00059 : constant Version_32 := 16#8c99dc11#;
   pragma Export (C, u00059, "system__htableS");
   u00060 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00060, "system__string_hashB");
   u00061 : constant Version_32 := 16#2ec7b76f#;
   pragma Export (C, u00061, "system__string_hashS");
   u00062 : constant Version_32 := 16#3cdd1378#;
   pragma Export (C, u00062, "system__unsigned_typesS");
   u00063 : constant Version_32 := 16#b8e72903#;
   pragma Export (C, u00063, "system__val_lluB");
   u00064 : constant Version_32 := 16#51139e9a#;
   pragma Export (C, u00064, "system__val_lluS");
   u00065 : constant Version_32 := 16#269742a9#;
   pragma Export (C, u00065, "system__val_utilB");
   u00066 : constant Version_32 := 16#a4fbd905#;
   pragma Export (C, u00066, "system__val_utilS");
   u00067 : constant Version_32 := 16#ec4d5631#;
   pragma Export (C, u00067, "system__case_utilB");
   u00068 : constant Version_32 := 16#378ed9af#;
   pragma Export (C, u00068, "system__case_utilS");
   u00069 : constant Version_32 := 16#73d2d764#;
   pragma Export (C, u00069, "interfaces__c_streamsB");
   u00070 : constant Version_32 := 16#b1330297#;
   pragma Export (C, u00070, "interfaces__c_streamsS");
   u00071 : constant Version_32 := 16#4e0ce0a1#;
   pragma Export (C, u00071, "system__crtlS");
   u00072 : constant Version_32 := 16#ec083f01#;
   pragma Export (C, u00072, "system__file_ioB");
   u00073 : constant Version_32 := 16#af2a8e9e#;
   pragma Export (C, u00073, "system__file_ioS");
   u00074 : constant Version_32 := 16#86c56e5a#;
   pragma Export (C, u00074, "ada__finalizationS");
   u00075 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00075, "system__finalization_rootB");
   u00076 : constant Version_32 := 16#47a91c6b#;
   pragma Export (C, u00076, "system__finalization_rootS");
   u00077 : constant Version_32 := 16#e4774a28#;
   pragma Export (C, u00077, "system__os_libB");
   u00078 : constant Version_32 := 16#d8e681fb#;
   pragma Export (C, u00078, "system__os_libS");
   u00079 : constant Version_32 := 16#2a8e89ad#;
   pragma Export (C, u00079, "system__stringsB");
   u00080 : constant Version_32 := 16#684d436e#;
   pragma Export (C, u00080, "system__stringsS");
   u00081 : constant Version_32 := 16#f5c4f553#;
   pragma Export (C, u00081, "system__file_control_blockS");
   u00082 : constant Version_32 := 16#69802825#;
   pragma Export (C, u00082, "bssnbaseB");
   u00083 : constant Version_32 := 16#6479164d#;
   pragma Export (C, u00083, "bssnbaseS");
   u00084 : constant Version_32 := 16#cd2959fb#;
   pragma Export (C, u00084, "ada__numericsS");
   u00085 : constant Version_32 := 16#e5114ee9#;
   pragma Export (C, u00085, "ada__numerics__auxB");
   u00086 : constant Version_32 := 16#9f6e24ed#;
   pragma Export (C, u00086, "ada__numerics__auxS");
   u00087 : constant Version_32 := 16#0cccd408#;
   pragma Export (C, u00087, "system__fat_llfS");
   u00088 : constant Version_32 := 16#6533c8fa#;
   pragma Export (C, u00088, "system__machine_codeS");
   u00089 : constant Version_32 := 16#25afee5b#;
   pragma Export (C, u00089, "ada__text_io__float_auxB");
   u00090 : constant Version_32 := 16#6ecdea4c#;
   pragma Export (C, u00090, "ada__text_io__float_auxS");
   u00091 : constant Version_32 := 16#181dc502#;
   pragma Export (C, u00091, "ada__text_io__generic_auxB");
   u00092 : constant Version_32 := 16#305a076a#;
   pragma Export (C, u00092, "ada__text_io__generic_auxS");
   u00093 : constant Version_32 := 16#8aa4f090#;
   pragma Export (C, u00093, "system__img_realB");
   u00094 : constant Version_32 := 16#cff33e19#;
   pragma Export (C, u00094, "system__img_realS");
   u00095 : constant Version_32 := 16#1b28662b#;
   pragma Export (C, u00095, "system__float_controlB");
   u00096 : constant Version_32 := 16#e8a72cc7#;
   pragma Export (C, u00096, "system__float_controlS");
   u00097 : constant Version_32 := 16#3e932977#;
   pragma Export (C, u00097, "system__img_lluB");
   u00098 : constant Version_32 := 16#751413bb#;
   pragma Export (C, u00098, "system__img_lluS");
   u00099 : constant Version_32 := 16#ec78c2bf#;
   pragma Export (C, u00099, "system__img_unsB");
   u00100 : constant Version_32 := 16#a3292f8f#;
   pragma Export (C, u00100, "system__img_unsS");
   u00101 : constant Version_32 := 16#582b098c#;
   pragma Export (C, u00101, "system__powten_tableS");
   u00102 : constant Version_32 := 16#c5134340#;
   pragma Export (C, u00102, "system__val_realB");
   u00103 : constant Version_32 := 16#0624832e#;
   pragma Export (C, u00103, "system__val_realS");
   u00104 : constant Version_32 := 16#b2a569d2#;
   pragma Export (C, u00104, "system__exn_llfB");
   u00105 : constant Version_32 := 16#b425d427#;
   pragma Export (C, u00105, "system__exn_llfS");
   u00106 : constant Version_32 := 16#fdedfd10#;
   pragma Export (C, u00106, "ada__text_io__integer_auxB");
   u00107 : constant Version_32 := 16#2fe01d89#;
   pragma Export (C, u00107, "ada__text_io__integer_auxS");
   u00108 : constant Version_32 := 16#b10ba0c7#;
   pragma Export (C, u00108, "system__img_biuB");
   u00109 : constant Version_32 := 16#faff9b35#;
   pragma Export (C, u00109, "system__img_biuS");
   u00110 : constant Version_32 := 16#4e06ab0c#;
   pragma Export (C, u00110, "system__img_llbB");
   u00111 : constant Version_32 := 16#bb388bcb#;
   pragma Export (C, u00111, "system__img_llbS");
   u00112 : constant Version_32 := 16#9dca6636#;
   pragma Export (C, u00112, "system__img_lliB");
   u00113 : constant Version_32 := 16#19143a2a#;
   pragma Export (C, u00113, "system__img_lliS");
   u00114 : constant Version_32 := 16#a756d097#;
   pragma Export (C, u00114, "system__img_llwB");
   u00115 : constant Version_32 := 16#1254a85d#;
   pragma Export (C, u00115, "system__img_llwS");
   u00116 : constant Version_32 := 16#eb55dfbb#;
   pragma Export (C, u00116, "system__img_wiuB");
   u00117 : constant Version_32 := 16#94be1ca7#;
   pragma Export (C, u00117, "system__img_wiuS");
   u00118 : constant Version_32 := 16#0f9783a4#;
   pragma Export (C, u00118, "system__val_intB");
   u00119 : constant Version_32 := 16#bda40698#;
   pragma Export (C, u00119, "system__val_intS");
   u00120 : constant Version_32 := 16#383fd226#;
   pragma Export (C, u00120, "system__val_unsB");
   u00121 : constant Version_32 := 16#09db6ec1#;
   pragma Export (C, u00121, "system__val_unsS");
   u00122 : constant Version_32 := 16#fb020d94#;
   pragma Export (C, u00122, "system__val_lliB");
   u00123 : constant Version_32 := 16#6435fd0b#;
   pragma Export (C, u00123, "system__val_lliS");
   u00124 : constant Version_32 := 16#4d89d64a#;
   pragma Export (C, u00124, "supportB");
   u00125 : constant Version_32 := 16#c1643455#;
   pragma Export (C, u00125, "supportS");
   u00126 : constant Version_32 := 16#b5988c27#;
   pragma Export (C, u00126, "gnatS");
   u00127 : constant Version_32 := 16#ef2c0748#;
   pragma Export (C, u00127, "gnat__os_libS");
   u00128 : constant Version_32 := 16#8aa1ce6b#;
   pragma Export (C, u00128, "bssnbase__data_ioB");
   u00129 : constant Version_32 := 16#458a3bc5#;
   pragma Export (C, u00129, "bssnbase__data_ioS");
   u00130 : constant Version_32 := 16#ba821203#;
   pragma Export (C, u00130, "ada__directoriesB");
   u00131 : constant Version_32 := 16#7b0ecd0f#;
   pragma Export (C, u00131, "ada__directoriesS");
   u00132 : constant Version_32 := 16#fc54e290#;
   pragma Export (C, u00132, "ada__calendarB");
   u00133 : constant Version_32 := 16#31350a81#;
   pragma Export (C, u00133, "ada__calendarS");
   u00134 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00134, "interfaces__cB");
   u00135 : constant Version_32 := 16#467817d8#;
   pragma Export (C, u00135, "interfaces__cS");
   u00136 : constant Version_32 := 16#2b2125d3#;
   pragma Export (C, u00136, "system__os_primitivesB");
   u00137 : constant Version_32 := 16#0fa60a0d#;
   pragma Export (C, u00137, "system__os_primitivesS");
   u00138 : constant Version_32 := 16#e5331d7b#;
   pragma Export (C, u00138, "ada__calendar__formattingB");
   u00139 : constant Version_32 := 16#0dbf7387#;
   pragma Export (C, u00139, "ada__calendar__formattingS");
   u00140 : constant Version_32 := 16#e3cca715#;
   pragma Export (C, u00140, "ada__calendar__time_zonesB");
   u00141 : constant Version_32 := 16#07d0e97b#;
   pragma Export (C, u00141, "ada__calendar__time_zonesS");
   u00142 : constant Version_32 := 16#5b4659fa#;
   pragma Export (C, u00142, "ada__charactersS");
   u00143 : constant Version_32 := 16#8f637df8#;
   pragma Export (C, u00143, "ada__characters__handlingB");
   u00144 : constant Version_32 := 16#3b3f6154#;
   pragma Export (C, u00144, "ada__characters__handlingS");
   u00145 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00145, "ada__characters__latin_1S");
   u00146 : constant Version_32 := 16#e6d4fa36#;
   pragma Export (C, u00146, "ada__stringsS");
   u00147 : constant Version_32 := 16#96df1a3f#;
   pragma Export (C, u00147, "ada__strings__mapsB");
   u00148 : constant Version_32 := 16#1e526bec#;
   pragma Export (C, u00148, "ada__strings__mapsS");
   u00149 : constant Version_32 := 16#98e13b0e#;
   pragma Export (C, u00149, "system__bit_opsB");
   u00150 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00150, "system__bit_opsS");
   u00151 : constant Version_32 := 16#92f05f13#;
   pragma Export (C, u00151, "ada__strings__maps__constantsS");
   u00152 : constant Version_32 := 16#ab4ad33a#;
   pragma Export (C, u00152, "ada__directories__validityB");
   u00153 : constant Version_32 := 16#498b13d5#;
   pragma Export (C, u00153, "ada__directories__validityS");
   u00154 : constant Version_32 := 16#bf363ed2#;
   pragma Export (C, u00154, "ada__strings__fixedB");
   u00155 : constant Version_32 := 16#fec1aafc#;
   pragma Export (C, u00155, "ada__strings__fixedS");
   u00156 : constant Version_32 := 16#2eb48a6d#;
   pragma Export (C, u00156, "ada__strings__searchB");
   u00157 : constant Version_32 := 16#c1ab8667#;
   pragma Export (C, u00157, "ada__strings__searchS");
   u00158 : constant Version_32 := 16#351539c5#;
   pragma Export (C, u00158, "ada__strings__unboundedB");
   u00159 : constant Version_32 := 16#6552cb60#;
   pragma Export (C, u00159, "ada__strings__unboundedS");
   u00160 : constant Version_32 := 16#acee74ad#;
   pragma Export (C, u00160, "system__compare_array_unsigned_8B");
   u00161 : constant Version_32 := 16#a1581e76#;
   pragma Export (C, u00161, "system__compare_array_unsigned_8S");
   u00162 : constant Version_32 := 16#a8025f3c#;
   pragma Export (C, u00162, "system__address_operationsB");
   u00163 : constant Version_32 := 16#1b57d1c8#;
   pragma Export (C, u00163, "system__address_operationsS");
   u00164 : constant Version_32 := 16#2e260032#;
   pragma Export (C, u00164, "system__storage_pools__subpoolsB");
   u00165 : constant Version_32 := 16#cc5a1856#;
   pragma Export (C, u00165, "system__storage_pools__subpoolsS");
   u00166 : constant Version_32 := 16#d96e3c40#;
   pragma Export (C, u00166, "system__finalization_mastersB");
   u00167 : constant Version_32 := 16#53a75631#;
   pragma Export (C, u00167, "system__finalization_mastersS");
   u00168 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00168, "system__img_boolB");
   u00169 : constant Version_32 := 16#fd821e10#;
   pragma Export (C, u00169, "system__img_boolS");
   u00170 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00170, "system__ioB");
   u00171 : constant Version_32 := 16#961998b4#;
   pragma Export (C, u00171, "system__ioS");
   u00172 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00172, "system__storage_poolsB");
   u00173 : constant Version_32 := 16#2bb6f156#;
   pragma Export (C, u00173, "system__storage_poolsS");
   u00174 : constant Version_32 := 16#84042202#;
   pragma Export (C, u00174, "system__storage_pools__subpools__finalizationB");
   u00175 : constant Version_32 := 16#fe2f4b3a#;
   pragma Export (C, u00175, "system__storage_pools__subpools__finalizationS");
   u00176 : constant Version_32 := 16#020a3f4d#;
   pragma Export (C, u00176, "system__atomic_countersB");
   u00177 : constant Version_32 := 16#bc074276#;
   pragma Export (C, u00177, "system__atomic_countersS");
   u00178 : constant Version_32 := 16#039168f8#;
   pragma Export (C, u00178, "system__stream_attributesB");
   u00179 : constant Version_32 := 16#8bc30a4e#;
   pragma Export (C, u00179, "system__stream_attributesS");
   u00180 : constant Version_32 := 16#c3fe6846#;
   pragma Export (C, u00180, "system__file_attributesS");
   u00181 : constant Version_32 := 16#b870d14d#;
   pragma Export (C, u00181, "system__os_constantsS");
   u00182 : constant Version_32 := 16#95f86c43#;
   pragma Export (C, u00182, "system__regexpB");
   u00183 : constant Version_32 := 16#2b69c837#;
   pragma Export (C, u00183, "system__regexpS");
   u00184 : constant Version_32 := 16#db0aa7dc#;
   pragma Export (C, u00184, "ada__streams__stream_ioB");
   u00185 : constant Version_32 := 16#55e6e4b0#;
   pragma Export (C, u00185, "ada__streams__stream_ioS");
   u00186 : constant Version_32 := 16#5de653db#;
   pragma Export (C, u00186, "system__communicationB");
   u00187 : constant Version_32 := 16#113b3a29#;
   pragma Export (C, u00187, "system__communicationS");
   u00188 : constant Version_32 := 16#1291404b#;
   pragma Export (C, u00188, "support__cmdlineB");
   u00189 : constant Version_32 := 16#b90a7d55#;
   pragma Export (C, u00189, "support__cmdlineS");
   u00190 : constant Version_32 := 16#01a73f89#;
   pragma Export (C, u00190, "ada__command_lineB");
   u00191 : constant Version_32 := 16#3cdef8c9#;
   pragma Export (C, u00191, "ada__command_lineS");
   u00192 : constant Version_32 := 16#0809f29b#;
   pragma Export (C, u00192, "support__regexB");
   u00193 : constant Version_32 := 16#8d70645e#;
   pragma Export (C, u00193, "support__regexS");
   u00194 : constant Version_32 := 16#8f9f9fb7#;
   pragma Export (C, u00194, "gnat__regpatS");
   u00195 : constant Version_32 := 16#863444e5#;
   pragma Export (C, u00195, "system__regpatB");
   u00196 : constant Version_32 := 16#8a01f484#;
   pragma Export (C, u00196, "system__regpatS");
   u00197 : constant Version_32 := 16#2b93a046#;
   pragma Export (C, u00197, "system__img_charB");
   u00198 : constant Version_32 := 16#946f371c#;
   pragma Export (C, u00198, "system__img_charS");
   u00199 : constant Version_32 := 16#1fcea9da#;
   pragma Export (C, u00199, "support__stringsB");
   u00200 : constant Version_32 := 16#2860f389#;
   pragma Export (C, u00200, "support__stringsS");
   u00201 : constant Version_32 := 16#a867cec6#;
   pragma Export (C, u00201, "bssnbase__initialB");
   u00202 : constant Version_32 := 16#2a544e6b#;
   pragma Export (C, u00202, "bssnbase__initialS");
   u00203 : constant Version_32 := 16#133c9dc2#;
   pragma Export (C, u00203, "bssnbase__coordsB");
   u00204 : constant Version_32 := 16#e596442d#;
   pragma Export (C, u00204, "bssnbase__coordsS");
   u00205 : constant Version_32 := 16#0950d218#;
   pragma Export (C, u00205, "metricS");
   u00206 : constant Version_32 := 16#8be72522#;
   pragma Export (C, u00206, "metric__kasnerB");
   u00207 : constant Version_32 := 16#06bdfe16#;
   pragma Export (C, u00207, "metric__kasnerS");
   u00208 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00208, "system__concat_5B");
   u00209 : constant Version_32 := 16#8f052cd5#;
   pragma Export (C, u00209, "system__concat_5S");
   u00210 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00210, "system__concat_4B");
   u00211 : constant Version_32 := 16#763f44db#;
   pragma Export (C, u00211, "system__concat_4S");
   u00212 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00212, "system__concat_3B");
   u00213 : constant Version_32 := 16#032b335e#;
   pragma Export (C, u00213, "system__concat_3S");
   u00214 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00214, "system__concat_2B");
   u00215 : constant Version_32 := 16#0afbb82b#;
   pragma Export (C, u00215, "system__concat_2S");
   u00216 : constant Version_32 := 16#e31b7c4e#;
   pragma Export (C, u00216, "system__memoryB");
   u00217 : constant Version_32 := 16#512609cf#;
   pragma Export (C, u00217, "system__memoryS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.latin_1%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.float_control%s
   --  system.float_control%b
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_char%s
   --  system.img_char%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.machine_code%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%s
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  system.unsigned_types%s
   --  system.img_biu%s
   --  system.img_biu%b
   --  system.img_llb%s
   --  system.img_llb%b
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_llw%s
   --  system.img_llw%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_wiu%s
   --  system.img_wiu%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%s
   --  system.wch_cnv%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.secondary_stack%s
   --  system.standard_library%s
   --  ada.exceptions%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.soft_links%s
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  ada.exceptions.traceback%b
   --  system.address_image%s
   --  system.address_image%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.exceptions.machine%b
   --  system.memory%s
   --  system.memory%b
   --  system.secondary_stack%b
   --  system.soft_links.initialize%s
   --  system.soft_links.initialize%b
   --  system.soft_links%b
   --  system.standard_library%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  ada.command_line%s
   --  ada.command_line%b
   --  ada.io_exceptions%s
   --  ada.numerics%s
   --  ada.strings%s
   --  gnat%s
   --  interfaces.c%s
   --  interfaces.c%b
   --  system.case_util%s
   --  system.case_util%b
   --  system.fat_llf%s
   --  ada.numerics.aux%s
   --  ada.numerics.aux%b
   --  system.img_real%s
   --  system.img_real%b
   --  system.os_constants%s
   --  system.os_lib%s
   --  system.os_lib%b
   --  gnat.os_lib%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_llu%s
   --  system.val_llu%b
   --  ada.tags%s
   --  ada.tags%b
   --  ada.streams%s
   --  ada.streams%b
   --  system.communication%s
   --  system.communication%b
   --  system.file_control_block%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.file_io%s
   --  system.file_io%b
   --  ada.streams.stream_io%s
   --  ada.streams.stream_io%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.finalization_masters%b
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.storage_pools.subpools%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.val_lli%s
   --  system.val_lli%b
   --  system.val_real%s
   --  system.val_real%b
   --  system.val_uns%s
   --  system.val_uns%b
   --  system.val_int%s
   --  system.val_int%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.time_zones%s
   --  ada.calendar.time_zones%b
   --  ada.calendar.formatting%s
   --  ada.calendar.formatting%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.float_aux%s
   --  ada.text_io.float_aux%b
   --  ada.text_io.integer_aux%s
   --  ada.text_io.integer_aux%b
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  ada.strings.maps%s
   --  ada.strings.maps%b
   --  ada.strings.maps.constants%s
   --  ada.characters.handling%s
   --  ada.characters.handling%b
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.strings.fixed%s
   --  ada.strings.fixed%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.regpat%s
   --  system.regpat%b
   --  gnat.regpat%s
   --  system.file_attributes%s
   --  system.regexp%s
   --  system.regexp%b
   --  ada.directories%s
   --  ada.directories.validity%s
   --  ada.directories.validity%b
   --  ada.directories%b
   --  metric%s
   --  support%s
   --  support%b
   --  bssnbase%s
   --  bssnbase%b
   --  bssnbase.coords%s
   --  bssnbase.coords%b
   --  support.strings%s
   --  support.strings%b
   --  support.regex%s
   --  support.regex%b
   --  support.cmdline%s
   --  support.cmdline%b
   --  bssnbase.data_io%s
   --  bssnbase.data_io%b
   --  metric.kasner%s
   --  metric.kasner%b
   --  bssnbase.initial%s
   --  bssnbase.initial%b
   --  bssninitial%b
   --  END ELABORATION ORDER

end ada_main;
