module part_3(SW, KEY, LEDR);
input [9:0]SW;
input [3:0]KEY;
output [7:0]LEDR;

shifter s1(SW[7:0], KEY[1], KEY[2], KEY[3], KEY[0], SW[9], LEDR[7:0]);

endmodule

module shifter(loadVal, load_n, ShiftRight, ASR, clk, reset_n, Q);
input [7:0]loadVal;
input load_n, ShiftRight, ASR, clk, reset_n;
output [7:0]Q;
wire the_wire;

mux2to1 M3(
.x(ASR),
.y(Q[7]),
.s(ASR),
.m(the_wire)
);

one_bit_shifter B1(Q[1], loadVal[0], ShiftRight, load_n, clk, reset_n, Q[0]);
one_bit_shifter B2(Q[2], loadVal[1], ShiftRight, load_n, clk, reset_n, Q[1]);
one_bit_shifter B3(Q[3], loadVal[2], ShiftRight, load_n, clk, reset_n, Q[2]);
one_bit_shifter B4(Q[4], loadVal[3], ShiftRight, load_n, clk, reset_n, Q[3]);
one_bit_shifter B5(Q[5], loadVal[4], ShiftRight, load_n, clk, reset_n, Q[4]);
one_bit_shifter B6(Q[6], loadVal[5], ShiftRight, load_n, clk, reset_n, Q[5]);
one_bit_shifter B7(Q[7], loadVal[6], ShiftRight, load_n, clk, reset_n, Q[6]);
one_bit_shifter B8(the_wire, loadVal[7], ShiftRight, load_n, clk, reset_n, Q[7]);

endmodule


module one_bit_shifter(in, load_val, shift, load_n, clk, reset_n, out);
input in, load_val, shift, load_n, clk, reset_n;
output out;
wire first_mux_out, second_mux_out;

mux2to1 M1(
.x(out),
.y(in),
.s(shift),
.m(first_mux_out)
);

mux2to1 M2(
.x(load_val),
.y(first_mux_out),
.s(load_n),
.m(second_mux_out)
);

flipflop F0(
.d(second_mux_out),
.q(out),
.clk(clk),
.reset_n(reset_n)
);
endmodule

module flipflop(d, q, clk, reset_n);
input [7:0]d;
input clk, reset_n;
output [7:0]q;
reg [7:0]q;

always @(posedge clk)
begin
if(reset_n == 1'b0)
q <= 0;
else
q <= d;
end
endmodule


module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule 
