class zmk_driver extends uvm_driver;
   virtual zmk_if v_zmk_if;
   `uvm_component_utils(zmk_driver);
   function new(string name = "zmk_driver", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("zmk_driver","build phase start",UVM_LOW);
      if(!uvm_config_db#(virtual zmk_if)::get(this,"","vif",v_zmk_if))
         `uvm_fatal("zmk_driver","virtual interface must be set for zmk_driver");
   endfunction

   extern virtual task main_phase(uvm_phase phase);
endclass



task zmk_driver::main_phase(uvm_phase phase);
   phase.raise_objection(this);
   `uvm_info("zmk_driver","main phase start",UVM_LOW);
   v_zmk_if.write_select <=8'b0;
   v_zmk_if.w_data <=32'b0;
   `uvm_info("zmk_driver","wait for ipg_clk",UVM_LOW);
   repeat(2) @(posedge v_zmk_if.ipg_clk);
   `uvm_info("zmk_driver","get ipg_clk ",UVM_LOW);
   for(int i =0; i < 8; i++)
   begin
      @(posedge v_zmk_if.ipg_clk);
      v_zmk_if.write_select <= 1<<i;
      v_zmk_if.w_data <= $urandom_range(0,32'hffffffff);
      `uvm_info("zmk_driver","write zmk", UVM_LOW);
      $display("write_select: %b  w_data: %x",v_zmk_if.write_select,v_zmk_if.w_data);
   end
   @(posedge v_zmk_if.ipg_clk);
   v_zmk_if.write_select <= 8'b0;
   phase.drop_objection(this);
endtask
