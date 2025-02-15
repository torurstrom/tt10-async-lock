/*
 * Muller C-element
 *
 * Author: Torur Biskopsto Strom (torur.strom@gmail.com)
 *
 */
module c_element (a, b, y);

input a;
input b;

output y /* synthesis keep */;

assign y = (a & b) | (y & (a | b));

endmodule
