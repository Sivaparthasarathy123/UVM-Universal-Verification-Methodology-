// FULL ADDER - UVM DRIVER

`ifndef FA_DRIVER_SV
`define FA_DRIVER_SV

`include "transaction.sv"
`include "interface.sv"

class fa_driver extends uvm_driver #(fa_transaction);
  `uvm_component_utils(fa_driver)
  
  virtual FA_intf vintf;
  
  function new(string name = "fa_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual FA_intf)::get(this, "", "vintf", vintf))
      `uvm_fatal("NO_VINTF", "Virtual interface not found in Driver")
  endfunction
  
  task run_phase(uvm_phase phase);
    fa_transaction req;  
    repeat (5) begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done();
    end
  endtask

  
    task driver(fa_transaction trans);
      @(vintf.drv);
      vintf.drv.a <= trans.a;
      vintf.drv.b <= trans.b;
      vintf.drv.c <= trans.c;
   
      `uvm_info("DRIVER", $sformatf("Driving: INPUT A = %0d | B = %0d | C = %0d", trans.a, trans.b, trans.c), UVM_LOW)
 
  endtask
endclass

`endif
