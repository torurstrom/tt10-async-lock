/*
 * Copyright (c) 2024 Tórur Biskopstø Strøm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none (* keep_hierarchy *)

module async_arbiter (
  input ack,
  input req1,
  input req2,
  output ack1,
  output ack2,
  output req
);

  wire gnt1 /* synthesis keep */;
  wire gnt2 /* synthesis keep */;

  wire y1 /* synthesis keep */;
  wire y2 /* synthesis keep */;

  async_mutex mutex(req1, req2, gnt1, gnt2);

  assign y1 = gnt1 & ~ack2;
  assign y2 = gnt2 & ~ack1;

  c_element c_ack1(ack, y1, ack1);
  c_element c_ack2(ack, y2, ack2);

  assign req = y1 | y2;

endmodule
