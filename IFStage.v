module IFStage (clk, rst, BranchTaken, BranchOffset , PCWrite, PC, instruction);
//PCWrite input if detected means there is a hazard so pause (stall /freeze )
//so a delay of one clock cycle will occur , the next clock cycle the old value of Program coounter will be passed 
//again to be executed

//BranchTaken : adder's input mux selection to determine either normal case (add 4) or add branch offset 
  input clk, rst, BranchTaken, PCWrite;
  input [31:0] BranchOffset;
  output [31:0] PC, instruction;

//OldValuePC :wire to pass program counter value to adder to be incremented by 4 to get new value
//NewValuePC : wire to carry output of adder 
//BranchOffsetMult4: will carry value to be added to old value of PC either 4 (normal case ) or branch offset 
//BranchOffsetMult4: second input to addder 
  wire [31:0] OldValuePC, NewValuePC, BranchOffsetMult4;

  mux adderInput (
    .in1(32'd4),
    .in2(BranchOffsetMult4),
    .sel(BranchTaken),
    .out(OldValuePC)
  );

  adder add4 (
    .in1(OldValuePC),
    .in2(PC),
    .out(NewValuePC)
  );

  register PCReg (
    .clk(clk),
    .rst(rst),
    .writeEn(~PCWrite),
    .in(NewValuePC),
    .out(PC)
  );

  instructionMem instructions (
    .rst(rst),
    .addr(PC),
    .instruction(instruction)
  );

  assign BranchOffsetMult4 = BranchOffset << 2;
endmodule // IFStage