// SYNCHRONOUS FIFO - UVM INTERFACE
`ifndef SF_INTERFACE_SV
`define SF_INTERFACE_SV

import sync_fifo_pkg::*;

// Interface
interface sync_fifo_intf #(parameter DEPTH = 8, WIDTH = 8)(input logic clk, input logic rst);

  logic w_en, r_en;
  logic [WIDTH-1:0] data_in;
  logic [WIDTH-1:0] data_out;
  logic full, empty;
  
  // clocking block for driver
  clocking drv @(negedge clk);
    default input#2 output#2;
    output w_en, r_en, data_in;
    input full, empty;
  endclocking
  
  // clocking block for Monitor
  clocking mon_cb @(posedge clk);
    default input#1;
    input rst, w_en, r_en, data_in, data_out, full, empty;
  endclocking
  
endinterface

`endif
                      
