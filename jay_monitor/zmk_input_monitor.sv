class zmk_input_monitor extends uvm_monitor;
   virtual zmk_if v_zmk_if;
   uvm_analysis_port #(zmk_transaction) ap;
   `uvm_component_utils(zmk_input_monitor);

   function new(string name = "zmk_input_monitor",uvm_component parent = null);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ap = new ("ap",this);
      if(!uvm_config_db#(virtual zmk_if)::get(this,"","vif",v_zmk_if))
         `uvm_fatal("zmk_input_monitor","virtual interface must be set for zmk_input_monitor");
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(zmk_transaction tr);

endclass
task zmk_input_monitor::main_phase(uvm_phase phase);
   zmk_transaction tr;
   while(1)
   begin
      tr = new("tr");
      collect_one_pkt(tr);
      ap.write(tr);
   end
endtask

task zmk_input_monitor::collect_one_pkt(zmk_transaction tr);
   while(1)
   begin
      @(posedge v_zmk_if.ipg_clk);
      if(v_zmk_if.write_select) break;
   end
   `uvm_info("zmk_input_monitor","begin to collect one pkt",UVM_LOW);
   while(v_zmk_if.write_select)
   begin
      case(v_zmk_if.write_select)
            8'b00000001: tr.zmk_key[31:0]    = v_zmk_if.w_data;
            8'b00000010: tr.zmk_key[63:32]   = v_zmk_if.w_data;
            8'b00000100: tr.zmk_key[95:64]   = v_zmk_if.w_data;
            8'b00001000: tr.zmk_key[127:96]  = v_zmk_if.w_data;
            8'b00010000: tr.zmk_key[159:128] = v_zmk_if.w_data;
            8'b00100000: tr.zmk_key[191:160] = v_zmk_if.w_data;
            8'b01000000: tr.zmk_key[223:192] = v_zmk_if.w_data;
            8'b10000000: tr.zmk_key[255:224] = v_zmk_if.w_data;
            default : `uvm_fatal("zmk_input_monitor","wrong write_select")
      endcase
      @(posedge v_zmk_if.ipg_clk);
   end
   `uvm_info("zmk_input_monitor","end of collecting one pkt",UVM_LOW);
      $display("zmk_input_monitor: collect one pkt %x",tr.zmk_key);
endtask
