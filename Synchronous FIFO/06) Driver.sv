// SYNCHRONOUS FIFO - UVM DRIVER
`ifndef SF_DRIVER_SV
`define SF_DRIVER_SV

import sync_fifo_pkg::*;

class sync_fifo_driver #(DEPTH = 8, WIDTH = 8) extends uvm_driver #(sync_fifo_trans #(DEPTH, WIDTH));
  `uvm_component_utils(sync_fifo_driver #(DEPTH, WIDTH))
  
  // Virtual Interface
  virtual sync_fifo_intf#(DEPTH, WIDTH) vintf;
  
  // Registered and using parent functionalities
  function new(string name = "sync_fifo_driver" , uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual sync_fifo_intf#(DEPTH, WIDTH))::get(this,"","vintf",vintf))
    `uvm_fatal("NO_VINTF","Virtual Interface not found in Driver")
  endfunction
  
  // Using Virtual task
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done;
    end
  endtask
  
    virtual task driver(sync_fifo_trans#(DEPTH, WIDTH) tr);
    @(vintf.drv);
    vintf.w_en    <= tr.w_en;
    vintf.r_en    <= tr.r_en;
    vintf.data_in <= tr.data_in;
         
    // Using .sprint() to uses the utility macros
    `uvm_info("DRIVER", $sformatf("Driving Transaction:\n%s", tr.sprint()), UVM_LOW)
    `uvm_info("PARAM_CHECK", $sformatf("FIFO DEPTH: %0d", DEPTH), UVM_LOW)
  endtask
  
endclass
`endif
  
  
       
