// SINGLE PORT RAM - UVM TRANSACTION
`ifndef SRAM_TRANSACTION_SV
`define SRAM_TRANSACTION_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class sram_trans #(parameter DEPTH = 8, WIDTH = 8) extends uvm_sequence_item;
  `uvm_object_utils(sram_trans)
  
  rand bit w_en;
  rand bit [$clog2(DEPTH)-1:0] addr;
  rand bit [WIDTH-1:0] data_in;
       bit [WIDTH-1:0] data_out;
  
  function new(string name = "sram_trans");
    super.new(name);
  endfunction
  
  function string display();
    return $sformatf("INPUT w_en = %0b | Address = %d | Data In = %0d \t OUTPUT Data out = %0d", w_en, addr, data_in, data_out);
  endfunction
  
endclass

`endif
