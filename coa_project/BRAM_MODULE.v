`timescale 1ns / 1ps

//module BRAM_MODULE( AddressBusIN, AddressBusOUT, InpData, clk, WE, ReadEn);
    
//  //  Xilinx Simple Dual Port Single Clock RAM
//  //  This code implements a parameterizable SDP single clock memory.
//  //  If a reset or enable is not necessary, it may be tied off or removed from the code.

//  parameter RAM_WIDTH = 32;                  // Specify RAM data width
//  parameter RAM_DEPTH = 512;                  // Specify RAM depth (number of entries)
//  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"; // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
//  parameter INIT_FILE = "";                       // Specify name/location of RAM initialization file if using one (leave blank if not)

//  input [8:0] AddressBusIN; // Write address bus, width determined from RAM_DEPTH
//  output reg [8:0] AddressBusOUT; // Read address bus, width determined from RAM_DEPTH
//  input wire [RAM_WIDTH-1:0] InpData;          // RAM input data
//  input clk;                          // Clock
//  input WE;                           // Write enable
//  input ReadEn;                           // Read Enable, for additional power savings, disable when not in use
//  wire rstb;                          // Output reset (does not affect memory contents)
//  wire regceb;                        // Output register enable
//  wire [RAM_WIDTH-1:0] DATA_OUT;                  // RAM output data

//  reg [RAM_WIDTH-1:0] BRAM [RAM_DEPTH-1:0];
//  reg [RAM_WIDTH-1:0] RAM_DATA = {RAM_WIDTH{1'b0}};

//  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
//  generate
//    if (INIT_FILE != "") begin: use_init_file
//      initial
//        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
//    end else begin: init_bram_to_zero
//      integer ram_index;
//      initial
//        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
//          BRAM[ram_index] = {RAM_WIDTH{1'b0}};
//    end
//  endgenerate

//  always @(posedge clk) begin
//    if (WE)
//      BRAM[AddressBusIN] <= InpData;
//    if (ReadEn)
//      RAM_DATA  <= BRAM[AddressBusOUT];
//  end

//  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
//  generate
//    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

//      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
//       assign DATA_OUT = RAM_DATA;

//    end else begin: output_register

//      // The following is a 2 clock cycle read latency with improve clock-to-out timing

//      reg [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

//      always @(posedge clk)
//        if (rstb)
//          doutb_reg <= {RAM_WIDTH{1'b0}};
//        else if (regceb)
//          doutb_reg <= RAM_DATA;

//      assign DATA_OUT = doutb_reg;

//    end
//  endgenerate

//  //  The following function calculates the address width based on specified RAM depth
//  function integer clogb2;
//    input integer depth;
//      for (clogb2=0; depth>0; clogb2=clogb2+1)
//        depth = depth >> 1;
//  endfunction
						
						
//endmodule

module BRAM_MODULE(clk, addr, dout);
    parameter n = 8;
    parameter ADDR_WIDTH = n;   // Address width of the BRAM
    parameter DATA_WIDTH = 4*n;   // Data width of the BRAM
    parameter DEPTH = 8192/(4*n);      // Depth of the BRAM
  
      input clk;                  // Clock input
      input [ADDR_WIDTH-1:0] addr; // Address input
      output reg [DATA_WIDTH-1:0] dout; // Data output
      
      reg [DATA_WIDTH-1:0] mem [0:DEPTH-1]; // BRAM memory array
      
      integer i;
      initial begin
        for(i = 10; i < DEPTH; i = i + 1)begin
            mem[i] <= 0;
        end
      end
      
      initial mem[0]=32'b000000_00001_00010_10000_00000_000001;
      initial mem[1]=32'b000010_01000_00100_00000_00000_000010;
      initial mem[2]=32'b010101_00000_00000_00000_00000_000101;
      initial mem[8]=32'b010100_00010_00000_00000_00000_000101;
      initial mem[9]=32'b010011_00010_00000_00000_00000_000101;
      
      always @(posedge clk) begin
        dout <= mem[addr];
      end
      
endmodule
