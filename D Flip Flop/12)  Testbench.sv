// D FLIP FLOP - UVM TESTBENCH

`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "test.sv"

module D_FF_tb;
  
  
  logic clk = 0;
  always #5 clk = ~clk;

  D_ff vintf(clk);
  
  D_flip_flop DUT (.intf(vintf));

  initial begin
    uvm_config_db#(virtual D_ff)::set(null, "*", "vintf", vintf);
    run_test("d_test");
  end
  
  initial begin
    $dumpfile("d_ff.vcd");
    $dumpvars(0,D_FF_tb);
  end
endmodule

