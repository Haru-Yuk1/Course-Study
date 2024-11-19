`timescale 1ns / 1ps
//����rst��en��clear���ܵĴ�����
module flopenrc #(parameter WIDTH = 8)(
	input wire clk,rst,en,clear,
	input wire[WIDTH-1:0] d,
	output reg[WIDTH-1:0] q
    );
	always @(posedge clk) begin
		if(rst) begin
			q <= 0;
		end else if(clear) begin
			q <= 0;
		end else if(en) begin
			q <= d;
		end
	end
endmodule
