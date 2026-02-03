// D FLIP FLOP - UVM SEQUENCER
`ifndef D_SEQUENCER_SV
`define D_SEQUENCER_SV

`include "transaction.sv"

class d_sequencer extends uvm_sequencer #(d_transaction);
  `uvm_component_utils(d_sequencer)
  
  function new(string name = "d_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQUENCER", "Sequencer Created", UVM_LOW)
  endfunction
endclass

`endif
