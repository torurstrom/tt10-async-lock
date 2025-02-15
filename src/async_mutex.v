/*
 * Asynchronous mutex
 *
 * Author: Tórur Biskopstø Strøm (torur.strom@gmail.com)
 *
 */
module async_mutex (req1, req2, gnt1, gnt2);

input req1;
input req2;

output gnt1 /* synthesis keep */;
output gnt2 /* synthesis keep */;

wire o1 /* synthesis keep */;
wire o2 /* synthesis keep */;

assign o1 = ~(req1 & o2);
assign o2 = ~(req2 & o1);

assign gnt1 = ~o1 & o2;
assign gnt2 = ~o2 & o1;

endmodule
