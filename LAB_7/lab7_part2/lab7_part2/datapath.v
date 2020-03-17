module datapath(location_in, colour_in, clock, resetN, enable_i_x, ld_x, ld_y, ld_c, x_out, y_out, colour_out);
	input [6:0] location_in;
	input [2:0] colour_in;
	input clock;
	input enable_i_x;
	input resetN;
	input ld_x, ld_y, ld_c;
	output [7:0] x_out; 
	output [6:0] y_out;
	output [2:0] colour_out;
	
	reg [7:0] x;
	reg [6:0] y;
	reg [2:0] colour;
	reg [1:0] i_x, i_y; // index of x and y in loop
	reg enable_i_y;
	
	always @(posedge clock) begin 
		if(!resetN) begin  //active low reset
			x <= 8'b0;
			y <= 7'b0;
			colour <= 3'b0;
		end
		else begin
			if(ld_x)
				x <= {1'b0, location_in};
			if(ld_y)
				y <= location_in;
			if(ld_c)
				colour <= colour_in;
		end
	end
	
	always @(posedge clock) begin
		if(!resetN)
			i_x <= 2'b00;
		else if(enable_i_x) begin // start to increase x
			if(i_x == 2'b11) begin
				i_x <= 2'b00;
				enable_i_y <= 1;
				end
			else begin
				i_x <= i_x + 1;
				enable_i_y <= 0;
				end
			end
	end
	
	always @(posedge clock) begin
		if(!resetN)
			i_y <= 2'b00;
		else if(enable_i_y) begin // start to increase y
			if(i_y == 2'b11)
				i_y <= 2'b00;
			else
				i_y <= i_y + 1;
			end
	end
	
	assign x_out = x + i_x;
	assign y_out = y + i_y;
	assign colour_out = colour;

endmodule
