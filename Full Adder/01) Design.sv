// FULL ADDER - UVM DESIGN
module Fulladder #(parameter N = 8)(
  FA_intf.DUT intf
);
  
  assign {intf.carry, intf.sum} = intf.a + intf.b + intf.c;
  
endmodule
