class zmk_scoreboard extends uvm_scoreboard;
   zmk_transaction act_port_q[$];
   uvm_blocking_get_port #(zmk_transaction) exp_port;
   uvm_blocking_get_port #(zmk_transaction) act_port;
   `uvm_component_utils(zmk_scoreboard);
   function new(string name="zmk_socreboard",uvm_component parent=null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      exp_port = new("exp_port",this);
      act_port = new("act_port",this);
   endfunction
   
   extern task main_phase(uvm_phase phase);
endclass
   
   task zmk_scoreboard::main_phase(uvm_phase phase);
      zmk_transaction exp_tr, act_tr, tmp_tr;
      super.main_phase(phase);
      fork
         while(1)
         begin
            act_port.get(act_tr);
            act_port_q.push_back(act_tr);
         end

         while(1)
         begin
            exp_port.get(exp_tr);
            if(act_port_q.size())
            begin
               tmp_tr = act_port_q.pop_back();
               //tmp_tr.my_print();
               if(exp_tr.my_compare(tmp_tr))
               begin
                  `uvm_info("zmk_scoreboard","Compare Successfully",UVM_LOW);
               end
               else
               begin
                  `uvm_error("zmk_scoreboard","Compare Failed");
                  $display("the expect pkt:");
                  exp_tr.my_print();
                  $display("the actural pkt:");
                  tmp_tr.my_print();
               end
            end
            else
            begin
               `uvm_error("my_scoreboard","Actural Que is Empty");
               $display("Expeted Pkt:");
               exp_tr.my_print();
            end
         end

      join
   endtask
