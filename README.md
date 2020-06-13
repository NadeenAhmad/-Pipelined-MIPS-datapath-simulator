#  Pipelined MIPS datapath simulator
* The goal of this project is to implement a low-level cycle-accurate pipelined MIPS datapath simulator. Simulating the datapath includes simulating all of its storage components (register file, memories, and pipeline registers) and all of its control signals. This document details the supported instructions, the inputs to the simulator, and the expected outputs.
* The project is implemented in **Verilog**
* The software used to test it is **ModelSim Altera**
* Instruction set architecture (ISA): The MIPS instructions supported are:     
           *  Arithmetic: add, sub, addi  
           * Load/Store: lw, sw, lh, lhu  
           * Logic: and, or, sll, srl, and, or  
           * Control flow: beq  
           * Comparison: slt, sltu  
* The pipeline consists of the same five stages discussed in lectures (ID, IF, EXE,MEM and WB).
* This datapath does not detect or handle hazards at all, which means that the
input program has to be hazard-free to produce correct results.
* The register file consists of the 32 registers including the $zero register. Register 0 always contains the value 0.
* The simulator shows the content (decimal and/or hexadecimal) of all the fields of the pipeline registers (PC, IF/ID, ID/EX, EX/MEM, and MEM/WB) including control signals at each clock cycle.

* **Testing:**
* Assembly program: The test bench loads a program (and data if any) into the memory (using the supported instructions only). 
* Tracking Cycles: It shows the user the outputs of each cycle
continuously.  
Example:  
Cycle 1: Instruction 1 fetched.  
Cycle 2: Instruction 1 decoded, Instruction 2 fetched.  
Cycle 3: Instruction 1 executed, Instruction 2 decoded, Instruction 3 fetched.  
* Outputs: At the end of the program, it prints out to the user the content of both the register file as well as the memory  
