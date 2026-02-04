// SINGLE PORT RAM - UVM COVERAGE
`ifndef SRAM_COVERAGE_SV
`define SRAM_COVERAGE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"

class sram_coverage extends uvm_subscriber #(sram_trans);
  `uvm_component_utils(sram_coverage)

  sram_trans tr;

  // Define the Covergroup
  covergroup sram_cg;
    option.per_instance = 1;
    option.name = "SRAM_Coverage";

    // Address Coverage 
    ADDR_CP: coverpoint tr.addr {
      bins b_addr[] = {[0:7]};
    }

    // Operation Coverage 
    OP_CP: coverpoint tr.w_en {
      bins write = {1};
      bins read  = {0};
    }

    // Data Coverage 
    DATA_CP: coverpoint tr.data_in {
      bins zeros = {8'h00};
      bins ones  = {8'hFF};
      bins others = {[8'h01:8'hFE]};
    }

    // Cross Coverage
    X_ADDR_OP: cross ADDR_CP, OP_CP;
  endgroup

  function new(string name = "sram_coverage", uvm_component parent = null);
    super.new(name, parent);
    sram_cg = new();
  endfunction

  // Analysis port connection
  virtual function void write(sram_trans t);
    this.tr = t;
    sram_cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
      `uvm_info("COV_STATS", $sformatf("-------------------------------------------"), UVM_LOW)
      `uvm_info("COV_STATS", $sformatf("SRAM Functional Coverage: %0.2f%%", sram_cg.get_inst_coverage()), UVM_LOW)
      `uvm_info("COV_STATS", $sformatf("-------------------------------------------"), UVM_LOW)
  endfunction
  
endclass

`endif
