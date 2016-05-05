`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "zmk_transaction.sv"
`include "zmk_driver.sv"
`include "zmk_monitor.sv"
`include "zmk_sequencer.sv"
`include "zmk_sequence_0.sv"
`include "zmk_input_monitor.sv"
`include "zmk_agent.sv"
`include "zmk_ref_model.sv"
`include "zmk_scoreboard.sv"
`include "zmk_env.sv"
module top_tb;


reg ipg_clk;
reg reset;
reg soft_reset;
//reg [7:0] write_lpzmk;
//reg [31:0] lp_wdata;
//reg [255:0] lpzmk_reg;

zmk_if input_if(ipg_clk,reset,soft_reset);
zmk_if output_if(ipg_clk,reset,soft_reset);

snvs_lp_zmk dut_snvs_lp_zmk(
   .ipg_clk(ipg_clk),
   .zmk_reset(reset),
   .zmk_soft_reset(soft_reset),
   .write_lpzmk(input_if.write_select),
   .lp_wdata(input_if.w_data),
   .lpzmk_reg(output_if.reg_data)
);

initial begin
   run_test("zmk_env");
end

initial begin
   uvm_config_db#(virtual zmk_if)::set(null,"uvm_test_top.i_agt.drv","vif",input_if);
   uvm_config_db#(virtual zmk_if)::set(null,"uvm_test_top.i_agt.mon","vif",input_if);
   uvm_config_db#(virtual zmk_if)::set(null,"uvm_test_top.out_monitor","vif",output_if);
end

initial begin
   ipg_clk = 0;
   forever begin
      #100 ipg_clk =~ipg_clk;
   end
end
initial begin
   reset =1;
   soft_reset =1;
   repeat(2) @(posedge ipg_clk);
   reset =0;
   repeat(2) @(posedge ipg_clk);
   soft_reset =0;
end
endmodule
