class zmk_env extends uvm_env;
   //zmk_driver drv;
   zmk_monitor out_monitor;
   zmk_agent i_agt;
   uvm_tlm_analysis_fifo #(zmk_transaction) agt_mdl_fifo;
   zmk_ref_model ref_model;
   //zmk_input_monitor input_monitor;
   function new(string name = "zmk_env",uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = zmk_agent::type_id::create("i_agt",this);
      ref_model = zmk_ref_model::type_id::create("ref_model",this);
      //drv = zmk_driver::type_id::create("drv",this);
      out_monitor = zmk_monitor::type_id::create("out_monitor",this);
      //input_monitor = zmk_input_monitor::type_id::create("input_monitor",this);
      i_agt.is_active = UVM_ACTIVE;
      agt_mdl_fifo = new("agt_mdl_fifo",this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      i_agt.ap.connect(agt_mdl_fifo.analysis_export);
      ref_model.port.connect(agt_mdl_fifo.blocking_get_export);
   endfunction

   `uvm_component_utils(zmk_env);
endclass
