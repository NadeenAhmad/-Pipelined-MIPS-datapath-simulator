
//registerFile
module regFile(clk, rst, read_reg1, read_reg2, write_reg, write_data, reg_write, read_data1, read_data2);
  input clk;
  input rst;
  input reg_write;
  input [4:0] read_reg1;
  input [4:0] read_reg2;
  input [4:0] write_reg;
  input [31:0] write_data;
  
  output [31:0] read_data1;
  output [31:0] read_data2;

  reg [31:0] regMem [0:31];
  integer i;

  always @ (negedge clk) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1)
        regMem[i] <= 32'd0;
	    end

    else if (reg_write) regMem[write_reg] <= write_data;
    regMem[0] <= 31'd0;
  end

  assign read_data1 = (regMem[read_reg1]);
  assign read_data2 = (regMem[read_reg2]);
endmodule 

