// SINGLE PORT RAM - UVM ENVIRONMENT
`ifndef SRAM_ENVIRONMENT_SV
`define SRAM_ENVIRONMENT_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"

`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class sram_environment extends uvm_env;
  `uvm_component_utils(sram_environment)
  
  sram_agent agent;
  sram_scoreboard scbd;
  sram_coverage cov;
  
  function new(string name = "sram_environment", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("ENVIRONMENT", "Environment Created", UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = sram_agent::type_id::create("agent", this);
    scbd  = sram_scoreboard::type_id::create("scbd", this);
    cov  = sram_coverage::type_id::create("cov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agent.monitor.ap.connect(scbd.analysis_export);
    agent.monitor.ap.connect(cov.analysis_export);
  endfunction
endclass

`endif
