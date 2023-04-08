`timescale 1ns / 1ps

module SDLX_MAIN(IR, RDSel,Oprnd1Sel, RD, ALU_OUT);

input [31:0] IR;
input RDSel,Oprnd1Sel;    //All the seects are given as input(as of now)
output RD;  
output [31:0] ALU_OUT;  //alu out needs to be an output port (does it??)
wire [31:0] ALU_A, ALU_B;  //We need to give this input to the ALU inside this module itself, need not define this as output
wire [29:0]PC;  //internal PC wire to specify the memory address 
wire RDSel, Oprnd1Sel, OPrnd2Sel, DinSel, NextPC; //all the select signals that need to be specified determined on the type of instruction

assign PC = 32'b0;  //initial assignment of PC to zero;

MUX_2 RD_Sel(.A(IR[20:16]), .B(IR[15:11]), .OUT(RD), .SEL(RDSel));
MUX_2 Oprnd1_Sel(.A({2'b00, PC}), .B(D1out), .OUT(ALU_A), .SEL(Oprnd1Sel));
MUX_2 Oprnd2_Sel(.A(D2out), .B({IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15],IR[15:0]}), .OUT(ALU_B), .SEL(Oprnd2Sel));
MUX_2 Din_Sel(.A(ALU_OUT), .B(memory_ka_data), .OUT(Din), .SEL(DinSel)); 
MUX_2 Next_PC(.A(ALU_OUT), .B(PC+1), .OUT(PC), .SEL(NextPC)); 



endmodule
