// SYNCHRONOUS FIFO - UVM ENVIRONMENT
`ifndef SF_ENVIRONMENT_SV
`define SF_ENVIRONMENT_SV

`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

import sync_fifo_pkg::*;

class sync_fifo_environment #(DEPTH = 8, WIDTH = 8) extends uvm_env;
  `uvm_component_param_utils(sync_fifo_environment #(DEPTH, WIDTH))
  
  sync_fifo_agent #(DEPTH, WIDTH) agent;
  sync_fifo_scoreboard #(DEPTH, WIDTH) scbd;
  sync_fifo_coverage #(DEPTH, WIDTH) cov;
  
  function new(string name = "sync_fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    agent = sync_fifo_agent#(DEPTH, WIDTH)::type_id::create("agent", this);
    scbd  = sync_fifo_scoreboard#(DEPTH, WIDTH)::type_id::create("scbd", this);
    cov   = sync_fifo_coverage#(DEPTH, WIDTH)::type_id::create("cov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase); 
    
    agent.monitor.analysis_port.connect(scbd.item_got);
    agent.monitor.analysis_port.connect(cov.analysis_export);
  endfunction

endclass

`endif
