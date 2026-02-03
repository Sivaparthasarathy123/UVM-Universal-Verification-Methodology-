// D FLIP FLOP - UVM MONITOR
`ifndef D_MONITOR_SV
`define D_MONITOR_SV


`include "transaction.sv"
`include "interface.sv"

class d_monitor extends uvm_monitor;
  `uvm_component_utils(d_monitor)
  
  virtual D_ff vintf;
  
  uvm_analysis_port #(d_transaction) ap;
  d_transaction trans;
  
  function new(string name = "d_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual D_ff)::get(this, "", "vintf", vintf))
      `uvm_fatal("NO_VINTF", "Virtual interface not found in Monitor")
      ap = new("ap", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    d_transaction trans;
    repeat(5) begin
      @(vintf.mon);
      trans = d_transaction::type_id::create("trans");
      trans.rst = vintf.rst;
      trans.d   = vintf.d;
      trans.q   = vintf.q;
      
      ap.write(trans);
      `uvm_info("MONITOR", $sformatf("Monitored: %s", trans.display()), UVM_LOW)
    end
  endtask
endclass

`endif
