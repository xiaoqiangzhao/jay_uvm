class zmk_sequencer extends uvm_sequencer #(zmk_transaction);
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   `uvm_component_utils(zmk_sequencer);
endclass
