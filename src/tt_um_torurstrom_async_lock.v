/*
 * Copyright (c) 2024 Tórur Biskopstø Strøm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

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
  wire _unused = &{ena, clk, uio_in, 1'b0};
  
  assign reqs_0 = ui_in;
  
  wire [7:0] reqs_0;
  wire [3:0] reqs_1;
  wire [1:0] reqs_2;
  wire reqs_3;
  
  wire [7:0] acks_0;
  wire [3:0] acks_1;
  wire [1:0] acks_2;
  wire acks_3;
  
  async_arbiter arb_0_0(rst_n, acks_1[0], reqs_0[0], reqs_0[1], acks_0[0], acks_0[1], reqs_1[0]);
  async_arbiter arb_0_1(rst_n, acks_1[1], reqs_0[2], reqs_0[3], acks_0[2], acks_0[3], reqs_1[1]);
  async_arbiter arb_0_2(rst_n, acks_1[2], reqs_0[4], reqs_0[5], acks_0[4], acks_0[5], reqs_1[2]);
  async_arbiter arb_0_3(rst_n, acks_1[3], reqs_0[6], reqs_0[7], acks_0[6], acks_0[7], reqs_1[3]);
  
  async_arbiter arb_1_0(rst_n, acks_2[0], reqs_1[0], reqs_1[1], acks_1[0], acks_1[1], reqs_2[0]);
  async_arbiter arb_1_1(rst_n, acks_2[1], reqs_1[2], reqs_1[3], acks_1[2], acks_1[3], reqs_2[1]);
  
  async_arbiter arb_2_0(rst_n, acks_3, reqs_2[0], reqs_2[1], acks_2[0], acks_2[1], reqs_3);
  
  assign acks_3 = reqs_3;

endmodule




module async_arbiter (
  input rst_n,
  input ack,
  input req1,
  input req2,
  output ack1,
  output ack2,
  output req
);

wire gnt1;
wire gnt2;

wire y1 /* synthesis keep */;
wire y2 /* synthesis keep */;

async_mutex mutex(req1, req2, gnt1, gnt2);

assign y1 = gnt1 & ~ack2;
assign y2 = gnt2 & ~ack1;

c_element c_ack1(rst_n, ack, y1, ack1);
c_element c_ack2(rst_n, ack, y2, ack2);

assign req = y1 | y2;


endmodule




module async_mutex (
  input req1,
  input req2,
  output gnt1,
  output gnt2
);

wire o1 /* synthesis keep */;
wire o2 /* synthesis keep */;

sky130_fd_sc_hd__nand2_1 n1(.A(req1), B.(o2), .Y(o1)
// `ifdef USE_POWER_PINS
  // ,.VPWR(1'b1), .VGND(1'b0), .VPB(1'b1), .VNB(1'b0)
// `endif
);

sky130_fd_sc_hd__nand2_1 n2(.A(req2), B.(o1), .Y(o2)
// `ifdef USE_POWER_PINS
  // ,.VPWR(1'b1), .VGND(1'b0), .VPB(1'b1), .VNB(1'b0)
// `endif
);

assign gnt1 = ~o1 & o2;
assign gnt2 = ~o2 & o1;

endmodule




module c_element (
  input rst_n,
  input a,
  input b,
  output y
);

`ifdef TEST
  assign y = (a & b) | (y & (a | b));
`else
  wire x;
  
  sky130_fd_sc_hd__o21a_1 o1(.A1(a & b), .A2(x), .B1(rst_n), .X(y)
  `ifdef USE_POWER_PINS
    ,.VPWR(1'b1), .VGND(1'b0), .VPB(1'b1), .VNB(1'b0)
  `endif
  );

  sky130_fd_sc_hd__o21a_1 o2(.A1(a), .A2(b), .B1(y), .X(x)
  `ifdef USE_POWER_PINS
    ,.VPWR(1'b1), .VGND(1'b0), .VPB(1'b1), .VNB(1'b0)
  `endif
  );
`endif


endmodule
