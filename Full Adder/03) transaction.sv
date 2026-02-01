// FULL ADDER - UVM TRANSACTION

`ifndef FA_TRANSACTION_SV
`define FA_TRANSACTION_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class fa_transaction extends uvm_sequence_item;
  parameter int N = 8;
  `uvm_object_utils(fa_transaction)
  
  rand bit [N-1:0]a;  
  rand bit [N-1:0]b;  
  rand bit [N-1:0]c;
  
  bit [N-1:0]sum;
  bit [N-1:0]carry;
  
  function new(string name = "fa_transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $sformatf("INPUT A = %d | B = %d | C = %d OUTPUT SUM = %d | CARRY = %d \n",a, b, c, sum, carry);
  endfunction
endclass

`endif
