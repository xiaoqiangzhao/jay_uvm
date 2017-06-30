//`include "snvs_lp_zmk_ff.v"
module  snvs_lp_zmk
  (//--- Inputs
   ipg_clk,
   zmk_reset,
   zmk_soft_reset,
   write_lpzmk,
   lp_wdata,
   //--- Outputs
   lpzmk_reg
   );  // snvs_lp_zmk

// Include the SNVS Parameters 
`include "snvs_params.vh"

   ///////////////////////////////////////////////////////////////////////////
   //
   // MODULE PORTS
   //
   ///////////////////////////////////////////////////////////////////////////
 
   input                  ipg_clk;               // System Clock
   input                  zmk_reset;             // System Reset 
   input                  zmk_soft_reset;        // ZMK Soft Reset
   input  [7:0]           write_lpzmk;           // Write ZMK Registers
   input  [SNVS_DATA_WIDTH-1:0] lp_wdata;              // LP Write Data

   output [SNVS_ZMK_WIDTH-1:0]  lpzmk_reg;             // Zeroizable Master Key

   ///////////////////////////////////////////////////////////////////////////
   //
   // OUTPUT WIRES
   //
   ///////////////////////////////////////////////////////////////////////////

   wire   [SNVS_ZMK_WIDTH-1:0]  lpzmk_reg;             // Zeroizable Master Key
   reg    [SNVS_ZMK_WIDTH-1:0]  zmk_data;              // ZMK Write Data

   ///////////////////////////////////////////////////////////////////////////
   //
   // ZEROIZABLE MASTER KEY REGISTER
   //
   ///////////////////////////////////////////////////////////////////////////

   genvar ii;
   genvar jj;

   //--- ZMK Write Data Generation
   generate
      for (ii = 0; ii < SNVS_ZMK_WIDTH/SNVS_DATA_WIDTH; ii = ii + 1)
      begin : zmk_data_mux
         always @( * )
         begin
            if ( zmk_soft_reset )
               zmk_data[32*ii+31:32*ii]  =  SNVS_DATA_WIDTH_ZERO;
            else if ( write_lpzmk[ii] )
               zmk_data[32*ii+31:32*ii]  =  lp_wdata;
               $display("SNVS_LP_ZMK: Write %d  %x",ii,lp_wdata);
            else
               zmk_data[32*ii+31:32*ii]  =  lpzmk_reg[32*ii+31:32*ii];
         end 
      end 
   endgenerate

   //--- ZMK Register
   generate
      for (jj = 0; jj < SNVS_ZMK_WIDTH; jj = jj + 1)
      begin : zmk_reg_inst
         snvs_lp_zmk_ff  snvs_lp_zmk_reg 
            (//--- Inputs 
             .clock                   (ipg_clk),
             .reset                   (zmk_reset),
             .data_in                 (zmk_data[jj]),
             //--- Output
             .data_out                (lpzmk_reg[jj])
             );
      end 
   endgenerate



endmodule  // snvs_lp_zmk
