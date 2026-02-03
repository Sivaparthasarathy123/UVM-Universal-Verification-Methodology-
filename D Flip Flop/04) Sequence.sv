// D FLIP FLOP - UVM SEQUENCE

`ifndef D_SEQUENCE_SV
`define D_SEQUENCE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"

class d_sequence extends uvm_sequence #(d_transaction);
  `uvm_object_utils(d_sequence)
  
  // Creating a new constructor to accessing parent class
  function new (string name = "d_sequence");
    super.new(name);
  endfunction
  
  // Creating a task
  task body();
    d_transaction trans;
    `uvm_info("SEQUENCE", "Sequence Started", UVM_LOW)
    
    repeat (5) begin
      trans = d_transaction::type_id::create("trans");
      start_item(trans);
      if(!trans.randomize()) 
        `uvm_error("SEQ", "RANDOMIZATION IS FAILED");
      finish_item(trans);
    end
  endtask
endclass

`endif

    
    
  
