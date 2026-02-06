// SYNCHRONOUS FIFO - UVM MONITOR
`ifndef SF_MONITOR_SV
`define SF_MONITOR_SV

import sync_fifo_pkg::*;

class sync_fifo_monitor #(DEPTH = 8, WIDTH = 8) extends uvm_monitor;
  `uvm_component_param_utils(sync_fifo_monitor #(DEPTH, WIDTH))
  
  virtual sync_fifo_intf#(DEPTH, WIDTH) vintf;
  
  // Analysis port with parameter
  uvm_analysis_port #(sync_fifo_trans#(DEPTH, WIDTH)) analysis_port;

  function new(string name = "sync_fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual sync_fifo_intf#(DEPTH, WIDTH))::get(this,"","vintf",vintf))
      `uvm_fatal("NO_VINTF","Virtual Interface not found in monitor")
    
    analysis_port = new("analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      sync_fifo_trans#(DEPTH, WIDTH) tr;
      @(vintf.mon_cb); 
    
      if (vintf.mon_cb.w_en || vintf.mon_cb.r_en || vintf.mon_cb.rst) begin
        tr = sync_fifo_trans#(DEPTH, WIDTH)::type_id::create("tr");
      
        tr.rst      = vintf.mon_cb.rst;
        tr.w_en     = vintf.mon_cb.w_en;
        tr.r_en     = vintf.mon_cb.r_en;
        tr.data_in  = vintf.mon_cb.data_in;
        tr.full     = vintf.mon_cb.full;
        tr.empty    = vintf.mon_cb.empty;
      
        tr.data_out = vintf.mon_cb.data_out; 

        analysis_port.write(tr);
      end
    end
  endtask
endclass

`endif
