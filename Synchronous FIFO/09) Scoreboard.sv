// SYNCHRONOUS FIFO - UVM SCOREBOARD
`ifndef SF_SCOREBOARD_SV
`define SF_SCOREBOARD_SV

import sync_fifo_pkg::*;

class sync_fifo_scoreboard #(DEPTH = 8, WIDTH = 8) extends uvm_scoreboard;
  `uvm_component_param_utils(sync_fifo_scoreboard#(DEPTH, WIDTH))

  uvm_analysis_imp #(sync_fifo_trans#(DEPTH, WIDTH), sync_fifo_scoreboard#(DEPTH, WIDTH)) item_got;
  
  logic [WIDTH-1:0] fifo_queue[$];
  logic [WIDTH-1:0] expected_data_to_compare;
  bit expect_read_data = 0; 

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_got = new("item_got", this);
  endfunction

  virtual function void write(sync_fifo_trans#(DEPTH, WIDTH) tr);
    
    // Reset
    if (tr.rst) begin
      `uvm_info("SCB_RST", "Reset detected. Flushing Scoreboard Queue.", UVM_MEDIUM)
      fifo_queue.delete();
      expect_read_data = 0;
      return;
    end

    // Compare 
    if (expect_read_data) begin
      if (tr.data_out === expected_data_to_compare) begin
        `uvm_info("SCB_PASS", $sformatf("MATCH! Got: %h | Exp: %h", tr.data_out, expected_data_to_compare), UVM_LOW)
      end else begin
        `uvm_error("SCB_FAIL", $sformatf("MISMATCH! Got: %h | Exp: %h", tr.data_out, expected_data_to_compare))
      end
      expect_read_data = 0; 
    end

    // Read
    if (tr.r_en && !tr.empty) begin
      if (fifo_queue.size() > 0) begin
        expected_data_to_compare = fifo_queue.pop_front();
        expect_read_data = 1; 
      end 
      else begin
       `uvm_info("SCB_EMPTY_READ",$sformatf( "Read occured but Scoreboard Queue is empty"),UVM_LOW)
       end
    end

    // Write
    if (tr.w_en && !tr.full) begin
      fifo_queue.push_back(tr.data_in);
      `uvm_info("SCB_WRITE", $sformatf("Stored: %h | Queue Size: %0d", tr.data_in, fifo_queue.size()), UVM_LOW)
    end

  endfunction
endclass

`endif
