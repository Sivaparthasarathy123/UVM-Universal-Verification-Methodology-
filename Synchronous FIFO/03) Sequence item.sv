// SYNCHRONOUS FIFO - UVM TRANSACTION
`ifndef SF_TRANSACTION_SV
`define SF_TRANSACTION_SV

import sync_fifo_pkg::*;

class sync_fifo_trans #(DEPTH = 8, WIDTH = 8) extends uvm_sequence_item;
  
  bit rst; 
  rand bit w_en, r_en;
  rand bit [WIDTH-1:0] data_in;
       bit [WIDTH-1:0] data_out;
       bit full, empty;

  `uvm_object_param_utils_begin(sync_fifo_trans #(DEPTH, WIDTH))
    `uvm_field_int(rst,      UVM_ALL_ON)
    `uvm_field_int(w_en,     UVM_ALL_ON)
    `uvm_field_int(r_en,     UVM_ALL_ON)
    `uvm_field_int(data_in,  UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(data_out, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(full,     UVM_ALL_ON)
    `uvm_field_int(empty,    UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "sync_fifo_trans");
    super.new(name);
  endfunction
endclass

`endif
