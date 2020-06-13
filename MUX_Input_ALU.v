
//Nadeen
//Mux of ALU input 
module MUX_Input_ALU (MUXOutput,MUXInput1, MUXInput2, MUXInput3, MUXSelection);
    input [31:0] MUXInput1, MUXInput2, MUXInput3;
  input [1:0] MUXSelection;
  output [31:0] MUXOutput;
  assign out = (MUXSelection == 2'd0) ? MUXInput1 :
               (MUXSelection == 2'd1) ? MUXInput2 : MUXInput3;
endmodule 

