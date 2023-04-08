`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 11:40:33 PM
// Design Name: 
// Module Name: seg_7
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ProperSevenSegment(input clock_100Mhz, input reset, input p, input [31:0]displayed_number, output reg [6:0]LED_out, output reg [3:0]Anode_Activate);

// creating the refresh signal and LED-activating signals:
// the first 18-bit for creating 2.6 ms digit period
// the other 2-bit for creating 4 LED-activating signals
//    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
//    input reset, // reset
//    input p,
//    output reg [3:0]Anode_Activate, // anode signals of the 7-segment LED display
//    input [31:0]displayed_number,
//    output reg [6:0]LED_out);// 
    
    wire [1:0] LED_activating_counter;  
    reg [19:0] refresh_counter=0; 
    reg [3:0]LED_BCD;
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
//    parameter displayed_number = 32'b00101001010100101010110100101011;

always @(posedge clock_100Mhz or posedge reset)
    begin
        if(reset==1)
            one_second_counter <= 0;
        else begin
            if(one_second_counter>=499_999_995) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    assign one_second_enable = (one_second_counter==499_999_995)?1:0;
    
always @(posedge clock_100Mhz or posedge reset)
begin 
 if(reset==1)
  refresh_counter <= 0;
 else
  refresh_counter <= refresh_counter + 1;
end 
assign LED_activating_counter = refresh_counter[19:18];

//assign LED_activating_counter = refresh_counter[1:0];

// creating the anode signals and updating values of the four 7-segment LEDs on Basys 3 FPGA:

// anode activating signals for 4 LEDs
// decoder to generate anode signals 
    always @(*)
    begin
        if(reset)begin
            case(LED_activating_counter)
            2'b00: begin
                Anode_Activate = 4'b0111; 
                // activate LED1 and Deactivate LED2, LED3, LED4
                LED_BCD = 4'b0000;
                // the first hex-digit of the 16-bit number
                 end
            2'b01: begin
                Anode_Activate = 4'b1011; 
                // activate LED2 and Deactivate LED1, LED3, LED4
                LED_BCD = 4'b0000;
                // the second hex-digit of the 16-bit number
                    end
            2'b10: begin
                Anode_Activate = 4'b1101; 
                // activate LED3 and Deactivate LED2, LED1, LED4
                LED_BCD = 4'b0000;
                 // the third hex-digit of the 16-bit number
                  end
            2'b11: begin
                Anode_Activate = 4'b1110; 
                // activate LED4 and Deactivate LED2, LED3, LED1
                 LED_BCD = 4'b0000;
                 // the fourth hex-digit of the 16-bit number 
                   end   
             default:begin
                 Anode_Activate = 4'b0111; 
                // activate LED1 and Deactivate LED2, LED3, LED4
                LED_BCD = 4'b0000;
                // the first hex-digit of the 16-bit number
                end
             endcase
        end
        if(reset == 0)begin
            if(p) begin //higher bits [31:16]
                case(LED_activating_counter)
                2'b00: begin
                    Anode_Activate = 4'b0111; 
                    // activate LED1 and Deactivate LED2, LED3, LED4
                    LED_BCD = displayed_number[31:28];
                    // the first hex-digit of the 16-bit number
                     end
                2'b01: begin
                    Anode_Activate = 4'b1011; 
                    // activate LED2 and Deactivate LED1, LED3, LED4
                    LED_BCD = displayed_number[27:24];
                    // the second hex-digit of the 16-bit number
                        end
                2'b10: begin
                    Anode_Activate = 4'b1101; 
                    // activate LED3 and Deactivate LED2, LED1, LED4
                    LED_BCD = displayed_number[23:20];
                     // the third hex-digit of the 16-bit number
                      end
                2'b11: begin
                    Anode_Activate = 4'b1110; 
                    // activate LED4 and Deactivate LED2, LED3, LED1
                     LED_BCD = displayed_number[19:16];
                     // the fourth hex-digit of the 16-bit number 
                       end   
                 default:begin
                     Anode_Activate = 4'b0111; 
                    // activate LED1 and Deactivate LED2, LED3, LED4
                    LED_BCD = 4'b0000;
                    // the first hex-digit of the 16-bit number
                    end
                 endcase
            end
            if(p == 0) begin
                case(LED_activating_counter)
                2'b00: begin
                    Anode_Activate = 4'b0111; 
                    // activate LED1 and Deactivate LED2, LED3, LED4
                    LED_BCD = displayed_number[15:12];
                    // the first hex-digit of the 16-bit number
                     end
                2'b01: begin
                    Anode_Activate = 4'b1011; 
                    // activate LED2 and Deactivate LED1, LED3, LED4
                    LED_BCD = displayed_number[11:8];
                    // the second hex-digit of the 16-bit number
                        end
                2'b10: begin
                    Anode_Activate = 4'b1101; 
                    // activate LED3 and Deactivate LED2, LED1, LED4
                    LED_BCD = displayed_number[7:4];
                     // the third hex-digit of the 16-bit number
                      end
                2'b11: begin
                    Anode_Activate = 4'b1110; 
                    // activate LED4 and Deactivate LED2, LED3, LED1
                     LED_BCD = displayed_number[3:0];
                     // the fourth hex-digit of the 16-bit number 
                       end   
                
               default:begin
                    Anode_Activate = 4'b0111; 
                    // activate LED1 and Deactivate LED2, LED3, LED4
                    LED_BCD = 4'b0000;
                    // the first hex-digit of the 16-bit number
                    end
                endcase
            end
      end
    end


//BCD to 7-segment decoder based on the decoder table above:

// Cathode patterns of the 7-segment LED display 
always @(*)
begin
 case(LED_BCD)
 4'b0000: LED_out = 7'b0000001; // "0"  
 4'b0001: LED_out = 7'b1001111; // "1" 
 4'b0010: LED_out = 7'b0010010; // "2" 
 4'b0011: LED_out = 7'b0000110; // "3" 
 4'b0100: LED_out = 7'b1001100; // "4" 
 4'b0101: LED_out = 7'b0100100; // "5" 
 4'b0110: LED_out = 7'b0100000; // "6" 
 4'b0111: LED_out = 7'b0001111; // "7" 
 4'b1000: LED_out = 7'b0000000; // "8"  
 4'b1001: LED_out = 7'b0000100; // "9"
 4'b1010: LED_out = 7'b1100010; // "a"
 4'b1011: LED_out = 7'b1100000; // "b"
 4'b1100: LED_out = 7'b1110010; // "c"
 4'b1101: LED_out = 7'b1000010; // "d"
 4'b1110: LED_out = 7'b0010000; // "e" 
 4'b1111: LED_out = 7'b0111000; // "f"

 default: LED_out = 7'b0000001; // "0"
 endcase
end
    
endmodule