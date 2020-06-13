//Nadeen
//EXEC2MEM
module ExecuteToMemoryPipelineRegister (
		//Inputs
		clk,
		Reset,
		//write back signals
		//RegWrite
		EnableWriteBackInput, 
		//Mmeory signals
		//MemRead
		EnableReadFromMemoryInput,
		//MemWrite
		EnableWriteInMemoryInput, 
		//Program Counter input (saved through the whole process)
		PCInput, 
		//ALU result to be passed to memory or destination register 
		InputALUResult,
		//??
		STValIn,
		//??
		destIn,
		//Outputs
        EnableWriteBackInputOutput,    
        EnableReadFromMemoryOutput,    
        EnableWriteInMemoryOutput,    
        PCOutput,   
        OutputALUResult,   
        STVal,   
        dest);
  input clk, Reset;
  // TO BE REGISTERED FOR ID STAGE
  input EnableWriteBackInput, EnableReadFromMemoryInput, EnableWriteInMemoryInput;
  input [4:0] destIn;
  input [31:0] PCInput, InputALUResult, STValIn;
  // REGISTERED VALUES FOR ID STAGE
  output reg EnableWriteBackInputOutput, EnableReadFromMemoryOutput, EnableWriteInMemoryOutput;
  output reg [4:0] dest;
  output reg [31:0] PCOutput, OutputALUResult, STVal;

  always @ (posedge clk) begin
    if (Reset) begin
      EnableWriteBackInputOutput <= 0;
      EnableReadFromMemoryOutput <= 0;
      EnableWriteInMemoryOutput <= 0;
      PCOutput <= 32'd0;
      OutputALUResult <= 32'd0;
      STVal <= 32'd0;
      dest <= 32'd0;
    end
    else begin
      EnableWriteBackInputOutput <= EnableWriteBackInput;
      EnableReadFromMemoryOutput <= EnableReadFromMemoryInput;
      EnableWriteInMemoryOutput <= EnableWriteInMemoryInput;
      PCOutput <= PCInput;
      OutputALUResult <= InputALUResult;
      STVal <= STValIn;
      dest <= destIn;
    end
  end
endmodule 

