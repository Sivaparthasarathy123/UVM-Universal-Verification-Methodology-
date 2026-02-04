// SINGLE PORT RAM - UVM DRIVER
`ifndef SRAM_DRIVER_SV
`define SRAM_DRIVER_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"
`include "interface.sv"

class sram_driver extends uvm_driver #(sram_trans);
  `uvm_component_utils(sram_driver)
  
  // Virtual Interface
  virtual sram_intf vintf;
  
  // Registered and using parent functionalities
  function new(string name = "sram_driver" , uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual sram_intf)::get(this,"","vintf",vintf))
    `uvm_fatal("NO_VINTF","Virtual Interface not found in Driver")
  endfunction
  
  // Using Virtual task (request)
  task run_phase(uvm_phase phase);
    sram_trans req;
    forever begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done;
    end
  endtask
  
  virtual task driver(sram_trans tr);
    @(vintf.drv);
    vintf.w_en    <= tr.w_en;
    vintf.addr    <= tr.addr;
    vintf.data_in <= tr.data_in;
    
    `uvm_info("DRIVER", $sformatf("Driving: w_en = %0b | Address = %0d | Data In = %0d", tr.w_en, tr.addr, tr.data_in ),UVM_LOW);
  endtask
  
endclass
`endif
  
  
       
