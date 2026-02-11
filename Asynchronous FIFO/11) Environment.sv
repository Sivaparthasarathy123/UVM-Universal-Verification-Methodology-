// ASYNCHRONOUS FIFO - UVM ENVIRONMENT
`ifndef ASF_ENVIRONMENT_SV
`define ASF_ENVIRONMENT_SV

`include "agent.sv"
`include "scoreboard.sv"
`include "coverage.sv"

class async_fifo_environment #(DEPTH = 8, WIDTH = 8) extends uvm_env;
  `uvm_component_param_utils(async_fifo_environment #(DEPTH, WIDTH))
  
  async_fifo_agent #(DEPTH, WIDTH) agent;
  async_fifo_scoreboard #(DEPTH, WIDTH) scbd;
  async_fifo_coverage #(DEPTH, WIDTH) cov;
  
  function new(string name = "async_fifo_environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    agent = async_fifo_agent#(DEPTH, WIDTH)::type_id::create("agent", this);
    scbd  = async_fifo_scoreboard#(DEPTH, WIDTH)::type_id::create("scbd", this);
    cov   = async_fifo_coverage#(DEPTH, WIDTH)::type_id::create("cov", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase); 
    
    agent.monitor.w_ap.connect(scbd.write_imp);
    agent.monitor.r_ap.connect(scbd.read_imp);
    agent.monitor.w_ap.connect(cov.analysis_export);
    agent.monitor.r_ap.connect(cov.analysis_export);
  endfunction

endclass

`endif
