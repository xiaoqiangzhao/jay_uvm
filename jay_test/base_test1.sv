class zmk_sequence_1 extends uvm_sequence #(zmk_transaction);
   zmk_transaction tr_1;
   function new(string name = "my_sequence");
      super.new(name);
   endfunction

   virtual task body();
      if(starting_phase !=null)
      begin
         starting_phase.raise_objection(this);
      repeat (15) begin
         `uvm_do_with(tr_1,{tr_1.zmk_key[31:0]==32'h0;})
      end
      #1000;
         starting_phase.drop_objection(this);
      end
   endtask
   `uvm_object_utils(zmk_sequence_1);
endclass

class base_test1 extends uvm_test;
   zmk_env env;
   string my_name = "base_test1";
   function new(string name = "base_test1",uvm_component parent = null);
      super.new(name,parent);
   endfunction

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   virtual function void connect_phase(uvm_phase phase);
      env.i_agt.drv.set_report_severity_override(UVM_INFO,UVM_WARNING);
   endfunction
      `uvm_component_utils(base_test1);
endclass

function void base_test1::build_phase(uvm_phase phase);
   super.build_phase(phase);
   env = zmk_env::type_id::create("env",this);
   uvm_config_db#(uvm_object_wrapper)::set(this,"env.i_agt.sqr.main_phase","default_sequence",zmk_sequence_1::type_id::get());
   set_report_max_quit_count(2);
endfunction

function void base_test1::report_phase(uvm_phase phase);
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
