package ADMBase.Data_IO is

   procedure read_data (file_name : String := "data.txt");
   procedure read_grid (file_name : String := "grid.txt");
   procedure write_data (file_name : String := "data.txt");
   procedure write_grid (file_name : String := "grid.txt");

   procedure read_data_fmt (file_name : String := "data.txt");
   procedure read_grid_fmt (file_name : String := "grid.txt");
   procedure write_data_fmt (file_name : String := "data.txt");
   procedure write_grid_fmt (file_name : String := "grid.txt");

end ADMBase.Data_IO;
