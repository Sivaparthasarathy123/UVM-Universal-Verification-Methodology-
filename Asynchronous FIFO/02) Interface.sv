// ASYNCHRONOUS FIFO - UVM INTERFACE
`ifndef ASF_INTERFACE_SV
`define ASF_INTERFACE_SV

// Interface
interface async_fifo_intf #(parameter DEPTH = 8, WIDTH = 8)(input logic w_clk, r_clk, w_rst, r_rst);

  logic w_en, r_en;
  logic [WIDTH-1:0] data_in;
  logic [WIDTH-1:0] data_out;
  logic full, empty;
  
  // clocking block for driver for write
  clocking w_drv_cb @(negedge w_clk);
    default input#2 output#2;
    output w_en, data_in;
    input full;
  endclocking
  
  // clocking block for Monitor for write
  clocking w_mon_cb @(posedge w_clk);
    default input#1;
    input w_rst, w_en, data_in, full;
  endclocking
  
  // clocking block for driver for read
  clocking r_drv_cb @(negedge r_clk);
    default input#2 output#2;
    output r_en; 
    input data_out, empty;
  endclocking
  
  // clocking block for Monitor for read
  clocking r_mon_cb @(posedge r_clk);
    default input#1;
    input r_rst, r_en, data_out, empty;
  endclocking
  
endinterface

`endif
                      
