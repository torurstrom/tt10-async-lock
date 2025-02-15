/*
 * Asynchronous arbiter used to build the asynchronous
 * arbiter tree
 *
 * Author: Tórur Biskopstø Strøm (torur.strom@gmail.com)
 *
 */
module async_arbiter (ack, req1, req2, ack1, ack2, req);

input ack;
input req1;
input req2;

output ack1 /* synthesis keep */;
output ack2 /* synthesis keep */;
output req /* synthesis keep */;

wire gnt1;
wire gnt2;

wire y1 /* synthesis keep */;
wire y2 /* synthesis keep */;

async_mutex mutex(req1, req2, gnt1, gnt2);

assign y1 = gnt1 & ~ack2;
assign y2 = gnt2 & ~ack1;

c_element c_ack1(ack, y1, ack1);
c_element c_ack2(ack, y2, ack2);

assign req = y1 | y2;

endmodule
