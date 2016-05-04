class zmk_monitor extends uvm_monitor;
   virtual zmk_if v_zmk_if;
   uvm_analysis_port #(zmk_transaction) ap;
   `uvm_component_utils(zmk_monitor);
   function new(string name = "zmk_monitor", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ap = new ("ap",this);
      if(!uvm_config_db#(virtual zmk_if)::get(this,"","vif",v_zmk_if))
         `uvm_fatal("zmk_monitor","virtual interface must be set for zmk_monitor");
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(zmk_transaction tr);

endclass

task zmk_monitor::main_phase(uvm_phase phase);
   zmk_transaction tr;
   while(1)
   begin
      tr = new("tr");
      collect_one_pkt(tr);
      ap.write(tr);
   end
endtask

task zmk_monitor::collect_one_pkt(zmk_transaction tr);
   @(posedge v_zmk_if.ipg_clk);
   tr.zmk_key <= v_zmk_if.reg_data; 
   $display("collect zmk_key %x",v_zmk_if.reg_data);
endtask
