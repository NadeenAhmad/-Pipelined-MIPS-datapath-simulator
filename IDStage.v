
module IDStage (
clk, 
rst, 

hazardDetectionInput,
 ImmediateOutputSignal,
 ST_or_BNE_out,
 instruction,
 Register1Data,
 Register2Data,
 Regitser1Address,
 Register2Address,
 Register2AddForwarding,
 val1,
 val2,
 BranchTaken, 
OPcode,
 MemoryReadEnable,
 MemoryWriteEnable,
 WriteBackEnable,
 Branch);
  input clk, rst, hazardDetectionInput;
  input [31:0] instruction, Register1Data,Register2Data;
  output BranchTaken, MemoryReadEnable, MemoryWriteEnable, WriteBackEnable, ImmediateOutputSignal, ST_or_BNE_out;
  output [1:0] Branch;
  output [3:0] OPcode;
  output [4:0] Regitser1Address, Register2Address
  ,Register2AddForwarding;
  output [31:0] val1, val2;

  wire CU2and, Cond2and;
  wire [1:0] CU2Cond;
  wire Is_Imm, ST_or_BNE;
  wire [31:0] signExt2Mux;




  controller controller(
    // INPUT
    .opcode(instruction[31:26]),
    .branch(CU2and),
    // OUTPUT
    .ALU_OP(OPcode),
    .condition_checker_input(CU2Cond),
    .ALU_Src(Is_Imm), // alu source 
    .MEM_to_Reg(ST_or_BNE), // branch stall 
    .RegWrite(WriteBackEnable), // writeback enable
    .MEM_Read(MemoryReadEnable), // memory read
    .MEM_Write(MemoryWriteEnable), // memory write
    .hazard(hazardDetectionInput)
  );

  

  mux2 mux_src2 ( 
// determins the register source 2 for register file
// write register mux (new register or second register)

    .in1(instruction[15:11]),
// using first register mot the second?
    .in2(instruction[25:21]),
    .sel(ST_or_BNE),
    .out(Register2Address)
  );

  mux mux_val2 (
    .in1(Register2Data),
    .in2(signExt2Mux),
    .sel(Is_Imm),
    .out(val2)
  );

  mux2  mux_src2_forw (
 // determins the register source 2 for forwarding
    .in1(instruction[15:11]), 
    .in2(5'd0),
    .sel(Is_Imm),
    .out(Register2AddForwarding)
  );

  signExtend signExtend(
    .in(instruction[15:0]),
    .out(signExt2Mux)
  );

  conditionChecker conditionChecker (
    .reg1(Register1Data),
    .reg2(Register2Data),
    .cuBranchComm(CU2Cond),
    .brCond(Cond2and)
  );

  assign BranchTaken = CU2and && Cond2and;
  assign val1 = Register1Data;
  assign Regitser1Address = instruction[20:16];
  assign ImmediateOutputSignal = Is_Imm;
  assign ST_or_BNE_out = ST_or_BNE;
  assign Branch = CU2Cond;

   // initial begin
  //$display("Decode Stage");
//#1000 $finish;
//end


endmodule // IDStage