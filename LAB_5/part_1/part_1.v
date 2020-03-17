module part_1(SW, KEY, HEX0, HEX1);
input [1:0]SW;
input [0:0]KEY;
output [6:0]HEX0;
output [6:0]HEX1;
wire [7:0]in;
wire [7:0]out;


flipflop f0 (SW[1], out[0], KEY[0], SW[0]);
and(in[1], SW[1], out[0]);

flipflop f1 (in[1], out[1], KEY[0], SW[0]);
and(in[2], in[1], out[1]);

flipflop f2 (in[2], out[2], KEY[0], SW[0]);
and(in[3], in[2], out[2]);

flipflop f3 (in[3], out[3], KEY[0], SW[0]);
and(in[4], in[3], out[3]);

flipflop f4 (in[4], out[4], KEY[0], SW[0]);
and(in[5], in[4], out[4]);

flipflop f5 (in[5], out[5], KEY[0], SW[0]);
and(in[6], in[5], out[5]);

flipflop f6 (in[6], out[6], KEY[0], SW[0]);
and(in[7], in[6], out[6]);

flipflop f7 (in[6], out[7], KEY[0], SW[0]);


decoder hex0(out[3], out[2], out[1], out[0], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);

decoder hex1(out[7], out[6], out[5], out[4], HEX1[0], HEX1[1], HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);

endmodule

module flipflop(d, q, clk, reset_n);
input d;
input clk, reset_n;
output q;
reg q;

always @(posedge clk, negedge reset_n)
begin
if(reset_n == 1'b0)
q <= 0;
else
begin
if (d == 1'b1)
q <= ~q;
else
q <= q;
end
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

module decoder(SW[0], SW[1], SW[2], SW[3], HEX[0], HEX[1], HEX[2], HEX[3], HEX[4], HEX[5], HEX[6]);
    input [3:0]SW;
    output [6:0]HEX;

    assign HEX[0]=(~SW[0]&~SW[1]&SW[2]&~SW[3])|(SW[0]&SW[1]&~SW[2]&SW[3])|(SW[0]&~SW[1]&~SW[2]&~SW[3])|(SW[0]&~SW[1]&SW[2]&SW[3]);
    assign HEX[1]=(SW[0]&~SW[1]&SW[2]&~SW[3])|(SW[0]&SW[1]&SW[3])|(~SW[0]&SW[1]&SW[2])|(~SW[0]&SW[2]&SW[3]);
    assign HEX[2]=(~SW[0]&SW[2]&SW[3])|(SW[1]&SW[2]&SW[3])|(~SW[0]&SW[1]&~SW[2]&~SW[3]);
    assign HEX[3]=(~SW[0]&SW[1]&~SW[2]&SW[3])|(~SW[0]&~SW[1]&SW[2]&~SW[3])|(SW[0]&SW[1]&SW[2])|(SW[0]&~SW[1]&~SW[2]);
    assign HEX[4]=(SW[0]&~SW[3])|(SW[0]&~SW[1]&~SW[2])|(~SW[1]&SW[2]&~SW[3]);
    assign HEX[5]=(SW[0]&~SW[1]&SW[2]&SW[3])|(SW[0]&SW[1]&~SW[3])|(SW[0]&~SW[2]&~SW[3])|(SW[1]&~SW[2]&~SW[3]);
    assign HEX[6]=(~SW[1]&~SW[2]&~SW[3])|(SW[0]&SW[1]&SW[2]&~SW[3])|(~SW[0]&~SW[1]&SW[2]&SW[3]);

endmodule
