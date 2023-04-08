`timescale 1ns / 1ps

module ALU(A, B, ALU_ctrl, Y, RS1is0);
input [31:0]A, B;
input [5:0]ALU_ctrl;
output reg [31:0]Y;
reg signed [31:0] AA, BB;
input RS1is0;


always@* begin
    AA = A; BB = B;
    case(ALU_ctrl)
        
        //R and RI type triadic instructions down:
        1:  Y = A + B;              //ADD
        2:  Y = A - B;              //SUB
        3:  Y = A & B;              //AND
        4:  Y = A | B;              //OR
        5:  Y = A ^ B;              //XOR
        6:  Y = {A[30:0],1'b0};     //SLL(shift left logical)
        7:  Y = {1'b0, A[31:1]};    //SRL(shift right logical)
        8:  Y = {A[31], A[31:1]};   //SRA(shift right arithmetic)
        9:  Y = {A[30:0],A[31]};    //ROL(rotate left)
        10: Y = {A[0], A[31:1]};   //ROR(rotate right)
        11: Y = (A[31])? ( (B[31])? (A>B): 1) : ( (B[31])? 0: (A>B) );          //SLT(signed less than)
        12: Y = (AA>BB)? 1:0;                                                   //SLT(signed greater than)
        13: Y = (AA<=BB)? 1:0;                                                  //SLE(signed less than or equal to)
        14: Y = ~( (A[31])? ( (B[31])? (A>B): 1) : ( (B[31])? 0: (A>B) ) );     //SGE(signed greater than or equal to)
        15: Y = (A>B)? 1:0;        //UGT
        16: Y = (A<B)? 1:0;        //ULT
        17: Y = (A>=B)? 1:0;       //ULE
        18: Y = (A<=B)? 1:0;       //UGE 
        
        // R TYPE DYADIC (Branch functions):
        19: Y = (RS1is0)? A + B: A ;   //BNEZ
        20: Y = (!RS1is0)? A + B: A;   //BEQZ
        
        //J TYPE (JUMP AND LINK):
        21: Y = A + B;   //JR   ????????????????
        22: Y = A + B;   //JALR
        
        
        23: Y = 0;   //LHI
        
        default: Y = 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        
    endcase

end
endmodule