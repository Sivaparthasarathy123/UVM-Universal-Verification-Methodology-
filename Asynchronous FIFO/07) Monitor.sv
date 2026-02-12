// ASYNCHRONOUS FIFO - UVM MONITOR
`ifndef ASF_MONITOR_SV
`define ASF_MONITOR_SV

class async_fifo_monitor #(DEPTH = 8, WIDTH = 8) extends uvm_monitor;
  `uvm_component_param_utils(async_fifo_monitor #(DEPTH, WIDTH))
  
  virtual async_fifo_intf#(DEPTH, WIDTH) vintf;
  
  // Analysis port with parameter
  uvm_analysis_port #(async_fifo_trans#(DEPTH, WIDTH)) w_ap;
  uvm_analysis_port #(async_fifo_trans#(DEPTH, WIDTH)) r_ap;


  function new(string name = "async_fifo_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual async_fifo_intf#(DEPTH, WIDTH))::get(this,"","vintf",vintf))
      `uvm_fatal("NO_VINTF","Virtual Interface not found in monitor")
    
      w_ap = new("w_ap", this);
      r_ap = new("r_ap", this);
  endfunction

virtual task run_phase(uvm_phase phase);
  
  // Declareing handles outside the procedural block
  async_fifo_trans#(DEPTH, WIDTH) w_tr;
  async_fifo_trans#(DEPTH, WIDTH) r_tr;

  fork
    // WRITE MONITOR
    forever begin
      @(vintf.w_mon_cb);
       
      w_tr = async_fifo_trans#(DEPTH, WIDTH)::type_id::create("w_tr", this);
      w_tr.w_rst   = vintf.w_mon_cb.w_rst;
      w_tr.w_en    = vintf.w_mon_cb.w_en;
      w_tr.data_in = vintf.w_mon_cb.data_in;
      w_tr.full    = vintf.w_mon_cb.full;
        
      //`uvm_info("MONITOR", $sformatf("Monitoring Transaction:\n%s", w_tr.sprint()), UVM_LOW)
        `uvm_info("MONITOR",$sformatf("WRITE SIGNALS: w_rst = %0h | w_en = %0h | Data In = %0h | Full = %0h",w_tr.w_rst, w_tr.w_en, w_tr.data_in, w_tr.full),UVM_LOW) 
        w_ap.write(w_tr);
    end

    // READ MONITOR
    forever begin
      @(vintf.r_mon_cb);
      
      r_tr = async_fifo_trans#(DEPTH, WIDTH)::type_id::create("r_tr", this);
      r_tr.r_rst    = vintf.r_mon_cb.r_rst;
      r_tr.r_en     = vintf.r_mon_cb.r_en;
      r_tr.data_out = vintf.r_mon_cb.data_out;
      r_tr.empty    = vintf.r_mon_cb.empty;

      //`uvm_info("MONITOR", $sformatf("Monitoring Transaction:\n%s", r_tr.sprint()), UVM_LOW)
        `uvm_info("MONITOR",$sformatf("READ SIGNALS: r_rst = %0h | r_en = %0h | Data Out = %0h | Empty = %0h",r_tr.r_rst, r_tr.r_en, r_tr.data_out, r_tr.empty),UVM_LOW) 
        r_ap.write(r_tr);
    end
  join
endtask
endclass

`endif
