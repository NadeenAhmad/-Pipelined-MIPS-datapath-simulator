
//controller

module controller (opcode, branch, ALU_OP, condition_checker_input, ALU_Src, MEM_to_Reg, RegWrite, MEM_Read, MEM_Write, hazard);
  input hazard;
  input [5:0] opcode;
  output reg branch;
  output reg [3:0] ALU_OP;
  output reg [1:0] condition_checker_input; 
  output reg ALU_Src;
  output reg MEM_to_Reg;
  output reg RegWrite;
  output reg MEM_Read;
  output reg MEM_Write;

  always @ ( * ) begin
    if (hazard == 0) begin
      {branch, ALU_OP, condition_checker_input, ALU_Src, MEM_to_Reg, RegWrite, MEM_Read, MEM_Write} <= 12'd0;
      case (opcode)
        // R-type instructions
        6'b000001: begin ALU_OP <= 4'b0000; RegWrite <= 1; end //ADD
        6'b000011: begin ALU_OP <= 4'b0010; RegWrite <= 1; end //SUB
        6'b000101: begin ALU_OP <= 4'b0100; RegWrite <= 1; end //AND
        6'b000110: begin ALU_OP <= 4'b0101; RegWrite <= 1; end //OR
        6'b000111: begin ALU_OP <= 4'b0110; RegWrite <= 1; end //NOR
        6'b001000: begin ALU_OP <= 4'b0111; RegWrite <= 1; end //XOR
        6'b001001: begin ALU_OP <= 4'b1000; RegWrite <= 1; end //SLA
        6'b001010: begin ALU_OP <= 4'b1000; RegWrite <= 1; end //SLL
        6'b001011: begin ALU_OP <= 4'b1001; RegWrite <= 1; end //SRA
        6'b001100: begin ALU_OP <= 4'b1010; RegWrite <= 1; end //SRL
        // I-type instructions
        6'b100000: begin ALU_OP <= 4'b0000; RegWrite <= 1; ALU_Src <= 1; end //ADDI
        6'b100001: begin ALU_OP <= 4'b0010; RegWrite <= 1; ALU_Src <= 1; end //SUBI
        // memory instructions
        6'b100100: begin ALU_OP <= 4'b0000; RegWrite <= 1; ALU_Src <= 1; MEM_to_Reg <= 1; MEM_Read <= 1; end //LOAD  //4'b0000 FOR ALU ADD
        6'b100101: begin ALU_OP <= 4'b0000; ALU_Src <= 1; MEM_Write <= 1; MEM_to_Reg <= 1; end //STORE
        // branch instructions
        6'b101000: begin ALU_OP <= 4'b1111; ALU_Src <= 1; condition_checker_input <= 2'b11; branch <= 1; end //BEZ  //4'b1111 FOR NOP
        6'b101001: begin ALU_OP <= 4'b1111; ALU_Src <= 1; condition_checker_input <= 2'b01; branch <= 1; MEM_to_Reg <= 1; end //BNE
        6'b101010: begin ALU_OP <= 4'b1111; ALU_Src <= 1; condition_checker_input <= 2'b10; branch <= 1; end //JMP
        default: {branch, ALU_OP, condition_checker_input, ALU_Src, MEM_to_Reg, RegWrite, MEM_Read, MEM_Write} <= 11'd0;
      endcase
    end

    else if (hazard ==  1) begin
      ALU_OP <= 4'd0;
      MEM_to_Reg <= 0;
      MEM_Write <= 0;
    end
  end
endmodule  

