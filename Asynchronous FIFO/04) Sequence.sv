// ASYNCHRONOUS FIFO - UVM SEQUENCE
`ifndef ASF_SEQUENCE_SV
`define ASF_SEQUENCE_SV

// WRITE SEQUENCE 
class async_fifo_write_seq #(DEPTH = 8, WIDTH = 8) extends uvm_sequence #(async_fifo_trans #(DEPTH, WIDTH));
  `uvm_object_param_utils(async_fifo_write_seq #(DEPTH, WIDTH))
  
  function new(string name = "async_fifo_write_seq");
    super.new(name);
  endfunction

  task body();
    // Write until FIFO is full
    `uvm_info("SEQ_WRITE", "Starting FIFO Fill Sequence", UVM_LOW)

    for (int i = 0; i < DEPTH+1; i++) begin
      `uvm_do_with(req, {
        req.w_en == 1;
        req.w_rst == 0; 
        req.r_rst == 0; 
    })
    end
   
  endtask
endclass

// READ SEQUENCE 
class async_fifo_read_seq #(DEPTH = 8, WIDTH = 8) extends uvm_sequence #(async_fifo_trans #(DEPTH, WIDTH));
  `uvm_object_param_utils(async_fifo_read_seq #(DEPTH, WIDTH))
  
  function new(string name = "async_fifo_read_seq");
    super.new(name);
  endfunction

  task body();
    // read until Empty
    `uvm_info("SEQ_READ", "Starting FIFO Empty Sequence", UVM_LOW)
    for (int i = 0; i < DEPTH; i++) begin
     `uvm_do_with(req, {
        req.r_en == 1;
        req.w_rst == 0; 
        req.r_rst == 0; 
    })
    end
   
  endtask
endclass

// COMBINED SEQUENCE 
class async_fifo_seq #(DEPTH = 8, WIDTH = 8) extends uvm_sequence #(async_fifo_trans #(DEPTH, WIDTH));
  `uvm_object_param_utils(async_fifo_seq #(DEPTH, WIDTH))

  async_fifo_write_seq #(DEPTH, WIDTH) wseq;
  async_fifo_read_seq  #(DEPTH, WIDTH) rseq;

  function new(string name = "async_fifo_seq");
    super.new(name);
  endfunction

  task body();
    wseq = async_fifo_write_seq#(DEPTH, WIDTH)::type_id::create("wseq");
    rseq = async_fifo_read_seq#(DEPTH, WIDTH)::type_id::create("rseq");
    
    `uvm_info("SEQ_MAIN", "Starting Write Operations", UVM_LOW)
       wseq.start(m_sequencer);
    

    `uvm_info("SEQ_MAIN", "Starting Parallel Read & Write Operations", UVM_LOW)
    
    fork
      wseq.start(m_sequencer);
      rseq.start(m_sequencer);
    join
  endtask
endclass

`endif
