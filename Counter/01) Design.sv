// UVM UP DOWN COUNTER
module nbit_updown_modn_counter #(
  parameter N = 4  
)(
  input clk,       
  input rst,       
  input up_down,   
  output reg [N-1:0] count
);

  localparam MAX = (2**N) - 1; 

  always @(posedge clk) begin
    if (rst) begin
      count <= 0;
    end
    else begin
      if (up_down) begin
        if (count == MAX)
          count <= 0;    
        else
          count <= count + 1;
      end
      else begin
        if (count == 0)
          count <= MAX;  
        else
          count <= count - 1;
      end
    end
  end

endmodule

// https://edaplayground.com/x/iLpM
