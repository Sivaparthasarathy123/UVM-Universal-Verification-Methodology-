// UP DOWN COUNTER - UVM TESTBENCH
`timescale 1ns/1ps

`include "interface.sv"

`include "package.sv"
import counter_pkg::*;

module counter_tb;
 
  bit clk;
  
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    vif.rst = 1;
    #100 vif.rst = 0;
  end

  counter_intf #(N) vif(clk);

  nbit_updown_modn_counter #(.N(N)) dut (
    .clk(clk),
    .rst(vif.rst),
    .up_down(vif.up_down),
    .count(vif.count)
  );

  initial begin
    uvm_config_db#(virtual counter_intf#(N))::set(null, "*", "vintf", vif);
    run_test("counter_test");
  end

  initial begin
    $dumpfile("counter.vcd");
    $dumpvars;
  end
endmodule
