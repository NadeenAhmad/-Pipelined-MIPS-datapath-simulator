//-----------------stage!!!!!
module register (clk, rst, writeEn, in, out);
  input clk, rst, writeEn;
  input [31:0] in;
  output reg [31:0] out;

  always @ (posedge clk) begin
    if (rst == 1) out <= 0;
    else if (writeEn) out <= in;
  end
endmodule 

