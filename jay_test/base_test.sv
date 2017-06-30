class base_test extends uvm_test;
   zmk_env env;
   string my_name = "base_test";
   function new(string name = "base_test",uvm_component parent = null);
      super.new(name,parent);
   endfunction

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern virtual function void phase_started(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      check_config_usage();
      print_config(1);
   endfunction
      `uvm_component_utils(base_test);
endclass

function void base_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
   env = zmk_env::type_id::create("env",this);
   uvm_config_db#(uvm_object_wrapper)::set(this,"env.i_agt.sqr.main_phase","default_sequence",zmk_sequence_0::type_id::get());
endfunction

function void base_test::phase_started(uvm_phase phase);
`uvm_info("phase_started",$sformatf("current phase name is %s",phase.get_name()),UVM_LOW);
   if(phase.get_name() == "main") begin
      `uvm_info("BASE_TEST","Before Main Phase",UVM_LOW);
   end
endfunction

function void base_test::report_phase(uvm_phase phase);
   uvm_report_server server;
   int error_num;
   super.report_phase(phase);
   server = get_report_server();
   error_num = server.get_severity_count(UVM_ERROR);
   if(error_num )
   begin
      $display("%s Failed",this.my_name);
   end
   else begin
      $display("%s Passed",this.my_name);
   end
endfunction

task base_test::main_phase(uvm_phase phase);
   super.main_phase(phase);
   //phase_started(phase);   // no need to call
   phase.raise_objection(this);
   #20000;
   phase.drop_objection(this);
endtask
