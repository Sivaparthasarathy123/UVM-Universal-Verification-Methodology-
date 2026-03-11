// UP DOWN COUNTER - PACKAGE
`ifndef COUNTER_PACKAGE
`define COUNTER_PACKAGE

package counter_pkg;
parameter N = 8;

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "sequence_item.sv"
`include "sequence.sv"

`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"

`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"

`include "test.sv"

endpackage

`endif
