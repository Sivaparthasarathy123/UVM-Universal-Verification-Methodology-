// UP DOWN COUNTER - UVM MONITOR
`ifndef COUNTER_MONITOR
`define COUNTER_MONITOR

class counter_monitor extends uvm_monitor;
  `uvm_component_utils(counter_monitor)

  virtual counter_intf#(N) vintf;

  // Analysis port with parameter
  uvm_analysis_port #(counter_seq_item) analysis_port;

  function new(string name = "counter_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual counter_intf#(N))::get(this,"","vintf",vintf))
      `uvm_fatal("NO_VINTF","Virtual Interface not found in monitor")

      analysis_port = new("analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      counter_seq_item tr;
      @(vintf.mon); 

      tr = counter_seq_item::type_id::create("tr");
      
      tr.rst      = vintf.mon.rst;
      tr.up_down  = vintf.mon.up_down;
      tr.count    = vintf.mon.count;

      // `uvm_info("MONITOR", $sformatf("Monitoring Transaction:\n%s", tr.sprint()), UVM_LOW)
      `uvm_info("MONITOR", $sformatf("Monitoring Transaction: Time = %0t | rst = %0b | up_down = %0b | count = %0d (%0b)",$time,tr.rst,tr.up_down, tr.count, tr.count), UVM_LOW)
      analysis_port.write(tr);
      
    end
  endtask
endclass

`endif
