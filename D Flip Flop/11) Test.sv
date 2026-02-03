// D FLIP FLOP - UVM TEST
`ifndef D_TEST_SV
`define D_TEST_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"  

`include "environment.sv"
`include "sequence.sv"

class d_test extends uvm_test;
  `uvm_component_utils(d_test)
  
  d_environment env;
  d_sequence seq;
  
  function new(string name = "d_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = d_environment::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    d_sequence seq;
    phase.raise_objection(this);
    seq = d_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 50ns); 
    phase.drop_objection(this);
  endtask
endclass

`endif

  
