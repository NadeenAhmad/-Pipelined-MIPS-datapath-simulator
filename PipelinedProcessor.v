//Processor Module
module PipelinedProcessor (input CLOCK_50, input rst, input ForwardingEnable);
	wire clock = CLOCK_50;
	wire [31:0] PCFetch, PCDecode, PCExecute, PCMemory;
	wire [31:0] FetchedInstruction, DecodedInstruction;
	wire [31:0] Register1Decode, Register2Decode, StoreValueExecute, StoreValueExecute2MEM, StoreValueMemory;
	wire [31:0] val1_Decode, val1_Execute;
	wire [31:0] val2_Decode, val2_Execute;
	wire [31:0] ALURes_EXE, ALURes_MEM, ALURes_WB;
	wire [31:0] dataMem_out_MEM, dataMem_out_WB;
	wire [31:0] WB_result;
	wire [4:0] dest_EXE, dest_MEM, dest_WB;
 // dest_ID = instruction[25:21] thus nothing declared
	wire [4:0] src1_ID, src2_regFile_ID, src2_forw_ID, src2_forw_EXE, src1_forw_EXE;
	wire [3:0] opcodeDecode, opcodeExecute;
	wire [1:0] val1_sel, val2_sel, ST_val_sel;
	wire [1:0] branch_comm;
	wire Br_Taken_ID, IF_Flush, Br_Taken_EXE;
	wire MEM_R_EN_ID, MEM_R_EN_EXE, MEM_R_EN_MEM, MEM_R_EN_WB;
	wire MEM_W_EN_ID, MEM_W_EN_EXE, MEM_W_EN_MEM;
	wire WB_EN_ID, WB_EN_EXE, WB_EN_MEM, WB_EN_WB;
	wire hazard_detected, is_imm, ST_or_BNE;






	regFile regFile(
		// INPUTS
		.clk(clock),
		.rst(rst),
		.read_reg1(src1_ID),
		.read_reg2(src2_regFile_ID),
		.write_reg(dest_WB),
		.write_data(WB_result),
		.reg_write(WB_EN_WB),
		// OUTPUTS
		.read_data1(Register1Decode),
		.read_data2(Register2Decode)
	);


	hazard_detection_unit hazard (
		// INPUTS
		.Enable_forwarding(ForwardingEnable),
		.immediate(is_imm),
		.BNE_ST(ST_or_BNE),
		.src1(src1_ID),
		.src2(src2_regFile_ID),
		.dest_in_EXE(dest_EXE),
		.dest_in_MEM(dest_MEM),
		.WB_in_EXE(WB_EN_EXE),
		.WB_in_MEM(WB_EN_MEM),
		.MEMR_in_EXE(MEM_R_EN_EXE),
		// OUTPUTS
		.branch(branch_comm),
		.hazard_detected(hazard_detected)
	);

	forwarding_EXE forwrding_EXE (
		.Register1Address(src1_forw_EXE),
		.Register2Address(src2_forw_EXE),
		.ST_src_EXE(dest_EXE),
		.DestinationMemory(dest_MEM),
		.DestinationWriteBack(dest_WB),
		.WriteBackEnableMemory(WB_EN_MEM),
		.WriteBackEnableRegister(WB_EN_WB),
		.mux1Selection(val1_sel),
		.mux2Selection(val2_sel),
		.ST_val_sel(ST_val_sel)
	);
		IFStage IFStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.PCWrite(hazard_detected),
		.BranchTaken(Br_Taken_ID),
		.BranchOffset(val2_Decode),
		// OUTPUTS
		.instruction(FetchedInstruction),
		.PC(PCFetch)
	);
 // initial begin
 // $display("fetch");
 //#1000 $finish;
 // end

IDStage IDStage (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.hazardDetectionInput(hazard_detected),
		.instruction(DecodedInstruction),
		.Register1Data(Register1Decode),
		.Register2Data(Register2Decode),
		// OUTPUTS
		
 
		.Regitser1Address(src1_ID),
		.Register2Address(src2_regFile_ID),
		.Register2AddForwarding(src2_forw_ID),
		.val1(val1_Decode),
		.val2(val2_Decode),
		.BranchTaken(Br_Taken_ID),
		.OPcode(opcodeDecode),
	.MemoryReadEnable(MEM_R_EN_ID),
	.MemoryWriteEnable(MEM_W_EN_ID),
		.WriteBackEnable(WB_EN_ID),
		.ImmediateOutputSignal(is_imm),
		.ST_or_BNE_out(ST_or_BNE),
		.Branch(branch_comm)
	);


	Execute EXEStage (
		// INPUTS
		.clk(clock),
		.ALUOperation(opcodeExecute),
		.Register1DataSelection(val1_sel),
		.Register2DataSelection(val2_sel),
		.StoreSelection(ST_val_sel),
		.Register1Data(val1_Execute),
		.Register2Data(val2_Execute),
		.ExecToExecData(ALURes_MEM),
		.MemToExecData(WB_result),
		.StoreInputData(StoreValueExecute),
		// OUTPUTS
		.ALUResult(ALURes_EXE),
		.StoreOutputData(StoreValueExecute2MEM)
	);
