class zmk_sequence_0 extends uvm_sequence #(zmk_transaction);
   zmk_transaction tr_0;
   function new(string name = "my_sequence");
      super.new(name);
   endfunction

   virtual task body();
      if(starting_phase !=null)
      begin
         starting_phase.raise_objection(this);
      repeat (10) begin
         `uvm_do_with(tr_0,{tr_0.zmk_key[31:0]==32'h5a5a5a5a;})
      end
      #1000;
         starting_phase.drop_objection(this);
      end
   endtask
   `uvm_object_utils(zmk_sequence_0);
endclass
