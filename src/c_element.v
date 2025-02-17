/*
 * Copyright (c) 2024 Tórur Biskopstø Strøm
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none (* keep_hierarchy *)

module c_element (
  input a,
  input b,
  output y
);

  //assign y = (a & b) | (y & (a | b));

  orm orm_y((a & b), (y & (a | b)), y);

endmodule

module orm (
  input a,
  input b,
  output y
);

  assign y = a | b;

endmodule
