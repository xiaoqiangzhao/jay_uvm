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
   extern virtual task drive_one_pkt(zmk_transaction tr);
endclass



task zmk_driver::main_phase(uvm_phase phase);
   zmk_transaction tr;
   phase.raise_objection(this);
   `uvm_info("zmk_driver","main phase start",UVM_LOW);
   `uvm_info("zmk_driver","Waiting for reset",UVM_LOW);
   wait(v_zmk_if.soft_reset==1'b1 && v_zmk_if.reset==1'b1);
   `uvm_info("zmk_driver","reset finished",UVM_LOW);
   @(posedge v_zmk_if.ipg_clk);
   for(int i=0;i<3;i++)
   begin
      tr = new("tr");
      assert(tr.randomize());
      drive_one_pkt(tr);
   end
   repeat(2) @(posedge v_zmk_if.ipg_clk);
   phase.drop_objection(this);
endtask

task zmk_driver::drive_one_pkt(zmk_transaction tr);
   bit [255:0] tmp_key;
   bit [31:0] data_q[$];
   tmp_key = tr.zmk_key;
   //$display("tmp_key is %x",tmp_key);
   for(int i =0; i < 8; i++)
   begin
   //$display("tmp_key[31:0] is %x",tmp_key[31:0]);
      data_q.push_back(tmp_key[31:0]);
      /*for(int j=0;j<data_q.size();j++)*/
      //begin
         //$display("data_q[%d] is %x",j,data_q[j]);
      /*end*/
      tmp_key = tmp_key >> 32 ;
   end
   repeat(3) @(posedge v_zmk_if.ipg_clk);  // need to avoid competition  with main_phase
   while(data_q.size() > 0)
   begin
      @(posedge v_zmk_if.ipg_clk);
      //$display("remaining %d words",data_q.size());
      v_zmk_if.write_select =(1 << (data_q.size()-1)) ;
      //for(int j=0;j<data_q.size();j++)
      //begin
         //$display("data_q[%d] is %x",j,data_q[j]);
      //end

      v_zmk_if.w_data =data_q.pop_back();
      $display("write_select: %b  w_data: %x",v_zmk_if.write_select,v_zmk_if.w_data);
   end
   @(posedge v_zmk_if.ipg_clk);
   v_zmk_if.write_select <=8'b0;

endtask
