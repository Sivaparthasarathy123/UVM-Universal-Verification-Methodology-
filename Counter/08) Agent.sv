// UP DOWN COUNTER - UVM AGENT
`ifndef COUNTER_AGENT
`define COUNTER_AGENT

class counter_agent extends uvm_agent;
  `uvm_component_utils(counter_agent)
  
  counter_sequencer sequencer;
  counter_driver    driver;
  counter_monitor   monitor;
  
  // Using super to use functionalities of parent
  function new(string name = "counter_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active()==UVM_ACTIVE)begin
      driver    = counter_driver::type_id::create("driver",this);
      sequencer = counter_sequencer::type_id::create("sequencer",this);
    end
    
    monitor = counter_monitor::type_id::create("monitor",this);
   
  endfunction
  
  // connect phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active()==UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass
`endif
