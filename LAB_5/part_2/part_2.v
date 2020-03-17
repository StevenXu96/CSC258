module part_2(SW, HEX0, CLOCK_50);
input [3:0]SW;
input CLOCK_50;
output [6:0]HEX0;
wire [27:0]rd0, rd1, rd2, rd3;
reg EN;
wire [3:0]counter;

RateDivider r00(CLOCK_50, rd0[27:0], SW[2], 1'b0, 28'b0000000000000000000000000000, SW[3]);
RateDivider r01(CLOCK_50, rd1[27:0], SW[2], 1'b1, 28'b0010111110101111000001111111, SW[3]);
RateDivider r10(CLOCK_50, rd2[27:0], SW[2], 1'b1, 28'b0101111101011110000011111111, SW[3]);
RateDivider r11(CLOCK_50, rd3[27:0], SW[2], 1'b1, 28'b1011111010111100000111111111, SW[3]);

always @(*)
begin
case(SW[1:0])
2'b00: assign EN = (rd0[27:0] == 28'b0000000000000000000000000000) ? 1:0;
2'b01: assign EN = (rd1[27:0] == 28'b0000000000000000000000000000) ? 1:0;
2'b10: assign EN = (rd2[27:0] == 28'b0000000000000000000000000000) ? 1:0;
2'b11: assign EN = (rd3[27:0] == 28'b0000000000000000000000000000) ? 1:0;
default: EN = 1'b0;
endcase
end

counter c0(EN, counter[3:0], CLOCK_50, SW[2]);
decoder hex0(counter[0], counter[1], counter[2], counter[3], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);

endmodule


module RateDivider(clk, q, clear, EN, d, ParLoad);
input clk, EN, ParLoad, clear;
input [27:0]d;
output [27:0]q;
reg [27:0]q;

always @(posedge clk)
begin
if (clear == 1'b0)
q <= 1'b0;
else if (ParLoad == 1'b1)
q <= d;
else if (q == 28'b0000000000000000000000000000)
q <= d;
else if (EN == 1'b1)
q <= q - 1'b1;
else if(EN == 1'b0)
q <= q;
end
endmodule


module counter(d, q, clk, reset_n);
input d;
input clk, reset_n;
output [3:0]q;
reg [3:0]q;

always @(posedge clk)
begin
if(reset_n == 1'b0)
q <= 0;
else
begin
if (d == 1'b1)
q <= q + 1'b1;
else if(d == 1'b0)
q <= q;
end
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
