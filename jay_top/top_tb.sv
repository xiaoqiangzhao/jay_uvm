`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "zmk_driver.sv"
module top_tb;

reg ipg_clk;
reg reset;
reg soft_reset;
reg [7:0] write_lpzmk;
reg [31:0] lp_wdata;
reg [255:0] lpzmk_reg;

snvs_lp_zmk dut_snvs_lp_zmk(
   .ipg_clk(ipg_clk),
   .zmk_reset(reset),
   .zmk_soft_reset(soft_reset),
   .write_lpzmk(write_lpzmk),
   .lp_wdata(lp_wdata),
   .lpzmk_reg(lpzmk_reg)
);

initial begin
   zmk_driver drv;
   `uvm_info("top","before test",UVM_LOW);
   #1;
   drv = new("drv",null);
   drv.main_phase(null);
   `uvm_info("top","after test",UVM_LOW);
   $finish();
end


initial begin
   ipg_clk = 0;
   forever begin
      #100 ipg_clk =~ipg_clk;
   end
end
endmodule
