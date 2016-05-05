class zmk_agent extends uvm_agent;
   zmk_driver drv;
   zmk_input_monitor mon;
   zmk_sequencer sqr;
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
      sqr = zmk_sequencer::type_id::create("sqr",this);
      uvm_config_db#(uvm_object_wrapper)::set(this,"sqr.main_phase","default_sequence",zmk_sequence_0::type_id::get());
   end
   mon = zmk_input_monitor::type_id::create("mon",this);
endfunction

function void zmk_agent::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   if (is_active == UVM_ACTIVE)
   begin
      drv.seq_item_port.connect(sqr.seq_item_export);
   end
   ap = mon.ap;
endfunction