//initial begin
  //$display("execute");
 //#1000 $finish;
  //end

	MemoryStage MEMStage (
		// INPUTS
		.clk(clock),
		.Reset(rst),
		.EnableReadFromMemory(MEM_R_EN_MEM),
		.EnableWriteInMemory(MEM_W_EN_MEM),
		//alu result
		.ALUResult(ALURes_MEM),
		//store value
		.StoreValue(StoreValueMemory),
		// OUTPUTS
	
		.OutputDataFromDataMemory(dataMem_out_MEM)
	
	);
	
//	initial begin
  //$display("memory");
 //#1000 $finish;
  //end

	WriteBackStage WBStage (
		// INPUTS
		.EnableMemoryRead(MEM_R_EN_WB),
		.DataMemoryOutput(dataMem_out_WB),
		.ALUResult(ALURes_WB),
		// OUTPUTS
		.WriteBackResult(WB_result)
	);
//initial begin
  //$display("write back");
 //#1000 $finish;
  //end


		IF2ID IF2IDReg (
		// INPUTS
		.clk(clock),
		.rst(rst),
		.flush(IF_Flush),
		.freeze(hazard_detected),
		.PCIn(PCFetch),
		.instructionIn(FetchedInstruction),
		// OUTPUTS
		.PC(PCDecode),
		.instruction(DecodedInstruction)
	);

	ID2EXE ID2EXEReg (
		.clk(clock),
		.rst(rst),
		// INPUTS
		.destIn(DecodedInstruction[25:21]),
		.src1_in(src1_ID),
		.src2_in(src2_forw_ID),
		.reg2In(Register2Decode),
		.val1In(val1_Decode),
		.val2In(val2_Decode),
		.PCIn(PCDecode),
		.EXE_CMD_IN(opcodeDecode),
		.MEM_R_EN_IN(MEM_R_EN_ID),
		.MEM_W_EN_IN(MEM_W_EN_ID),
		.WB_EN_IN(WB_EN_ID),
		.brTaken_in(Br_Taken_ID),
		// OUTPUTS
		.src1_out(src1_forw_EXE),
		.src2_out(src2_forw_EXE),
		.dest(dest_EXE),
		.ST_value(StoreValueExecute),
		.val1(val1_Execute),
		.val2(val2_Execute),
		.PC(PCExecute),
		.EXE_CMD(opcodeExecute),
		.MEM_R_EN(MEM_R_EN_EXE),
		.MEM_W_EN(MEM_W_EN_EXE),
		.WB_EN(WB_EN_EXE),
		.brTaken_out(Br_Taken_EXE)
	);

	ExecuteToMemoryPipelineRegister EXE2MEMReg (
		.clk(clock),
		.Reset(rst),
		// INPUTS
		.EnableWriteBackInput(WB_EN_EXE),
		.EnableReadFromMemoryInput(MEM_R_EN_EXE),
		.EnableWriteInMemoryInput(MEM_W_EN_EXE),
		.PCInput(PCExecute),
		.InputALUResult(ALURes_EXE),
		.STValIn(StoreValueExecute2MEM),
		.destIn(dest_EXE),
		// OUTPUTS
		//negry waraha
		.EnableWriteBackInputOutput(WB_EN_MEM),
		
		.EnableReadFromMemoryOutput(MEM_R_EN_MEM),
		.EnableWriteInMemoryOutput(MEM_W_EN_MEM),
		.PCOutput(PCMemory),
		.OutputALUResult(ALURes_MEM),
		.STVal(StoreValueMemory),
		.dest(dest_MEM)
	);

	
	MemoryToWriteBackPipelineRegister MEM2WB(
		.clk(clock),
		.Reset(rst),
		// INPUTS
		.WriteBackEnableInput(WB_EN_MEM),
		.MemoryReadEnableInput(MEM_R_EN_MEM),
		.ALUResultInput(ALURes_MEM),
		.DataFromDataMemory(dataMem_out_MEM),
		.DestinationRegisterOutputinationRegisterInput(dest_MEM),
		// OUTPUTS
		.WriteBackEnableOutput(WB_EN_WB),
		.MemoryReadEnableOutput(MEM_R_EN_WB),
		.ALUResultOutput(ALURes_WB),
		.MemoryReadData(dataMem_out_WB),
		.DestinationRegisterOutput(dest_WB)
	);
//clock %g\t ,
//, CLOCK_50 
initial begin
 $monitor("Clock:%g\t" ,CLOCK_50,"At time ",$time,"Fetch %h , Decode instruction %h , Decode opCode %h , Execute opCode %h  ", FetchedInstruction ,DecodedInstruction , opcodeDecode ,opcodeExecute);
end


	assign IF_Flush = Br_Taken_ID;
endmodule
