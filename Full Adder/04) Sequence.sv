// FULL ADDER - UVM SEQUENCE

`ifndef FA_SEQUENCE_SV
`define FA_SEQUENCE_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"  
`include "transaction.sv"

class fa_sequence extends uvm_sequence #(fa_transaction);
  `uvm_object_utils(fa_sequence)
  
  function new(string name = "fa_sequence");
    super.new(name);
  endfunction
  
  task body();
    fa_transaction trans;
    `uvm_info("SEQ", "Sequence Started", UVM_LOW)
    
    repeat(5) begin
      trans = fa_transaction::type_id::create("trans");
      start_item(trans);
      if(!trans.randomize()) 
        `uvm_error("SEQ", "RANDOMIZATION IS FAILED");
      finish_item(trans);
    end
  endtask
endclass

`endif
