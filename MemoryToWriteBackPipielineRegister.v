        module MemoryToWriteBackPipelineRegister (
		//inputs
		clk, 
		Reset, 
		//Write Back enable
		WriteBackEnableInput,
		//Data going to DestinationRegisterOutputinationRegisterInputation register came from memory not directly from ALU ex(Load)
		MemoryReadEnableInput,
		//Passing  ALU Result incase result is written into DestinationRegisterOutputinationRegisterInputation register directly from ALU
		ALUResultInput, 
		//Data coming from data memory
		DataFromDataMemory, 
		//DestinationRegisterOutputinationRegisterInputation register if there is a write back
		//egry warahaaaa
		DestinationRegisterOutputinationRegisterInput,
       // Outputs
		WriteBackEnableOutput,    
        
		MemoryReadEnableOutput,    
        
		ALUResultOutput,   
        
		MemoryReadData, 
		
        DestinationRegisterOutput);

  input clk, Reset;
  input WriteBackEnableInput, MemoryReadEnableInput;
  input [4:0] DestinationRegisterOutputinationRegisterInput;
  input [31:0] ALUResultInput, DataFromDataMemory;

  output reg WriteBackEnableOutput, MemoryReadEnableOutput;
  output reg [4:0] DestinationRegisterOutput;
  output reg [31:0] ALUResultOutput, MemoryReadData;

  always @ (posedge clk) begin
    if (!Reset) begin
    
      WriteBackEnableOutput <= WriteBackEnableInput;
      MemoryReadEnableOutput <= MemoryReadEnableInput;
      DestinationRegisterOutput <= DestinationRegisterOutputinationRegisterInput;
      ALUResultOutput <= ALUResultInput;
      MemoryReadData <= DataFromDataMemory;
    
    end
    else begin
    
      WriteBackEnableOutput <= 0;
      MemoryReadEnableOutput <= 0;
      DestinationRegisterOutput <= 4'd0;
      ALUResultOutput <= 32'd0;
      MemoryReadData <= 32'd0;
    end
  end
endmodule 

