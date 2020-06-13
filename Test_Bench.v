

module Test_Bench ();
  reg clk,rst, forwardingEnable;

  initial begin
    clk=1;
    repeat(1000) #50 clk=~clk ;
  end
    PipelinedProcessor mainModule (clk, rst, forwardingEnable);


  initial begin
    rst <= 1;
    forwardingEnable <= 0;
    #100
    rst <= 0;

  end
  
   
endmodule 


