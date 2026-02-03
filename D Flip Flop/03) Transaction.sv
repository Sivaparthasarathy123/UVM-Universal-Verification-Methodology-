// D FLIP FLOP - UVM TRANSACTION

`ifndef D_TRANSACTION_SV
`define D_TRANSACTION_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class d_transaction extends uvm_sequence_item;
  `uvm_object_utils(d_transaction)
  
  rand bit d;
  rand bit rst;
  bit q;
  
  function new (string name = "d_transaction");
    super.new(name);
  endfunction
  
  function string display();
    return $sformatf("INPUT Reset = %0b | D = %0b OUTPUT Q = %b \n", rst, d, q);
  endfunction
  
endclass
  
`endif
