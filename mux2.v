//2 inputs
//each is five bits
module mux2(in1, in2, sel, out);
  input sel;
  input [4:0] in1;
  input [4:0]  in2;
  output [4:0] out;

  assign out = (sel == 0) ? in1 : in2;
endmodule 


