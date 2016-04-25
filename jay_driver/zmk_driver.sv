class zmk_driver extends uvm_driver;
   function new(string name = "zmk_driver", uvm_component parent = null);
      super.new(name,parent);
   endfunction
   extern virtual task main_phase(uvm_phase phase);
endclass

task zmk_driver::main_phase(uvm_phase phase);
   top_tb.reset <=1'b0;
   top_tb.soft_reset <=1'b0;
   top_tb.write_lpzmk <=8'b0;
   top_tb.lp_wdata <=32'b0;
   repeat(2) @(posedge top_tb.ipg_clk);
   top_tb.reset <=1'b1;
   top_tb.soft_reset <=1'b1;
   repeat(2) @(posedge top_tb.ipg_clk);
   for(int i =0; i < 8; i++)
   begin
      @(posedge top_tb.ipg_clk);
      top_tb.write_lpzmk <= 1<<i;
      top_tb.lp_wdata <= $urandom_range(0,2^32);
      `uvm_info("zmk_driver","write zmk", UVM_LOW);
   end
   @(posedge top_tb.ipg_clk);
   top_tb.write_lpzmk <= 8'b0;

endtask
