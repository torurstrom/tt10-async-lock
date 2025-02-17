/*
 * Copyright (c) 2024 Tórur Biskopstø Strøm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none (* keep_hierarchy *)

module async_mutex (
  input req1,
  input req2,
  output gnt1,
  output gnt2
);

  wire o1 /* synthesis keep */;
  wire o2 /* synthesis keep */;

  // assign o1 = ~(req1 & o2);
  // assign o2 = ~(req2 & o1);

  nandm nandm_o1(req1, o2, o1);
  nandm nandm_o2(req2, o1, o2);

  assign gnt1 = ~o1 & o2;
  assign gnt2 = ~o2 & o1;

endmodule

module nandm (
  input a,
  input b,
  output y
);

  assign y = ~(a & b);

endmodule
