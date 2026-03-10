// UP DOWN COUNTER - UVM SEQUENCE ITEM
`ifndef COUNTER_SEQUENCE_ITEM
`define COUNTER_SEQUENCE_ITEM

class counter_seq_item extends uvm_sequence_item;
  
  rand bit rst;
  rand bit up_down;
  bit [N-1:0] count;
  
  `uvm_object_utils_begin(counter_seq_item)
    `uvm_field_int(rst,       UVM_ALL_ON)
    `uvm_field_int(up_down,   UVM_ALL_ON)
    `uvm_field_int(count,     UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

  function new(string name = "counter_seq_item");
    super.new(name);
  endfunction
endclass

`endif
     
