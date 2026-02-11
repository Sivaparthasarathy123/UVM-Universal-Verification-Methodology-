// ASYNCHRONOUS FIFO - UVM TEST
`ifndef ASF_TEST_SV
`define ASF_TEST_SV

`include "transaction.sv"

`include "environment.sv"
`include "sequence.sv"

class async_fifo_test #(DEPTH = 8, WIDTH = 8) extends uvm_test;
  `uvm_component_param_utils(async_fifo_test #(DEPTH, WIDTH))
  
  typedef async_fifo_test #(DEPTH, WIDTH) async_fifo_test_8x8;
  
  async_fifo_environment#(DEPTH, WIDTH) env;
  async_fifo_seq #(DEPTH, WIDTH) seq;
  
  function new(string name = "async_fifo_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = async_fifo_environment#(DEPTH, WIDTH)::type_id::create("env", this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    async_fifo_seq#(DEPTH, WIDTH) seq;
    phase.raise_objection(this);
    
    seq = async_fifo_seq#(DEPTH, WIDTH)::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 100); 
    phase.drop_objection(this);
    
    `uvm_info("TEST", "Sequence Finished", UVM_LOW)
  endtask
endclass

// Define a non-parameterized version for the Factory
class async_fifo_test_simple extends async_fifo_test #(DEPTH, WIDTH);
  `uvm_component_utils(async_fifo_test_simple)
  function new(string name = "async_fifo_test_simple", uvm_component parent = null);
    super.new(name, parent);
  endfunction
endclass

`endif


