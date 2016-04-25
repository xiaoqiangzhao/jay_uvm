
module  snvs_lp_zmk_ff
  (//--- Inputs
   clock,
   reset,
   data_in,
   //--- Outputs
   data_out
   );  // snvs_lp_zmk_ff

   ///////////////////////////////////////////////////////////////////////////
   //
   // MODULE PORTS
   //
   ///////////////////////////////////////////////////////////////////////////
 
   input                  clock;                 // FF Clock
   input                  reset;                 // FF Reset (Active High) 
   input                  data_in;               // FF Input

   output                 data_out;              // FF Output

   ///////////////////////////////////////////////////////////////////////////
   //
   // OUTPUT WIRES
   //
   ///////////////////////////////////////////////////////////////////////////

`ifdef SNVS_ZMK_SPECIFIC_FF   // Instantiate Special FF Design
   wire                   data_out;              // FF Output
`else    // !`ifdef SNVS_ZMK_SPECIFIC_FF
   reg                    data_out;              // FF Output
`endif   // !`ifdef SNVS_ZMK_SPECIFIC_FF

   ///////////////////////////////////////////////////////////////////////////
   //
   // FF
   //
   ///////////////////////////////////////////////////////////////////////////

`ifdef SNVS_ZMK_SPECIFIC_FF   // Instantiate Special FF Design

   //--- Instanitate library specific flip-flop suitable for Key Storage
   sdffprp_hivt_2  key_ff
     (//--- Inputs 
      .ck                      (clock),
      .r                       (reset),
      .d                       (~data_in),
      .sdi                     (data_out),
      .se                      (1'b0),
      //--- Outputs
      .q                       (),
      .qb                      (data_out)
      );

`else    // !`ifdef SNVS_ZMK_SPECIFIC_FF

   //--- Regular Flip-Flop
   always @(posedge clock or posedge reset)
     begin
        if (reset)
           data_out  <=  1'b0;
        else
           data_out  <=  data_in;
     end

`endif   // !`ifdef SNVS_ZMK_SPECIFIC_FF

endmodule   // snvs_lp_zmk_ff
