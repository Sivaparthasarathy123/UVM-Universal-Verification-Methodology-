// FULL ADDER - UVM TEST

`ifndef FA_TEST_SV
`define FA_TEST_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"  

`include "environment.sv"
`include "sequence.sv"

class fa_test extends uvm_test;
  `uvm_component_utils(fa_test)
  
  fa_environment env;
  fa_sequence seq;
  
  function new(string name = "fa_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fa_environment::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    fa_sequence seq;
    phase.raise_objection(this);
    seq = fa_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 50ns); 
    phase.drop_objection(this);
  endtask
endclass

`endif

  
