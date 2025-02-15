/*
 * Muller C-element
 *
 * Author: Tórur Biskopstø Strøm (torur.strom@gmail.com)
 *
 */
module c_element (a, b, y);

input a;
input b;

output y /* synthesis keep */;

`ifdef TEST
  assign y = (a & b) | (y & (a | b));
`else
  wire andabw, orabw, andyabw;
  sky130_fd_sc_hd__and2 andab(a, b, andabw);
  sky130_fd_sc_hd__or2 orab(a, b, orabw);
  sky130_fd_sc_hd__and2 andyab(y, orabw, andyabw);
  sky130_fd_sc_hd__or2 orabyab(andabw, andyabw, y);
`endif

endmodule
