// ASYNCHRONOUS FIFO - UVM TESTBENCH

`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "package.sv"
import async_fifo_pkg::*;

`include "interface.sv"
`include "test.sv"

module async_fifo_tb;
 
  bit w_clk, r_clk, w_rst, r_rst;

  // Clock Generation
  initial w_clk = 0;
  initial r_clk = 0;
  always #10 w_clk = ~w_clk;
  always #15 r_clk = ~r_clk;

  // Reset Generation
  initial begin
    w_rst = 1;
    r_rst = 1;
    @(posedge w_clk) w_rst = 0;
    @(posedge r_clk) r_rst = 0;

    #100 w_rst = 1;
         r_rst = 1;
    
    #100 w_rst = 0;
         r_rst = 0;
  end

  async_fifo_intf #(DEPTH, WIDTH) vif(w_clk, r_clk);

  Asynchronous_fifo #(.DEPTH(DEPTH), .WIDTH(WIDTH)) dut (
    .w_clk(vif.w_clk),
    .r_clk(vif.r_clk),
    .w_rst(vif.w_rst),
    .r_rst(vif.r_rst),
    .w_en(vif.w_en),
    .r_en(vif.r_en),
    .data_in(vif.data_in),
    .data_out(vif.data_out),
    .full(vif.full),
    .empty(vif.empty)
  );

  initial begin
    uvm_config_db#(virtual async_fifo_intf#(DEPTH, WIDTH))::set(null, "*", "vintf", vif);
    run_test("async_fifo_test_simple");
  end

  initial begin
    $dumpfile("async_fifo.vcd");
    $dumpvars;
  end
endmodule



