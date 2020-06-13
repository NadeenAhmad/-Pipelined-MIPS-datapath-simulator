//Execute Stage
module Execute (
clk,
//ALU OPERATION
ALUOperation,
//MUX1 selection for ALU input 1 (Normal input from register / EXEC to EXEC frowarding / MEM to EXEC forwarding) 
Register1DataSelection, 
//MUX2 selection for ALU input 2 (Normal input from register / EXEC to EXEC frowarding / MEM to EXEC forwarding)
Register2DataSelection,
StoreSelection, 
//Data Passed as Operand 1 to ALU
Register1Data,
//Data Passed as Operand 2 to ALU 
Register2Data, 
//EXEC to EXEC forwarding result taken from memory to use as ALU input 
ExecToExecData,
//MEM to EXEC forwarding result taken from memory to use as ALU input 
MemToExecData,
//
StoreInputData,
//Result from ALU module
ALUResult, 
StoreOutputData);
  input clk;
  input [1:0] Register1DataSelection, Register2DataSelection, StoreSelection;
  input [3:0] ALUOperation;
  input [31:0] Register1Data, Register2Data, ExecToExecData, MemToExecData, StoreInputData;
  output [31:0] ALUResult, StoreOutputData;
     //output result of MUX on a wire to transfer it to ALU so it does the requested operation
  wire [31:0] ALU_Register1Data, ALU_Register2Data;
    //initial begin
   //$display("Execute Stage");
 //#1000 $finish;
 //end

  MUX_Input_ALU Register1Value (
    .MUXInput1(Register1Data),
    .MUXInput2(ExecToExecData),
    .MUXInput3(MemToExecData),
    .MUXSelection(Register1DataSelection),
    .MUXOutput(ALU_Register1Data)
  );
  MUX_Input_ALU Register2Value (
    .MUXInput1(Register2Data),
    .MUXInput2(ExecToExecData),
    .MUXInput3(MemToExecData),
    .MUXSelection(Register2DataSelection),
    .MUXOutput(ALU_Register2Data)
  );
  MUX_Input_ALU StoreValue (
    .MUXInput1(StoreInputData),
    .MUXInput2(ExecToExecData),
    .MUXInput3(MemToExecData),
    .MUXSelection(StoreSelection),
    .MUXOutput(StoreOutputData)
  );
 ALU ALU(
    .regData1(ALU_Register1Data),
    .regData2(ALU_Register2Data),
    .Operation(ALUOperation),
    .result(ALUResult)

  );


endmodule

