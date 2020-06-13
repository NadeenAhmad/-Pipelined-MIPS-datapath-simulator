//nadeen
//Data Memory
//1024 memory size , so 1023 is 1024-1
//memory cell size is 8 , so 7 is 8-1

module DataMemory (
clk,
Reset,
//Enables Writing in Memory (Store)
EnableWriteInMemory,
//Enables Reading from memory (Load)
EnableReadFromMemory,
//Destination Address
address, 
//Input Data from EXE2MEM register
InputData,
// Output Data to write back in register
OutputData);
integer i;
  input clk, Reset, EnableReadFromMemory, EnableWriteInMemory;
  input [31:0] address, InputData;
  output [31:0] OutputData;

  reg [7:0] DataMemory [0:1023];
  wire [31:0] BaseAddress;
 
    	     
  always @ (posedge clk) begin
   
  
  if (EnableWriteInMemory)
  {DataMemory[BaseAddress], DataMemory[BaseAddress + 1], DataMemory[BaseAddress + 2], DataMemory[BaseAddress + 3]} <= InputData;
    else 
//Reset set all bits = zero
    	  if (Reset)
    	      for (i = 0; i < 1024; i = i + 1)
    	        DataMemory[i] <= 0;
    	end
  //if destination address is less than memory size then no data to ouptut in memory (instruction doesn't use memory)
  // so it will pass it's output through the base address 
  // else output address is in memory 
  assign OutputData = (address < 1024) ? 32'd0 : {DataMemory[BaseAddress], DataMemory[BaseAddress + 1], DataMemory[BaseAddress + 2], DataMemory[BaseAddress + 3]};
  assign BaseAddress = ((address & 32'b11111111111111111111101111111111) >> 2) << 2;
endmodule

