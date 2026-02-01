// FULL ADDER - UVM SCOREBOARD

`ifndef FA_SCOREBOARD_SV
`define FA_SCOREBOARD_SV

`include "transaction.sv"

class fa_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fa_scoreboard)

  uvm_analysis_imp #(fa_transaction, fa_scoreboard) analysis_export;

  int total_trans;       
  int mismatch_count;    
  localparam int N = 8; 

  function new(string name="fa_scoreboard", uvm_component parent=null);
    super.new(name,parent);
    total_trans = 0;
    mismatch_count = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
  endfunction

  // This is called whenever a transaction is written from monitor
  function void write(fa_transaction trans);
   
     bit [N-1:0] exp_sum;
     bit [N-1:0] exp_carry;


    // Calculate expected results
    {exp_carry, exp_sum} = trans.a + trans.b + trans.c;

    total_trans++;

    if(trans.sum !== exp_sum || trans.carry !== exp_carry) begin
      mismatch_count++;
      `uvm_error("SCOREBOARD", $sformatf(
        "MISMATCH! Input: a=%0b b=%0b c=%0b | Expected: sum=%0b carry=%0b | Actual: sum=%0b carry=%0b",
        trans.a, trans.b, trans.c, exp_sum, exp_carry, trans.sum, trans.carry
      ))
    end else begin
      `uvm_info("SCOREBOARD", $sformatf(
        "PASS! Input: a=%0b b=%0b c=%0b | Output: sum=%0b carry=%0b",
        trans.a, trans.b, trans.c, trans.sum, trans.carry
      ), UVM_LOW)
    end
  endfunction


function void final_phase(uvm_phase phase);
  super.final_phase(phase);
  `uvm_info("SCOREBOARD", $sformatf(
    "Total Transactions = %0d, Mismatches = %0d, Passed = %0d",
    total_trans, mismatch_count, total_trans - mismatch_count
  ), UVM_LOW)
endfunction

endclass

`endif
