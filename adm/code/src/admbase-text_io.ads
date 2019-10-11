package ADMBase.Text_IO is

   procedure write_results;
   procedure write_history;

   procedure write_summary;
   procedure write_summary_header;
   procedure write_summary_trailer;

   procedure create_text_io_lists;

   xy_index_list_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_y);
   xz_index_list_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_x*max_num_z);
   yz_index_list_ptr : GridIndexList_ptr := new GridIndexList (1..max_num_y*max_num_z);

   xy_index_list     : GridIndexList renames xy_index_list_ptr.all;
   xz_index_list     : GridIndexList renames xz_index_list_ptr.all;
   yz_index_list     : GridIndexList renames yz_index_list_ptr.all;

   xy_index_num      : Integer := 0;
   xz_index_num      : Integer := 0;
   yz_index_num      : Integer := 0;

   sample_point : GridPoint; -- the grid point used by write_history

end ADMBase.Text_IO;
