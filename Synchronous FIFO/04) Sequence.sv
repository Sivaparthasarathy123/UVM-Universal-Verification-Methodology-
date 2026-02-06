// SYNCHRONOUS FIFO - UVM SEQUENCE
`ifndef SF_SEQUENCE_SV
`define SF_SEQUENCE_SV

import sync_fifo_pkg::*;

class sync_fifo_seq #(DEPTH = 8, WIDTH = 8) extends uvm_sequence #(sync_fifo_trans #(DEPTH, WIDTH));
  // Using param_utils for parameterized classes
  `uvm_object_param_utils(sync_fifo_seq #(DEPTH, WIDTH))
  
  function new(string name = "sync_fifo_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SEQ", "Starting FIFO Fill-then-Empty Sequence", UVM_LOW)

    // Write until Full
    for(int i=0; i < DEPTH; i++) begin
      `uvm_do_with(req, {req.w_en == 1; req.r_en == 0;}) 
    end

    // Read until Empty
    for(int i=0; i < DEPTH; i++) begin
      `uvm_do_with(req, {req.w_en == 0; req.r_en == 1;})
    end
    
    // Randomized Read/Write
    repeat(30) begin
      `uvm_do_with(req, {
        req.w_en dist {1 := 50, 0 := 50}; // 50% chance to write
        req.r_en dist {1 := 50, 0 := 50}; // 50% chance to read
    })
   end
  endtask
endclass

`endif
