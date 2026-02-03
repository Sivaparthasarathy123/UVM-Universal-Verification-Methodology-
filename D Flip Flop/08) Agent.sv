// D FLIP FLOP - UVM AGENT
`ifndef D_AGENT_SV
`define D_AGENT_SV

`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"

class d_agent extends uvm_agent;
  `uvm_component_utils(d_agent)
  
  d_sequencer sequencer;
  d_driver driver;
  d_monitor monitor;
  
  function new(string name = "d_agent", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("AGENT", "Agent Created", UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = d_monitor::type_id::create("monitor", this);
    
    if(get_is_active() == UVM_ACTIVE) begin
      driver = d_driver::type_id::create("driver", this);
      sequencer = d_sequencer::type_id::create("sequencer", this);
    end
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
endclass
 
`endif
