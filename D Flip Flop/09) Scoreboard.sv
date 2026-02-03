// D FLIP FLOP - UVM SCOREBOARD

`ifndef D_SCOREBOARD_SV
`define D_SCOREBOARD_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"

class d_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(d_scoreboard)

  uvm_analysis_imp #(d_transaction, d_scoreboard) analysis_export;

  int total_trans;
  int mismatch_count;

  bit exp_q;   // expected Q 

  function new(string name = "d_scoreboard", uvm_component parent = null);
    super.new(name,parent);
    total_trans     = 0;
    mismatch_count  = 0;
    exp_q           = 0;   
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
  endfunction

  function void write(d_transaction trans);

    bit next_exp_q;

    total_trans++;

    // Reference D-FF model
    if (trans.rst) begin
      next_exp_q = 0;
    end
    else begin
      next_exp_q = trans.d;
    end

    // Comparing Actual and Expected
    if (trans.q !== next_exp_q) begin
      mismatch_count++;
      `uvm_error("SCOREBOARD",$sformatf("MISMATCH | Reset = %0b D = %0b | EXP_Q = %0b ACT_Q = %0b",trans.rst, trans.d, next_exp_q, trans.q))
    end
    else begin
      `uvm_info("SCOREBOARD",$sformatf("PASS | Reset = %0b D = %0b | Q = %0b",trans.rst, trans.d, trans.q),UVM_LOW)
    end

    // Updateing stored state
    exp_q = next_exp_q;

  endfunction

  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("SCOREBOARD",$sformatf("SUMMARY: Total = %0d Passed = %0d Failed = %0d",total_trans,
        total_trans - mismatch_count,mismatch_count),UVM_LOW)
  endfunction

endclass

`endif
