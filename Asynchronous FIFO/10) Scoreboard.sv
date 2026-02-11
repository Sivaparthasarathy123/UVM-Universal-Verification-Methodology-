`ifndef ASF_SCOREBOARD_SV
`define ASF_SCOREBOARD_SV

`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class async_fifo_scoreboard #(DEPTH = 8, WIDTH = 8) extends uvm_scoreboard;

  `uvm_component_param_utils(async_fifo_scoreboard #(DEPTH, WIDTH))
  
  typedef async_fifo_scoreboard #(DEPTH, WIDTH) this_type;
  typedef async_fifo_trans #(DEPTH, WIDTH) async_fifo_tr_t;

  uvm_analysis_imp_wr #(async_fifo_tr_t, this_type) write_imp;
  uvm_analysis_imp_rd #(async_fifo_tr_t, this_type) read_imp;

  logic [WIDTH-1:0] fifo_queue[$];
  logic [WIDTH-1:0] expected_data;

  function new(string name, uvm_component parent);
    super.new(name, parent);

    // Bind the analysis imports
    write_imp = new("write_imp", this);
    read_imp  = new("read_imp",  this);
  endfunction

  // ================= WRITE SIDE =================
  virtual function void write_wr(async_fifo_tr_t tr);
    // Reset handling
    if (tr.w_rst || tr.r_rst) begin
      fifo_queue.delete();
      `uvm_info("SCB_RST", "Scoreboard queue flushed due to reset", UVM_MEDIUM)
     // return;
    end

    // Normal write
    if (tr.w_en && !tr.full) begin
      fifo_queue.push_back(tr.data_in);
      `uvm_info("SCB_WRITE", $sformatf("WRITE: %h | Q size=%0d", tr.data_in, fifo_queue.size()), UVM_LOW)
    end
  endfunction

  // ================= READ SIDE =================
  virtual function void write_rd(async_fifo_tr_t tr);
    // Only process read if FIFO is not empty
    if (tr.r_en && !tr.empty) begin
      if (fifo_queue.size() == 0) begin
        `uvm_error("SCB_UNDERFLOW", "Read occurred when Scoreboard queue is empty")
        return;
      end

      expected_data = fifo_queue.pop_front();

      if (tr.data_out === expected_data)
        `uvm_info("SCB_PASS", $sformatf("MATCH exp=%h got=%h", expected_data, tr.data_out), UVM_LOW)
      else
        `uvm_error("SCB_FAIL", $sformatf("MISMATCH exp=%h got=%h", expected_data, tr.data_out))
    end
  endfunction

endclass

`endif
