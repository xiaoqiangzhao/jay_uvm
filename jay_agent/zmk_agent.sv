class zmk_agent extends uvm_agent;
   zmk_driver drv;
   zmk_input_monitor mon;
   uvm_analysis_port #(zmk_transaction) ap;
   function new(string name="zmk_agent",uvm_component parent);
      super.new(name,parent);
   endfunction

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   `uvm_component_utils(zmk_agent);

endclass

function void zmk_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if (is_active == UVM_ACTIVE)
   begin
      drv = zmk_driver::type_id::create("drv",this);
   end
   mon = zmk_input_monitor::type_id::create("mon",this);
endfunction

function void zmk_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   ap = mon.ap;
endfunction
