// FULL ADDER - UVM TESTBENCH

`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "test.sv"

module Full_Adder_tb;
  
  parameter N = 8;
  
  logic clk = 0;
  always #5 clk = ~clk;

  FA_intf vintf(clk);
  
  Fulladder #(N) DUT (.intf(vintf));

  initial begin
    uvm_config_db#(virtual FA_intf)::set(null, "*", "vintf", vintf);
    run_test("fa_test");
  end
  
  initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(0,Full_Adder_tb);
  end
endmodule
