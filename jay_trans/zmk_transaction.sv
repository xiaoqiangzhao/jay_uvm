class zmk_transaction extends uvm_sequence_item ;
   rand bit[255:0] zmk_key;
   constraint key_cons{
      zmk_key[255:224] == 32'h900d900d;
   }
   function void post_randomize();
      $display("generating key : %x", zmk_key);
   endfunction
   `uvm_object_utils(zmk_transaction);
   
   function new(string name="zmk_transaction");
      super.new(name);
   endfunction
endclass
