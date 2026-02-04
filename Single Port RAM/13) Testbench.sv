// SINGLE PORT RAM - UVM TESTBENCH

`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "interface.sv"
`include "test.sv"

module sram_tb;
  
  parameter DEPTH = 8;
  parameter WIDTH = 8;
  
  logic clk = 0;
  always #5 clk = ~clk;

  sram_intf vintf(clk);
  
  single_port_ram #(.DEPTH(DEPTH), .WIDTH(WIDTH)) DUT (.clk(vintf.clk),
                                                       .w_en(vintf.w_en),
                                                       .addr(vintf.addr),
                                                       .data_in(vintf.data_in),
                                                       .data_out(vintf.data_out));

  initial begin
    uvm_config_db#(virtual sram_intf)::set(null, "*", "vintf", vintf);
    run_test("sram_test");
  end
  
  initial begin
    $dumpfile("sram.vcd");
    $dumpvars(0,sram_tb);
  end
endmodule



