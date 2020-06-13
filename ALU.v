//----------------------------Nadeen----------------------------------
//ALU
module ALU 
(result, regData1, regData2 ,Operation);
  output reg [31:0] result;
  //ALU operands comming from read registers are 32 bits long
  input [31:0] regData1, regData2;
  //Operation
  input [3:0] Operation;
  always @ ( * ) begin
    case (Operation)
      //ADD
      0000: result <= regData1 + regData2;
      //SetLessThan
      //0001: if (regData1 < regData2) result = 32'd1; 
      //else result = 32'd0;
      //SUB
      0010: result <= regData1+	(~(regData2)+1);
      //AND
      0100: result <= regData1 & regData2;
      //OR
      0101: result <= regData1 | regData2;
      //NOR
      0110: result <= ~(regData1 | regData2);
      //XOR
      0111: result <= regData1 ^ regData2;
      //Shift left Arithmetic 
      1000: result <= regData1 << regData2;
      //Shift left logical
      1000: result <= regData1 <<< regData2;
      //Shift right Arithmetic
      1001: result <= regData1 >> regData2;
      //Shift right logical
      1010: result <= regData1 >>> regData2;
       default: result <= 32'd0;
    endcase
  end
endmodule 

