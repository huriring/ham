`timescale 1ns / 1ps



module test();
    
    reg clk;
    reg rst_n;
    reg tx;
    
initial begin
    clk = 0;
    rst_n = 1;
    
    #50 rst_n = 0;
    #50 rst_n = 1;
    end
 
    
always begin
      #5
      clk = ~clk;
   end
    
uart_tx uart_inst(
    .clk(clk),
    .rst_n(rst_n),
    .tx(tx)
    );
    
endmodule
