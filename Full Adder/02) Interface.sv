// FULL ADDER - UVM INTERFACE

`ifndef FA_INTERFACE_SV
`define FA_INTERFACE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

interface FA_intf #(parameter N = 8)(input logic clk);
  logic [N-1:0]a;
  logic [N-1:0]b;
  logic [N-1:0]c;
  logic [N-1:0]sum;
  logic [N-1:0]carry;
  
  // Clocking Block for Driver
  clocking drv @(negedge clk);
    default input#1 output#1;
    output a ,b ,c;
    input sum, carry;
  endclocking
  
  // Clocking Block for Monitor
  clocking mon @(posedge clk);
    default input#1 output#1;
    input a, b, c, sum, carry;
  endclocking
  
  // Modport for DUT 
  modport DUT (input a, b, c, output sum, carry);
  
  // Modport for Testbench
  modport TB (input sum, carry, output a, b, c);

endinterface

`endif
  
    
