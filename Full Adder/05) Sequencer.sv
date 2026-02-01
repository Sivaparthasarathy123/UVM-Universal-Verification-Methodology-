// FULL ADDER - UVM SEQUENCER

`ifndef FA_SEQUENCER_SV
`define FA_SEQUENCER_SV

`include "transaction.sv"

class fa_sequencer extends uvm_sequencer #(fa_transaction);
  `uvm_component_utils(fa_sequencer)
  
  function new(string name = "fa_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQUENCER", "Sequencer Created", UVM_LOW)
  endfunction
endclass

`endif
