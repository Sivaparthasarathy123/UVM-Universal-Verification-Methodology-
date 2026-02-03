// D FLIP FLOP - UVM DESIGN
module D_flip_flop(
  D_ff.DUT intf
);
  always @(posedge intf.clk or posedge intf.rst) begin
    if (intf.rst) 
      intf.q <= 0;
    else
      intf.q <= intf.d;
  end
  
endmodule
