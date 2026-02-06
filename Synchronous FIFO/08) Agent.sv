// SYNCHRONOUS FIFO - UVM AGENT
`ifndef SF_AGENT_SV
`define SF_AGENT_SV

`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"

import sync_fifo_pkg::*;

class sync_fifo_agent #(DEPTH = 8, WIDTH = 8) extends uvm_agent;
  `uvm_component_param_utils(sync_fifo_agent#(DEPTH, WIDTH))
  
  sync_fifo_sequencer#(DEPTH, WIDTH) sequencer;
  sync_fifo_driver#(DEPTH, WIDTH) driver;
  sync_fifo_monitor#(DEPTH, WIDTH) monitor;
  
  // Using super to use functionalities of parent
  function new(string name = "sync_fifo_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active()==UVM_ACTIVE)begin
      driver    = sync_fifo_driver#(DEPTH, WIDTH)::type_id::create("driver",this);
      sequencer = sync_fifo_sequencer#(DEPTH, WIDTH)::type_id::create("sequencer",this);
    end
    
    monitor = sync_fifo_monitor#(DEPTH, WIDTH)::type_id::create("monitor",this);
   
  endfunction
  
  // connect phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active()==UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass
`endif
