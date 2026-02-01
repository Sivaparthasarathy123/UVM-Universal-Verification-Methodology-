// FULL ADDER - UVM ENVIRONMENT

`ifndef FA_ENVIRONMENT_SV
`define FA_ENVIRONMENT_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"

`include "agent.sv"
`include "scoreboard.sv"

class fa_environment extends uvm_env;
  `uvm_component_utils(fa_environment)
  
  fa_agent agent;
  fa_scoreboard scbd;
  
  function new(string name = "environment", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("ENVIRONMENT", "Environment Created", UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = fa_agent::type_id::create("agent", this);
    scbd = fa_scoreboard::type_id::create("scbd", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agent.monitor.ap.connect(scbd.analysis_export);
  endfunction
endclass

`endif
