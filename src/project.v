/*
 * Copyright (c) 2024 Tórur Biskopstø Strøm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none (* keep_hierarchy *)

module tt_um_torurstrom_async_lock (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = acks_0;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};
  
  assign reqs_0 = ui_in;
  
  wire [7:0] reqs_0;
  wire [3:0] reqs_1;
  wire [1:0] reqs_2;
  wire reqs_3;
  
  wire [7:0] acks_0;
  wire [3:0] acks_1;
  wire [1:0] acks_2;
  wire acks_3;
  
  async_arbiter arb_0_0(acks_1[0], reqs_0[0], reqs_0[1], acks_0[0], acks_0[1], reqs_1[0]);
  async_arbiter arb_0_1(acks_1[1], reqs_0[2], reqs_0[3], acks_0[2], acks_0[3], reqs_1[1]);
  async_arbiter arb_0_2(acks_1[2], reqs_0[4], reqs_0[5], acks_0[4], acks_0[5], reqs_1[2]);
  async_arbiter arb_0_3(acks_1[3], reqs_0[6], reqs_0[7], acks_0[6], acks_0[7], reqs_1[3]);
  
  async_arbiter arb_1_0(acks_2[0], reqs_1[0], reqs_1[1], acks_1[0], acks_1[1], reqs_2[0]);
  async_arbiter arb_1_1(acks_2[1], reqs_1[2], reqs_1[3], acks_1[2], acks_1[3], reqs_2[1]);
  
  async_arbiter arb_2_0(acks_3, reqs_2[0], reqs_2[1], acks_2[0], acks_2[1], reqs_3);
  
  assign acks_3 = reqs_3;

endmodule
