interface zmk_if(input ipg_clk,input reset,input soft_reset);
   logic [7:0] write_select;
   logic [31:0] w_data;
   logic [255:0] reg_data;
endinterface
