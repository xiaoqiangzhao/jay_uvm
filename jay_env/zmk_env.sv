class zmk_env extends uvm_env;
   zmk_driver drv;
   function new(string name = "zmk_env",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      drv = zmk_driver::type_id::create("drv",this);
   endfunction
   `uvm_component_utils(zmk_env);
endclass
