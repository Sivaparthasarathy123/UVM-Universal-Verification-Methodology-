// ASYNCHRONOUS FIFO- UVM SEQUENCER
`ifndef ASF_SEQUENCER_SV
`define ASF_SEQUENCER_SV

class async_fifo_sequencer #(DEPTH = 8, WIDTH = 8) extends uvm_sequencer #(async_fifo_trans #(DEPTH, WIDTH));
  `uvm_component_param_utils(async_fifo_sequencer #(DEPTH, WIDTH))
  
  function new(string name = "async_fifo_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQUENCER", $sformatf("%s created", get_full_name()), UVM_LOW); // get_full_name is to represent sequencer name in environment (while multiple sequencer is used)
  endfunction
  
endclass
`endif
  
  
