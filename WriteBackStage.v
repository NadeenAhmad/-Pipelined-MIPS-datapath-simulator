        //nadeen
//WriteBack Stage
module WriteBackStage (WriteBackResult,EnableMemoryRead, DataMemoryOutput, ALUResult);
  input EnableMemoryRead;
  input [31:0]  DataMemoryOutput, ALUResult;
  output [31:0] WriteBackResult;
//if the result is processed in memory then assign the write back result to what's in memory
//else the result will be taken from ALU directly
assign WriteBackResult = (EnableMemoryRead )? DataMemoryOutput :ALUResult;
//initial begin
//$display("WriteBack Stage");
//#1000 $finish;
//end
endmodule
