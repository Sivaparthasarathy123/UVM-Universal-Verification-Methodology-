// SINGLE PORT RAM - UVM SCOREBOARD
`ifndef SRAM_SCOREBOARD_SV
`define SRAM_SCOREBOARD_SV

`include "transaction.sv"

class sram_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(sram_scoreboard)
  
  parameter DEPTH = 8;
  parameter WIDTH = 8;
  
  bit [WIDTH-1:0] local_mem [DEPTH];
  bit [WIDTH-1:0] expected;
  
  uvm_analysis_imp #(sram_trans, sram_scoreboard) analysis_export; 
  
  int total_trans;
  int mismatch_count;

  function new(string name = "sram_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    total_trans    = 0;
    mismatch_count = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
  endfunction
  
  virtual function void write(sram_trans tr);
    total_trans++;
    
         // expected OLD value
        expected = local_mem[tr.addr];

        // Writing the Data
        if(tr.w_en) begin
            local_mem[tr.addr] = tr.data_in;
          `uvm_info("[SCB_WRITE]",$sformatf("Write %0h to Addr %0d", tr.data_in, tr.addr),UVM_LOW)
        end

        // comparing expected data with Actual data
        if(expected === tr.data_out)
          `uvm_info("[SCB_READ]",$sformatf("PASS! Read %0h from Addr %0d", tr.data_out, tr.addr),UVM_LOW)
        else
          `uvm_warning("[SCB_EXP]",$sformatf("FAIL! Expected %0h, Got %0h", expected, tr.data_out))
         
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SB_REPORT", $sformatf("Total Trans: %0d | Mismatches: %0d", total_trans, mismatch_count), UVM_LOW)
  endfunction

endclass

`endif
