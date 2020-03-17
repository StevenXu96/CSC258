module alu(SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
input [7:0]SW;
input [2:0]KEY;
output [7:0]LEDR;
output [6:0]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

aluunit alu0(
.A(SW[7:4]),
.B(SW[3:0]),
.func(KEY[2:0]),
.aluout(LEDR[7:0])
);

decoder hex0(SW[0], SW[1], SW[2], SW[3], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);

decoder hex1(1'b0, 1'b0, 1'b0, 1'b0, HEX1[0], HEX1[1], HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);

decoder hex2(SW[4], SW[5], SW[6], SW[7], HEX2[0], HEX2[1], HEX2[2], HEX2[3], HEX2[4], HEX2[5], HEX2[6]);

decoder hex3(1'b0, 1'b0, 1'b0, 1'b0, HEX3[0], HEX3[1], HEX3[2], HEX3[3], HEX3[4], HEX3[5], HEX3[6]);

decoder hex4(LEDR[0], LEDR[1], LEDR[2], LEDR[3], HEX4[0], HEX4[1], HEX4[2], HEX4[3], HEX4[4], HEX4[5], HEX4[6]);

decoder hex5(LEDR[4], LEDR[5], LEDR[6], LEDR[7], HEX5[0], HEX5[1], HEX5[2], HEX5[3], HEX5[4], HEX5[5], HEX5[6]);

endmodule


module aluunit(A, B, func, aluout);
input [3:0]A;
input [3:0]B;
input [2:0]func;
output [7:0] aluout;
reg [7:0] aluout;
wire [3:0] case_out_000;
wire [3:0] case_out_001;
wire carry_000;
wire carry_001;
wire [2:0]f;
assign f[0] = ~func[0];
assign f[1] = ~func[1];
assign f[2] = ~func[2];

ripple_adder block1(
.A(A[3:0]),
.B(4'b0000),
.cin(1'b1),
.S(case_out_000[3:0]),
.cout(carry_000)
);

ripple_adder block2(
.A(A[3:0]),
.B(B[3:0]),
.cin(1'b0),
.S(case_out_001[3:0]),
.cout(carry_001)
);

always @(*)
begin
case(f[2:0])
3'b000: 
begin
aluout[3:0] = case_out_000[3:0];
aluout[4] = carry_000;
aluout[7:5] = 3'b000;
end
3'b001:
begin
aluout[3:0] = case_out_001[3:0];
aluout[4] = carry_001;
aluout[7:5] = 3'b000;
end
3'b010: aluout = {4'b0000, A + B};
3'b011: aluout = {A|B, A^B};
3'b100: aluout = |{A, B};
3'b101: aluout = {A, B};
default: aluout = 8'b00000000;
endcase
end
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

module ripple_adder(A, B, cin, S, cout);
input [3:0] A, B;
input [0:0] cin;
output [3:0] S;
output cout;
wire [2:0]w;

fulladder Block1(A[0], B[0], cin[0], S[0], w[0]);
fulladder Block2(A[1], B[1], w[0], S[1], w[1]);
fulladder Block3(A[2], B[2], w[1], S[2], w[2]);
fulladder Block4(A[3], B[3], w[2], S[3], cout);
endmodule

module fulladder(A, B, cin, S, cout);
input A, B, cin;
output S, cout;
wire [0:0]w;

xor B1(w[0], A, B);
xor B2(S, cin, w[0]);
mux2to1 B3(
        .x(B), 
        .y(cin), 
        .s(w[0]), 
        .m(cout)
        );
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
