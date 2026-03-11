`ifndef COUNTER_COVERAGE
`define COUNTER_COVERAGE
class counter_coverage extends uvm_subscriber #(counter_seq_item);

  `uvm_component_utils(counter_coverage)

  covergroup cov with function sample(counter_seq_item t);
    option.per_instance = 1;

    cp_rst: coverpoint t.rst;
    cp_mode: coverpoint t.up_down;
    cp_count: coverpoint t.count {
      bins boundaries[] = {0, (2**N)-1};
      bins others = default;
    }

    cross cp_mode, cp_count {
      bins up_bounds =
      binsof(cp_mode) intersect {1} &&
      binsof(cp_count.boundaries);

      bins down_bounds =
      binsof(cp_mode) intersect {0} &&
      binsof(cp_count.boundaries);
    }
  endgroup

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    cov = new();  
  endfunction

  virtual function void write(counter_seq_item t);
    cov.sample(t); 
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("COV",$sformatf("Total Coverage: %0.2f%%", cov.get_coverage()),UVM_LOW)
  endfunction

endclass

`endif
