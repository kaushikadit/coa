`timescale 1ns / 1ps

module COA_PROJECT(clk, WE, p, Oprnd1Sel, RDSEL, NextPC, Oprnd2Sel, DinSel2, ExtnCntl, Lreset, Anode_Activate, LED_out);
input Oprnd1Sel;
input RDSEL;
input NextPC;
input Oprnd2Sel;
input clk;
input WE;
input DinSel2;
input ExtnCntl;
input p;
input Lreset;
output [6:0] LED_out;
output [3:0]Anode_Activate;
wire [31:0] OUT;

R_triadic RT(.clk(clk), .Oprnd1Sel(Oprnd1Sel), .RDSEL(RDSEL), .NextPC(NextPC), .Oprnd2Sel(Oprnd2Sel), .WE(WE), .DinSel2(DinSel2), .ExtnCntl(ExtnCntl), .Y(Y), .PCout(PC));

ProperSevenSegment display(.clock_100Mhz(clk), .reset(Lreset), .p(p), .displayed_number(Y), .LED_out(LED_out), .Anode_Activate(Anode_Activate));

endmodule
































