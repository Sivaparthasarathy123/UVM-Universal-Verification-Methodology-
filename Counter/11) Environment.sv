// UP DOWN COUNTER - UVM ENVIRONMENT
`ifndef COUNTER_ENVIRONMENT
`define COUNTER_ENVIRONMENT

class counter_environment extends uvm_env;
  `uvm_component_utils(counter_environment)
  
  counter_agent agent;
  counter_scoreboard scbd;
  counter_coverage cov;
  
  function new(string name = "counter_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    agent = counter_agent::type_id::create("agent", this);
    scbd  = counter_scoreboard::type_id::create("scbd", this);
    cov   = counter_coverage::type_id::create("cov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase); 
    
    agent.monitor.analysis_port.connect(scbd.item_got);
    agent.monitor.analysis_port.connect(cov.analysis_export);
  endfunction

endclass

`endif
