// SINGLE PORT RAM - UVM MONITOR
`ifndef SRAM_MONITOR_SV
`define SRAM_MONITOR_SV

`include "transaction.sv"
`include "interface.sv"

class sram_monitor extends uvm_monitor;
  `uvm_component_utils(sram_monitor)
  
  // Virtual interface
  virtual sram_intf vintf;
 
  // Analysis Port
  uvm_analysis_port #(sram_trans) ap;
  sram_trans tr;
  
  // Using super to use functionalities of parent
  function new(string name = "sram_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // constructing build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual sram_intf)::get(this,"","vintf",vintf))
    `uvm_fatal("NO_VINTF","Virtual Interface not found in monitor")
      ap = new("ap",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    sram_trans tr;
    repeat (18) begin
      @(vintf.mon)
      tr = sram_trans#(8,8)::type_id::create("tr");
      tr.w_en = vintf.w_en;
      tr.addr = vintf.addr;
      tr.data_in = vintf.data_in;
      tr.data_out = vintf.data_out;
      
      ap.write(tr);
      `uvm_info("MONITOR", $sformatf("Monitored: %s", tr.display()), UVM_LOW)
    end
  endtask
  
endclass
`endif
