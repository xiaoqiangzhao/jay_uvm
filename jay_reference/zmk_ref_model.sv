class zmk_ref_model extends uvm_component;
   uvm_blocking_get_port #(zmk_transaction) port;
   uvm_analysis_port #(zmk_transaction) ap;

   function new(string name = "zmk_ref_model",uvm_component parent);
      super.new(name,parent);
   endfunction
   extern function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
   `uvm_component_utils(zmk_ref_model);
endclass

function void zmk_ref_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   port = new("port",this);
   ap = new("ap",this);
endfunction

task zmk_ref_model::main_phase(uvm_phase phase);
   zmk_transaction tr;
   super.main_phase(phase);
   while(1)
   begin
      port.get(tr);
      `uvm_info("zmk_ref_model","get one transaction",UVM_LOW);
      tr.print();
      ap.write(tr);
   end
endtask
