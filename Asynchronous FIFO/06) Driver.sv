// ASYNCHRONOUS FIFO - UVM DRIVER
`ifndef ASF_DRIVER_SV
`define ASF_DRIVER_SV

class async_fifo_driver #(DEPTH = 8, WIDTH = 8) extends uvm_driver #(async_fifo_trans #(DEPTH, WIDTH));
  `uvm_component_param_utils(async_fifo_driver #(DEPTH, WIDTH))
  
  // Virtual Interface
  virtual async_fifo_intf#(DEPTH, WIDTH) vintf;
  
  // Registered and using parent functionalities
  function new(string name = "async_fifo_driver" , uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual async_fifo_intf#(DEPTH, WIDTH))::get(this,"","vintf",vintf))
    `uvm_fatal("NO_VINTF","Virtual Interface not found in Driver")
  endfunction
  
  // Run phase
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done;
    end
  endtask
  
  // Virtual task
  virtual task driver(async_fifo_trans#(DEPTH, WIDTH) tr);
    
    // Handle Write Domain
     @(vintf.w_drv_cb);
      vintf.w_drv_cb.w_rst   <= tr.w_rst;
      vintf.w_drv_cb.w_en    <= tr.w_en;
      vintf.w_drv_cb.data_in <= tr.data_in;

    // Handle Read Domain
     @(vintf.r_drv_cb);
      vintf.r_drv_cb.r_rst   <= tr.r_rst;
      vintf.r_drv_cb.r_en    <= tr.r_en;
    
      // Using .sprint() to uses the utility macros
    `uvm_info("DRIVER",$sformatf("SIGNALS: w_rst = %0h | w_en = %0h | Data In = %0h | r_rst = %0h | r_en = %0h",tr.w_rst, tr.w_en, tr.data_in, tr.r_rst, tr.r_en),UVM_LOW) 
       // `uvm_info("DRIVER", $sformatf("Driving Transaction:\n%s", tr.sprint()), UVM_LOW)
      //`uvm_info("PARAM_CHECK", $sformatf("FIFO DEPTH: %0d", DEPTH), UVM_LOW)
    
  endtask
  
endclass
`endif
