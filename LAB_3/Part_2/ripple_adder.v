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
