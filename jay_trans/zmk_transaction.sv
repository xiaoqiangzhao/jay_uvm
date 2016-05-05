class zmk_transaction extends uvm_sequence_item ;
   rand bit[255:0] zmk_key;
   constraint key_cons{
      zmk_key[255:224] == 32'h900d900d;
   }
   `uvm_object_utils_begin(zmk_transaction)
   `uvm_field_int(zmk_key,UVM_ALL_ON)
   `uvm_object_utils_end


   function void post_randomize();
      $display("generating key : %x", zmk_key);
   endfunction
   //`uvm_object_utils(zmk_transaction);
   
   function new(string name="zmk_transaction");
      super.new(name);
   endfunction

   //function void my_print();
      //$display("print zmk_transaction: %x",zmk_key);
   //endfunction

   //function bit my_compare(zmk_transaction tr);
      //if(tr == null)
         //`uvm_fatal("zmk_transaction","tr is null!!!");
      //return (zmk_key==tr.zmk_key);
   //endfunction
endclass
