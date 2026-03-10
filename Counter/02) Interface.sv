// UVM UP DOWN COUNTER INTERFACE
`ifndef COUNTER_INTERFACE
`define COUNTER_INTERFACE
interface counter_intf #(parameter N = 4)(input logic clk);
  logic rst;
  logic up_down;
  logic [N-1:0] count;
  
  clocking drv @(negedge clk);
    default input#1 output#1;
    output rst, up_down;
    input count;
  endclocking
  
  clocking mon @(posedge clk);
    default input#1;
    input rst, up_down, count;
  endclocking
  
endinterface
`endif
