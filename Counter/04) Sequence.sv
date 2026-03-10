// UP DOWN COUNTER - UVM SEQUENCE
`ifndef COUNTER_SEQUENCE
`define COUNTER_SEQUENCE

class counter_sequence extends uvm_sequence #(counter_seq_item));

  `uvm_object_utils(counter_sequence)
  
  function new(string name = "counter_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SEQ", "------- COUNTER STARTED -------", UVM_LOW)
    
    // Randomized Reset and Up Down Enable
    repeat(30) begin
      `uvm_do_with(req, {
        req.rst dist {1 := 50, 0 := 50}; // 50% chance for Reset
        req.up_down dist {1 := 50, 0 := 50}; // 50% chance for Up_Down Enable
    })
   end
  endtask
endclass

`endif
