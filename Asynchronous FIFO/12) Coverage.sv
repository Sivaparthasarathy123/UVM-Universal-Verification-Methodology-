// ASYNCHRONOUS FIFO - UVM COVERAGE
`ifndef ASF_COVERAGE_SV
`define ASF_COVERAGE_SV

class async_fifo_coverage #(DEPTH = 8, WIDTH = 8) extends uvm_subscriber #(async_fifo_trans#(DEPTH, WIDTH));
  `uvm_component_param_utils(async_fifo_coverage#(DEPTH, WIDTH))

  async_fifo_trans#(DEPTH, WIDTH) tr;

  covergroup async_fifo_cg;
    option.per_instance = 1;

    // Covering Write and Read Enables
    WRITE_CP: coverpoint tr.w_en;
    READ_CP:  coverpoint tr.r_en;
    
    //  Start and Intermediate Reset
    RESET: coverpoint tr.w_rst{
      bins Start_Reset = {1};
      bins No_Reset    = {0};
      bins Inter_reset = (0 => 1);
    }

    // Covering FIFO Flags 
    FULL_CP:  coverpoint tr.full {
      bins is_full  = {1};
      bins not_full = {0};
    }
    
    EMPTY_CP: coverpoint tr.empty {
      bins is_empty  = {1};
      bins not_empty = {0};
    }

    // Data Patterns 
    DATA_CP: coverpoint tr.data_in {
      bins all_zeros = {0};
      bins all_ones  = { (1 << WIDTH) - 1 };
      bins others    = default;
    }

    // Cross Coverage 
    X_WRITE_FULL:  cross WRITE_CP, FULL_CP;
    X_READ_EMPTY:  cross READ_CP, EMPTY_CP;
    
    // Simultaneous Read and Write 
    X_RW: cross WRITE_CP, READ_CP;

  endgroup

  function new(string name = "async_fifo_coverage", uvm_component parent = null);
    super.new(name, parent);
    async_fifo_cg = new(); 
  endfunction

  virtual function void write(async_fifo_trans#(DEPTH, WIDTH) t);
    this.tr = t;
    async_fifo_cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COVERAGE", $sformatf("FIFO Coverage: %0.2f%%", async_fifo_cg.get_inst_coverage()), UVM_LOW)
  endfunction
endclass

`endif
