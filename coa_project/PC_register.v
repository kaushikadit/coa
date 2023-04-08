`timescale 1ns / 1ps

module PC_register(PCIN, PCOUT, clk);
input [29:0] PCIN = -1;
output reg [29:0] PCOUT;
input clk;
reg [29:0] PC;

initial PC = 0;
initial PCOUT = 0;

always@(posedge clk)begin
    PCOUT<=PC+1;
    PC<=PCIN;
end

endmodule
