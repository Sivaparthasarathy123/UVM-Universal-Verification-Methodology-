// SINGLE PORT RAM - UVM DESIGN
module single_port_ram #(
  parameter DEPTH = 8,
  parameter WIDTH = 8)(
  
  input clk,
  input w_en,
  input [$clog2(DEPTH)-1:0] addr,
  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out
);
  
  // RAM Memory
  reg [WIDTH-1:0] mem [DEPTH-1:0];
  
  always @(posedge clk) begin
    if (w_en) begin
      mem[addr] <= data_in;
    end
    
    // Read before Write RAM
    data_out <= mem[addr];   
  end  
endmodule
