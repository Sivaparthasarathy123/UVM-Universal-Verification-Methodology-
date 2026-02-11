// Asynchronous FIFO - DESIGN 
module Asynchronous_fifo #(parameter DEPTH = 8, WIDTH = 8)(
    input w_clk, r_clk,
    input w_rst, r_rst,
    input w_en, r_en,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output full, empty);
  
    localparam addr = $clog2(DEPTH); 
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    reg [addr:0] w_ptr_bin, w_ptr_gray;
    reg [addr:0] r_ptr_bin, r_ptr_gray;

    // WRITE POINTER DOMAIN 
    always @(posedge w_clk or posedge w_rst) begin
        if (w_rst) begin
            w_ptr_bin  <= 0;
            w_ptr_gray <= 0;
        end else if (w_en && !full) begin
            w_ptr_bin  <= w_ptr_bin + 1;
            w_ptr_gray <= ((w_ptr_bin + 1) >> 1) ^ (w_ptr_bin + 1);
            mem[w_ptr_bin[addr-1:0]] <= data_in;
        end
    end

    // READ POINTER DOMAIN 
    always @(posedge r_clk or posedge r_rst) begin
        if (r_rst) begin
            r_ptr_bin  <= 0;
            r_ptr_gray <= 0;
            data_out   <= 0;
        end else if (r_en && !empty) begin
            r_ptr_bin  <= r_ptr_bin + 1;
            r_ptr_gray <= ((r_ptr_bin + 1) >> 1) ^ (r_ptr_bin + 1);
            data_out   <= mem[r_ptr_bin[addr-1:0]];
        end
    end

    // SYNCHRONIZERS 
    reg [addr:0] rd_ptr_s1, rd_ptr_s2;
    reg [addr:0] wr_ptr_s1, wr_ptr_s2;

    // Read to Write Domain Sync
    always @(posedge w_clk or posedge w_rst) begin
        if (w_rst) {rd_ptr_s2, rd_ptr_s1} <= 0;
        else       {rd_ptr_s2, rd_ptr_s1} <= {rd_ptr_s1, r_ptr_gray};
    end

    // Write to Read Domain Sync
    always @(posedge r_clk or posedge r_rst) begin
        if (r_rst) {wr_ptr_s2, wr_ptr_s1} <= 0;
        else       {wr_ptr_s2, wr_ptr_s1} <= {wr_ptr_s1, w_ptr_gray};
    end

    // FULL & EMPTY
    assign empty = (r_ptr_gray == wr_ptr_s2);
    
    assign full  = (w_ptr_gray == {~rd_ptr_s2[addr:addr-1], rd_ptr_s2[addr-2:0]});

endmodule
