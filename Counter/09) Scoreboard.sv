`ifndef COUNTER_SCOREBOARD
`define COUNTER_SCOREBOARD

class counter_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(counter_scoreboard)

  // Analysis port to receive transactions from monitor
  uvm_analysis_imp #(counter_seq_item, counter_scoreboard) item_got;

  // count variables
  logic [N-1:0] expected_count;
  int actual;
  int match_count;
  int mismatch_count;

  localparam MAX = (2**N) - 1;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_got = new("item_got", this);
    match_count = 0;
    mismatch_count = 0;
    expected_count = 0;
  endfunction

  virtual function void write(counter_seq_item tr);

    actual = tr.count;

    if (tr.rst) begin
      expected_count = 0;
      actual = 0;
      `uvm_info("SCB_RST", "Reset detected - expected count = 0", UVM_MEDIUM)
    end

    if (actual === expected_count) begin
      match_count++;
      `uvm_info("SCB_PASS",$sformatf("MATCH -> Actual = %0d Expected = %0d\n",actual, expected_count),UVM_LOW)
    end
    else begin
      mismatch_count++;
      `uvm_error("SCB_FAIL",$sformatf("MISMATCH -> Actual = %0d Expected = %0d\n",actual, expected_count))
    end

    if (tr.rst) begin
      expected_count = 0;
    end
    else begin
      if (tr.up_down) begin
        if (expected_count == MAX)
          expected_count = 0;
        else
          expected_count++;
      end
      else begin
        if (expected_count == 0)
          expected_count = MAX;
        else
          expected_count--;
      end
    end

  endfunction

  // Report Phase
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("SCB_SUMMARY", $sformatf("Scoreboard Summary -> Matches = %0d, Mismatches = %0d", match_count, mismatch_count), UVM_MEDIUM)
  endfunction

endclass

`endif
