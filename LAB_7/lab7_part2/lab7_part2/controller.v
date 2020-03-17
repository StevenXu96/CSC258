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
