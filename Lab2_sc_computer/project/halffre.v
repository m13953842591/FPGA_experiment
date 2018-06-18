module halffre(c1, c2);
	input c1;
	output c2;
	reg c2;
	always @(posedge c1)
		begin
			c2 = c2 + 1;
		end
		
endmodule
