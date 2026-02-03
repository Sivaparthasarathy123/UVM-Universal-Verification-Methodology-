// D FLIP FLOP - UVM ENVIRONMENT

`ifndef D_ENVIRONMENT_SV
`define D_ENVIRONMENT_SV

import uvm_pkg::*;          
`include "uvm_macros.svh"

`include "agent.sv"
`include "scoreboard.sv"

class d_environment extends uvm_env;
  `uvm_component_utils(d_environment)
  
  d_agent agent;
  d_scoreboard scbd;
  
  function new(string name = "d_environment", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("ENVIRONMENT", "Environment Created", UVM_LOW)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = d_agent::type_id::create("agent", this);
    scbd  = d_scoreboard::type_id::create("scbd", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agent.monitor.ap.connect(scbd.analysis_export);
  endfunction
endclass

`endif
