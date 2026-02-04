// SINGLE PORT RAM - UVM AGENT
`ifndef SRAM_AGENT_SV
`define SRAM_AGENT_SV

`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"

class sram_agent extends uvm_agent;
  `uvm_component_utils(sram_agent)
  
  sram_sequencer sequencer;
  sram_driver driver;
  sram_monitor monitor;
  
  // Using super to use functionalities of parent
  function new(string name = "sram_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active()==UVM_ACTIVE)begin
      driver = sram_driver::type_id::create("driver",this);
      sequencer = sram_sequencer::type_id::create("sequencer",this);
    end
    
    monitor = sram_monitor::type_id::create("monitor",this);
   
  endfunction
  
  // connect phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active()==UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass
`endif
