// UP DOWN COUNTER - UVM TEST
`ifndef COUNTER_TEST
`define COUNTER_TEST

class counter_test extends uvm_test;
  `uvm_component_utils(counter_test)
  
  counter_environment env;
  counter_sequence seq;
  
  function new(string name = "counter_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = counter_environment::type_id::create("env", this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  task run_phase(uvm_phase phase);
    counter_sequence seq;
    phase.raise_objection(this);
    
    seq = counter_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
  
    phase.phase_done.set_drain_time(this, 10ns); 
    phase.drop_objection(this);
    
    `uvm_info("TEST", "Sequence Finished", UVM_LOW)
  endtask
endclass

`endif
