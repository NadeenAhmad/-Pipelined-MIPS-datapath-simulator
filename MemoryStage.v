//Memory Stage
module MemoryStage (clk, Reset, EnableReadFromMemory, EnableWriteInMemory, ALUResult, StoreValue, OutputDataFromDataMemory);
  input clk, Reset, EnableReadFromMemory, EnableWriteInMemory;
  input [31:0] ALUResult, StoreValue;
  output [31:0]  OutputDataFromDataMemory;
  DataMemory DataMemory (
    .clk(clk),
    .Reset(Reset),
    .EnableWriteInMemory(EnableWriteInMemory),
    .EnableReadFromMemory(EnableReadFromMemory),
    .address(ALUResult),
    .InputData(StoreValue),
    .OutputData(OutputDataFromDataMemory)
  );
 // initial begin
 // $display("Memory Stage");
//#10000 $finish;
//end
endmodule 

