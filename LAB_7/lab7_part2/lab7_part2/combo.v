module combo(go, clock, resetN, draw, colour_in, location_in, x_out, y_out, colour_out);
	input clock, resetN, go, draw;
	input [2:0] colour_in;
	input [6:0] location_in;
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour_out;
	
	wire ld_x, ld_y, ld_c, plot, enable_i_x;
	
	controller c0(.go(go), .resetN(resetN), .clock(clock), .draw(draw), .ld_x(ld_x), .ld_y(ld_y), .ld_c(ld_c), .enable_i_x(enable_i_x), .plot(plot)
	);
	
	datapath d0(.location_in(location_in), .colour_in(colour_in), .clock(clock), .resetN(resetN), .enable_i_x(enable_i_x), .ld_x(ld_x), .ld_y(ld_y), .ld_c(ld_c), .x_out(x_out), .y_out(y_out), .colour_out(colour_out)
	);
	
endmodule


module datapath(location, colour, clock, resetN, enable_i_x, ld_x, ld_y, ld_c, x_out, y_out, colour_out);
	input [6:0] location;
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
				x <= {1'b0, location};
			if(ld_x)
				y <= location;
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
	
module controller(go, resetN, clock, draw, ld_x, ld_y, ld_c, enable_i_x, plot);
	input go, resetN, clock, draw;
	output reg ld_x, ld_y, ld_c, enable_i_x, plot;
	
	reg [2:0] current_state, next_state;
	
	localparam 	S_Load_x = 3'd0,
				S_Load_x_wait = 3'd1,
				S_Load_y_c = 3'd2, // load the y coord and color in the same time
				S_Load_y_c_wait = 3'd3,
				S_Draw = 3'd4;
	
	always @(*) begin
		case (current_state)
			S_Load_x: next_state = go ? S_Load_x_wait : S_Load_x;
			S_Load_x_wait: next_state = go ? S_Load_x_wait : S_Load_y_c;
			S_Load_y_c: next_state = draw ? S_Load_y_c_wait : S_Load_y_c;
			S_Load_y_c_wait: next_state = draw ? S_Load_y_c_wait : S_Draw;
			S_Draw: next_state = go ? S_Load_x : S_Draw;
		endcase
	end
	
	always @(*) begin
		ld_x = 1'b0;
		ld_y = 1'b0;
		ld_c = 1'b0;
		plot = 1'b0;
		
		case(current_state)
			S_Load_x: begin
				ld_x = 1'b1;
				enable_i_x = 1'b1;
				end
			S_Load_y_c: begin
				ld_y = 1'b1;
				ld_c = 1'b1;
				end
			S_Draw: begin
				plot = 1'b1;
				end
		endcase
	end
	
	always @(posedge clock) begin
		if(!resetN) // active low reset
			current_state <= S_Load_x;
		else
			current_state = next_state;
	end

endmodule	

