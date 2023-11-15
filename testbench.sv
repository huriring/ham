`timescale 1ns / 1ps
/*-----------------------decoder testbench-------------------
module testbench();
reg [3:0] gray;
wire [3:0] binary;
gray_decoder gray_init(
    .a(binary),
    .b(gray)
 );

initial begin
gray=4'h1;
#5
gray=4'h2;
#5
gray=4'h3;
#5
gray=4'h4;
#5
gray=4'h5;
#5
gray=4'h6;
#5
gray=4'h7;
#5
gray=4'h8;
#5
gray=4'h9;
#5
gray=4'ha;
#5
gray=4'hb;
#5
gray=4'hc;
#5
gray=4'hd;
#5
gray=4'he;
#5
gray=4'hf;
#5
gray=4'h0;
end

endmodule
-----------------decoder testbench-------------*/
/*-----------------encoder testbench------------
module testbench();
reg [3:0] binary;
wire [3:0] gray;
gray_encoder gray_init(
    .a(binary),
    .b(gray)
 );

initial begin
binary=4'h1;
#5
binary=4'h2;
#5
binary=4'h3;
#5
binary=4'h4;
#5
binary=4'h5;
#5
binary=4'h6;
#5
binary=4'h7;
#5
binary=4'h8;
#5
binary=4'h9;
#5
binary=4'ha;
#5
binary=4'hb;
#5
binary=4'hc;
#5
binary=4'hd;
#5
binary=4'he;
#5
binary=4'hf;
#5
binary=4'h0;
end

endmodule
*/