module adder_avst(clk, reset, data_in, end_in, valid_in, ready_in,
		  data_out, end_out, valid_out, ready_out);

   input 	clk;
   input 	reset;

   input [7:0] 	data_in;
   input 	end_in;
   input 	valid_in;
   output 	ready_in;

   output [7:0] data_out;
   output 	end_out;
   output 	valid_out;
   input 	ready_out;
   
   reg [7:0] 	data_out;

   reg 		valid_out;
   reg 		end_out;
   reg 		ready_in; 

   reg [2:0] 	count_out;
   reg [31:0] 	sum;

   always @(posedge clk) begin
      if (reset) begin
	 data_out <= 0;
      end
      else
	case(count_out)
	  4: begin
	     data_out <= sum[31:24];
	     end_out <= 0;
	     end
	  3: begin
	     data_out <= sum[23:16];
	     end_out <= 0;
	     end
	  2: begin
	     data_out <= sum[15:8];
	     end_out <= 0;
	     end
	  1: begin
	     data_out <= sum[7:0];
	     end_out <= 1;
	     end
	  0: begin
	     data_out <= 0;
	     end_out <= 0;
	     sum <= 0;
	     end
	endcase
   end
   
   always @(posedge clk) begin
      if(reset) begin
	 count_out <= 'b111;
	 valid_out <= 0;
	 end_out <= 0;
	 ready_in <= 1;
	 sum <= 0;
      end
      else begin
	 if (valid_in && ready_in) begin
	    sum <= sum + {24'b0, data_in};
	    if (end_in) begin
	       ready_in <= 0;
	       count_out <= 4;
	    end
	 end
	 if (ready_in == 0) begin
	    if (count_out == 0) begin
	       end_out <= 1;
	    end
	    else valid_out <= 1;
	    if (ready_out == 1) begin
	       count_out <= count_out - 1;
	       if (end_out == 1) begin
	       	  valid_out <= 0;
	       	  ready_in <= 1;
	       	  end_out <= 0;
	       	  sum <= 0;
	       end
	    end
	 end
      end
   end
endmodule