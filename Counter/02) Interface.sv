// UVM UP DOWN COUNTER INTERFACE
`ifndef COUNTER_INTERFACE
`define COUNTER_INTERFACE

interface counter_intf #(parameter N=8)(input logic clk);
  localparam MAX = (2**N)-1;

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

  // Reset check
  property reset_check;
    @(posedge clk)
    rst |-> ##1 count == 0;       // ##1 (1 clock cycle)
  endproperty
  assert property(reset_check);

  // Up and down count and wrap check
  property up_down_check;
    @(posedge clk)
    disable iff (rst)
    $isunknown($past(count,1,0))==0 |-> up_down ? 
        (($past(count,1,0)==MAX) ? count==0 : count==$past(count,1,0)+1)
      : (($past(count,1,0)==0)   ? count==MAX : count==$past(count,1,0)-1);
  endproperty

  assert property(up_down_check)
    else $display("ASSERTION FAIL Time = %0t | count = %0d | $past(count) = %0d | up_down = %0b",
                   $time, count, $past(count,1,0), up_down);

endinterface
`endif
