-- for text io
with Ada.Text_IO;            use Ada.Text_IO;
with Support.Strings;        use Support.Strings;

with System.Multiprocessors;
procedure NumCPU is

   package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);   use Integer_IO;

begin

   Put_Line ("Number of CPUs: "&str(Integer(System.Multiprocessors.Number_Of_CPUs)));

end NumCPU;
