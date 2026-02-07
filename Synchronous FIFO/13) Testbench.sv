// SYNCHRONOUS FIFO - UVM TESTBENCH
`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "package.sv"
import sync_fifo_pkg::*;

`include "interface.sv"
`include "test.sv"

module sync_fifo_tb;
 
  bit clk, rst;

  // Clock Generation
  always #5 clk = ~clk;

  // Reset Generation
  initial begin
    rst = 1;
    #20 rst = 0;
    #100 rst = 1;
    #100 rst = 0;
  end

  sync_fifo_intf #(DEPTH, WIDTH) vif(clk, rst);

  synchronous_FIFO #(.DEPTH(DEPTH), .WIDTH(WIDTH)) dut (
    .clk(vif.clk),
    .rst(vif.rst),
    .w_en(vif.w_en),
    .r_en(vif.r_en),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty)
  );

  initial begin
    uvm_config_db#(virtual sync_fifo_intf#(DEPTH, WIDTH))::set(null, "*", "vintf", vif);
    run_test("sync_fifo_test_simple");
  end

  initial begin
    $dumpfile("sync_fifo.vcd");
    $dumpvars;
  end
endmodule



