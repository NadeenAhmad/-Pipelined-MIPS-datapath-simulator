module forwarding_EXE (
//sources of current instruction
Register1Address,
Register2Address,
ST_src_EXE,
//destination of previous instruction
DestinationMemory, 
DestinationWriteBack,
//load instruction check
WriteBackEnableMemory,
//write back in same register check
WriteBackEnableRegister,
//selection to mux determining first input to ALU
mux1Selection,
//selection to mux determining second input to ALU
mux2Selection,
ST_val_sel);

  input [4:0] Register1Address, Register2Address, ST_src_EXE;
  input [4:0] DestinationMemory, DestinationWriteBack;
  input WriteBackEnableMemory, WriteBackEnableRegister;
  output reg [1:0] mux1Selection,mux2Selection, ST_val_sel;

  always @ ( * ) begin
    // initializing sel signals to 0
    // they will change to enable forwrding if needed.
    {mux1Selection,mux2Selection, ST_val_sel} <= 6'd0;

    // determining forwarding control signal for store value (ST_val)
    if (WriteBackEnableMemory && ST_src_EXE == DestinationMemory) ST_val_sel <= 2'd1;
    else if (WriteBackEnableRegister && ST_src_EXE == DestinationWriteBack) ST_val_sel <= 2'd2;

    // determining forwarding control signal for ALU val1
    //Memory to Execute Forwarding 
 // if (load instruction and source1 of current instruction is equal to Destination previous
  // instruction) 
    if (WriteBackEnableMemory && Register1Address == DestinationMemory) mux1Selection <= 2'd1;
    //Execute to Execute Forwarding
  //else  if (write back in a destination register instruction and source1 of current instruction is //equal to Destination previous instruction) 

    else if (WriteBackEnableRegister && Register1Address == DestinationWriteBack) mux1Selection <= 2'd2;

    // determining forwarding control signal for ALU val2
    //Memory to Execute Forwarding 
    if (WriteBackEnableMemory && Register2Address== DestinationMemory) mux2Selection<= 2'd1;
    //Execute to Execute Forwarding
    else if (WriteBackEnableRegister && Register2Address == DestinationWriteBack) mux2Selection<= 2'd2;
  end
endmodule 
module mux2to1(in1, in2, sel, out);
  input sel;
  input [31:0] in1;
  input [31:0]  in2;
  output [31:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule 