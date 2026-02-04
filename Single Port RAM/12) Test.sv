// SINGLE PORT RAM - UVM TEST
`ifndef SRAM_TEST_SV
`define SRAM_TEST_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"  

`include "environment.sv"
`include "sequence.sv"

class sram_test extends uvm_test;
  `uvm_component_utils(sram_test)
  
  sram_environment env;
  sram_seq seq;
  
  function new(string name = "sram_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = sram_environment::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    sram_seq seq;
    phase.raise_objection(this);
    seq = sram_seq::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 100); 
    phase.drop_objection(this);
  endtask
endclass

`endif
