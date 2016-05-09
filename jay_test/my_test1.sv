class my_test1 extends base_test;
   string my_name = "my_test1";
   function new(string name="my_test1",uvm_component parent=null);
      super.new(name,parent);
   endfunction
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      set_report_max_quit_count(2);
   endfunction 
   virtual function void report_phase(uvm_phase phase,string test_name=my_name);
      super.report_phase(phase,test_name);
   endfunction
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      env.i_agt.drv.set_report_severity_override(UVM_INFO,UVM_WARNING);
   endfunction
      `uvm_component_utils(my_test1);

endclass
