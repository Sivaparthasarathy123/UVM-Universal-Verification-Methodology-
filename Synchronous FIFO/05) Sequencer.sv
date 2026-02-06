// SYNCHRONOUS FIFO- UVM SEQUENCER
`ifndef SF_SEQUENCER_SV
`define SF_SEQUENCER_SV

import sync_fifo_pkg::*;

class sync_fifo_sequencer #(DEPTH = 8, WIDTH = 8) extends uvm_sequencer #(sync_fifo_trans #(DEPTH, WIDTH));
  `uvm_component_param_utils(sync_fifo_sequencer #(DEPTH, WIDTH))
  
  function new(string name = "sync_fifo_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQUENCER", $sformatf("%s created", get_full_name()), UVM_LOW); // get_full_name is to represent sequencer name in environment (while multiple sequencer is used)
  endfunction
  
endclass
`endif
  
  
