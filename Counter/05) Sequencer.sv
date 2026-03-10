// UP DOWN COUNTER - UVM SEQUENCER
`ifndef COUNTER_SEQUENCER
`define COUNTER_SEQUENCER

class counter_sequencer extends uvm_sequencer #(counter_seq_item);
  `uvm_component_utils(counter_sequencer)
  
  function new(string name = "counter_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQUENCER", $sformatf("%s created", get_full_name()), UVM_LOW); // get_full_name is to represent sequencer name in environment (while multiple sequencer is used)
  endfunction
  
endclass
`endif
