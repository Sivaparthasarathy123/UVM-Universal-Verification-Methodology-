// SYNCHRONOUS FIFO - UVM TEST
`ifndef SF_TEST_SV
`define SF_TEST_SV

`include "transaction.sv"

`include "environment.sv"
`include "sequence.sv"

import sync_fifo_pkg::*;

class sync_fifo_test #(DEPTH = 8, WIDTH = 8) extends uvm_test;
  `uvm_component_param_utils(sync_fifo_test #(DEPTH, WIDTH))
  
  typedef sync_fifo_test #(DEPTH, WIDTH) sync_fifo_test_8x8;
  
  sync_fifo_environment#(DEPTH, WIDTH) env;
  sync_fifo_seq #(DEPTH, WIDTH) seq;
  
  function new(string name = "sync_fifo_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = sync_fifo_environment#(DEPTH, WIDTH)::type_id::create("env", this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    sync_fifo_seq#(DEPTH, WIDTH) seq;
    phase.raise_objection(this);
    
    seq = sync_fifo_seq#(DEPTH, WIDTH)::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 100); 
    phase.drop_objection(this);
    
    `uvm_info("TEST", "Sequence Finished", UVM_LOW)
  endtask
endclass

  // Define a non-parameterized version for the Factory
  class sync_fifo_test_simple extends sync_fifo_test #(DEPTH, WIDTH);
    `uvm_component_utils(sync_fifo_test_simple)
  function new(string name = "sync_fifo_test_simple", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

`endif


