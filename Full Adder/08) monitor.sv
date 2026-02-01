// FULL ADDER - UVM MONITOR

`ifndef FA_MONITOR_SV
`define FA_MONITOR_SV

`include "transaction.sv"
`include "interface.sv"

class fa_monitor extends uvm_monitor;
  `uvm_component_utils(fa_monitor)
  
  virtual FA_intf vintf;
  uvm_analysis_port #(fa_transaction) ap;
  fa_transaction trans;
  
  function new(string name = "fa_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual FA_intf)::get(this, "", "vintf", vintf))
      `uvm_fatal("NO_VINTF", "Virtual interface not found in Monitor")
      ap = new("ap", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    fa_transaction trans;
    repeat(5) begin
      @(vintf.mon);
      trans = fa_transaction::type_id::create("trans");
      trans.a = vintf.mon.a;
      trans.b = vintf.mon.b;
      trans.c = vintf.mon.c;
      trans.sum = vintf.mon.sum;
      trans.carry = vintf.mon.carry;
      ap.write(trans);
      `uvm_info("MONITOR", $sformatf("Monitored: %s", trans.convert2string()), UVM_LOW)
    end
  endtask
endclass

`endif
