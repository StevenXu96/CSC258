module part_3(SW, LEDR, CLOCK_50);
input CLOCK_50;
input [2:0]SW;
input [1:0]KEY;
output [0:0]LEDR;

wire [27:0]the_wire;
wire EN;
wire [13:0]code;

LUT lut0(SW[2:0], code[13:0]);
RateDivider(CLOCK_50, the_wire[27:0], KEY[0], 28'b0101111101011110000011111111);
assign EN = (Q == 28'b0000000000000000000000000000) ? 1:0;

shifter s0(code[13:0], KEY[0], KEY[1], EN, 1'b0, 1'b1, LEDR[0])

endmodule


module LUT(letter, code);
input [2:0]letter;
output [13:0]code;

reg [13:0]code;

always @(letter)
begin
case(letter)
3'b000: code = 14'b10101000000000;
3'b001: code = 14'b11100000000000;
3'b010: code = 14'b10101110000000;
3'b011: code = 14'b10101011100000;
3'b100: code = 14'b10111011100000;
3'b101: code = 14'b11101010111000;
3'b110: code = 14'b11101011101110;
3'b111: code = 14'b11101110101000;
endcase
end
endmodule



module RateDivider(clk, q, clear, d);
input clk, clear;
input [27:0]d;
output [27:0]q;
reg [27:0]q;

always @(posedge clk)
begin
if (clear == 1'b0)
q <= 1'b0;
else if (q == 28'b0000000000000000000000000000)
q <= d;
else
q <= q - 1'b1;
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

module shifter(loadVal, reset, load, clk, in, shift, q);
input [13:0]loadVal;
input load, in, shift, clk, reset;
output q;
wire [13:0]Q;

assign q = Q[0];

one_bit_shifter B0(Q[1], loadVal[0], shift, load, clk, reset, Q[0]);
one_bit_shifter B1(Q[2], loadVal[1], shift, load, clk, reset, Q[1]);
one_bit_shifter B2(Q[3], loadVal[2], shift, load, clk, reset, Q[2]);
one_bit_shifter B3(Q[4], loadVal[3], shift, load, clk, reset, Q[3]);
one_bit_shifter B4(Q[5], loadVal[4], shift, load, clk, reset, Q[4]);
one_bit_shifter B5(Q[6], loadVal[5], shift, load, clk, reset, Q[5]);
one_bit_shifter B6(Q[7], loadVal[6], shift, load, clk, reset, Q[6]);
one_bit_shifter B7(Q[8], loadVal[7], shift, load, clk, reset, Q[7]);
one_bit_shifter B8(Q[9], loadVal[8], shift, load, clk, reset, Q[8]);
one_bit_shifter B9(Q[10], loadVal[9], shift, load, clk, reset, Q[9]);
one_bit_shifter B10(Q[11], loadVal[10], shift, load, clk, reset, Q[10]);
one_bit_shifter B11(Q[12], loadVal[11], shift, load, clk, reset, Q[11]);
one_bit_shifter B12(Q[13], loadVal[12], shift, load, clk, reset, Q[12]);
one_bit_shifter B13(in, loadVal[13], shift, load, clk, reset, Q[13]);
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

dflipflop F0(
.d(second_mux_out),
.q(out),
.clk(clk),
.reset_n(reset_n)
);
endmodule

module dflipflop(d, q, clk, reset_n);
input [13:0]d;
input clk, reset_n;
output [13:0]q;
reg [13:0]q;

always @(posedge clk)
begin
if(reset_n == 1'b0)
q <= 0;
else
q <= d;
end
endmodule
