`timescale 1ns / 1ps
module MUX_2(A, B, OUT, SEL);
input signed [31:0]A;
input signed [31:0]B;
input SEL;
output signed [31:0]OUT;

assign OUT = SEL? B:A;

endmodule
