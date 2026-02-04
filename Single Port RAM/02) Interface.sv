// SINGLE PORT RAM - UVM INTERFACE
`ifndef SRAM_INTERFACE_SV
`define SRAM_INTERFACE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

interface sram_intf #(parameter DEPTH = 8,
                      parameter WIDTH = 8)(input logic clk);
  logic w_en;
  logic [$clog2(DEPTH)-1:0] addr;
  logic [WIDTH-1:0] data_in;
  logic [WIDTH-1:0] data_out;
  
  // clocking block for driver
  clocking drv @(negedge clk);
    default output#1;
    output w_en, addr, data_in;
  endclocking
  
  // clocking block for Monitor
  clocking mon @(posedge clk);
    default input#1;
    input w_en, addr, data_in, data_out;
  endclocking
  
endinterface

`endif
                      
