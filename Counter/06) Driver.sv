// UP DOWN COUNTER - UVM DRIVER
`ifndef COUNTER_DRIVER
`define COUNTER_DRIVER

class counter_driver extends uvm_driver #(counter_seq_item);
  `uvm_component_utils(counter_driver)

  // Virtual Interface
  virtual counter_intf#(N) vintf;

  // Registered and using parent functionalities
  function new(string name = "counter_driver" , uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Constructing Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual counter_intf#(N))::get(this,"","vintf",vintf))
      `uvm_fatal("NO_VINTF","Virtual Interface not found in Driver")
  endfunction

  // Using Virtual task
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      driver(req);
      seq_item_port.item_done;
    end
  endtask

  virtual task driver(counter_seq_item tr);
    @(vintf.drv);
    vintf.drv.rst    <= tr.rst;
    vintf.drv.up_down    <= tr.up_down;

    // Using .sprint() to uses the utility macros
    // `uvm_info("DRIVER", $sformatf("Driving Transaction:\n%s", tr.sprint()), UVM_LOW)
    `uvm_info("DRIVER", $sformatf("Driving Transaction: Time = %0t | rst = %0b | up_down = %0b",$time,tr.rst,tr.up_down), UVM_LOW)
  endtask

endclass
`endif
