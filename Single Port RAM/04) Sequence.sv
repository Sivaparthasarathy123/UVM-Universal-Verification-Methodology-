// SINGLE PORT RAM - UVM SEQUENCE
`ifndef SRAM_SEQUENCE_SV
`define SRAM_SEQUENCE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"

class sram_seq extends uvm_sequence #(sram_trans);
  `uvm_object_utils(sram_seq)
  
  function new(string name = "sram_seq");
    super.new(name);
  endfunction
  
  task body();  
    `uvm_info ("SEQUENCE", "Sequence Started", UVM_LOW);
    // Corner Cases 
    `uvm_do_with(req, {req.addr == 0; req.w_en == 1; req.data_in == 8'h00;})
    `uvm_do_with(req, {req.addr == 7; req.w_en == 1; req.data_in == 8'hFF;})
    // Write and Read every address 
    for(int i=0; i<8; i++) begin
        `uvm_do_with(req, {req.addr == i; req.w_en == 1;})
        `uvm_do_with(req, {req.addr == i; req.w_en == 0;})
    end
  endtask
  
endclass
`endif
