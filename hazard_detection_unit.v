// hazard detection
module hazard_detection_unit(Enable_forwarding, immediate, BNE_ST, src1, src2, dest_in_EXE, WB_in_EXE, dest_in_MEM, WB_in_MEM, MEMR_in_EXE, branch, hazard_detected);
  input [4:0] src1;//RegisterRs
  input [4:0] src2;//RegisterRt
  input [4:0] dest_in_EXE;
  input [4:0] dest_in_MEM;
  input [1:0] branch;
  input Enable_forwarding;
  input WB_in_EXE;
  input WB_in_MEM;
  input immediate;
  input BNE_ST;
  input MEMR_in_EXE;

  output hazard_detected;

  wire src2_right, EXE_hazard, MEM_hazard, the_hazard, instr_branch;

  assign src2_right=  (~immediate) || BNE_ST;

  assign EXE_hazard = WB_in_EXE && (src1 == dest_in_EXE || (src2_right&& src2 == dest_in_EXE));
  assign MEM_hazard = WB_in_MEM && (src1 == dest_in_MEM || (src2_right&& src2 == dest_in_MEM));

  assign the_hazard = (EXE_hazard || MEM_hazard);
  assign instr_branch = (branch == 2'b11|| branch == 2'b01);

//COND_BEZ 2'b11
// COND_BNE 2'b01

  assign hazard_detected = ~Enable_forwarding? the_hazard : (instr_branch && the_hazard) || (MEMR_in_EXE && MEM_hazard);
endmodule 

