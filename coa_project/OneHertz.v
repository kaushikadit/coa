`timescale 1ns / 1ps

module OneHertz(slowClk,fastClk);
input fastClk;
output reg slowClk = 0;
reg [29:0] cntr=0;

always@(posedge fastClk) begin
    cntr = cntr + 1;
    if(cntr == 250000000) begin
        cntr <= 0;
        slowClk <= ~slowClk;
    end
end

endmodule 
