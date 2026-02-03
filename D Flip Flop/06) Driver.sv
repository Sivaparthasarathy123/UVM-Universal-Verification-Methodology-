// D FLIP FLOP - UVM DRIVER
`ifndef D_DRIVER_SV
`define D_DRIVER_SV

`include "transaction.sv"
`include "interface.sv"

class d_driver extends uvm_driver #(d_transaction);
  `uvm_component_utils(d_driver)
  
  virtual D_ff vintf;
  
  function new(string name = "d_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual D_ff)::get(this,"","vintf",vintf))
       `uvm_fatal("NO_VINTF", "Virtual interface not found in Driver")
  endfunction
      
  task run_phase(uvm_phase phase);
    d_transaction req;  
    repeat (5) begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done();
    end
  endtask
    
    task driver(d_transaction trans);
      @(vintf.drv);
      vintf.rst <= trans.rst;
      vintf.d <= trans.d;
   
      `uvm_info("DRIVER", $sformatf("Driving: INPUT Reset = %0b | D = %0b", trans.rst, trans.d), UVM_LOW)
 
  endtask
endclass

`endif

       
       
    
  
  
  
  
  
