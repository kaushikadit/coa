`timescale 1ns / 1ps
module Reg_File(WE, RD, RS1, RS2, Din, Dout_1, Dout_2, clk);
input WE;
input clk;
input[4:0] RD, RS1, RS2;
input [31:0]Din;
output [31:0] Dout_1, Dout_2;

reg [31:0] RFile[31:0];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)begin
            RFile[i] = i;
        end
    end
    
    assign Dout_1 = RFile[RS1];
    assign Dout_2 = RFile[RS2];
    
    always@(posedge clk)
    begin
        if(WE == 1'b1)
            begin
                RFile[RD] = Din;
                RFile[0] = 0;
            end
    end
endmodule
