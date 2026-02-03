// D FLIP FLOP - UVM INTERFACE

`ifndef D_INTERFACE_SV
`define D_INTERFACE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

interface D_ff (input logic clk);
  logic rst;
  logic d;
  logic q;
  
  // Clocking block for driver 
  clocking drv @(negedge clk);
    default input#1 output#1;
    input q;
    output rst, d;
  endclocking
  
  // Clocking block for monitor
  clocking mon @(posedge clk);
    default input#1 output#1;
    input rst, d, q;
  endclocking
  
  // Modport for DUT
  modport DUT (input clk, rst, d, output q);
  
endinterface

`endif
