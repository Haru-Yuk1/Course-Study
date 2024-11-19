`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 09:00:35
// Design Name: 
// Module Name: non_stall_pipeline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//������3����ˮ�ߣ�������֤���ָ�ֵ���ӳ٣����������ں�dataout�ű�����һ�����ڵ�ֵ

module non_stall_pipeline #(parameter WIDTH = 100)(
    input clk ,
    input [WIDTH-1:0] datain ,
    output [WIDTH-1:0] dataout
);

reg [WIDTH -1:0] pipe1_data;
reg [WIDTH -1:0] pipe2_data;
reg [WIDTH -1:0] pipe3_data;

always @( posedge clk ) begin
    pipe1_data <= datain ;
end

always @( posedge clk ) begin
    pipe2_data <= pipe1_data ;
end

always @( posedge clk ) begin
    pipe3_data <= pipe2_data ;
end

assign dataout = pipe3_data ;

endmodule
