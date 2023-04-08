`timescale 1ns / 1ps
module R_triadic(clk, Oprnd1Sel, RDSEL, NextPC, Oprnd2Sel, WE, DinSel2, ExtnCntl, Y, PCout);
input clk;
input WE;
input Oprnd2Sel;
input Oprnd1Sel;
input DinSel2;
input ExtnCntl;
input RDSEL;
input NextPC;
output [31:0]Y;
wire [31:0] dout1, dout2;
wire [31:0] IR;
reg [4:0]RD; 
wire [5:0]ALUCTRL;
wire [29:0] PCin;
output [29:0] PCout;
reg [29:0] PCplusone;
wire [31:0]RS1;          
wire RS1is0;
reg [31:0] Dinn;
reg [31:0]ALU_A;
reg signed [31:0] ALU_B; 
wire signed [15:0] IMM;
wire signed [25:0] J_IMM;
reg signed [31:0] IMM_sel;
wire slowclk;
wire [29:0] PCassign;

OneHertz OHM(.slowClk(slowclk), .fastClk(clk));

assign IMM = IR[15:0];

assign J_IMM = IR[25:0];

Reg_File reg_32_32(.WE(WE), .RD(RD), .RS1(IR[25:21]), .RS2(IR[20:16]), .Dout_1(dout1), .Dout_2(dout2), .clk(slowclk), .Din(Dinn));

assign ALUCTRL = (IR[31]||IR[30]||IR[29]||IR[28]||IR[27]||IR[26] == 0)? IR[5:0]:IR[31:26];

PC_register PCREG(.PCIN(PCassign), .PCOUT(PCout), .clk(slowclk));
BRAM_MODULE BRAM(.clk(slowclk), .addr(PCout), .dout(IR));

assign RS1is0 = (dout1==0)? 1:0;

ALU Alu(.A(ALU_A),  .B(ALU_B), .ALU_ctrl(ALUCTRL), .Y(Y), .RS1is0(RS1is0) );

assign PCassign=NextPC?Y:PCout+1;

always@(posedge slowclk) begin
    IMM_sel = ExtnCntl? J_IMM:IMM;
    RD      = RDSEL? IR[15:11] : IR[20:16];
    Dinn    = DinSel2? Y: {PCout + 1,2'b00};
    ALU_A   = Oprnd1Sel? {PCout}:dout1;
    ALU_B   = Oprnd2Sel? IMM:dout2;
end

endmodule
