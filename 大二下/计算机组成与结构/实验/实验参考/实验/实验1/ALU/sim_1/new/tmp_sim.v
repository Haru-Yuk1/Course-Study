`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/08 23:35:24
// Design Name: 
// Module Name: tmp_sim
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
/*����Vivado�����޷��ż���ʱ������򵥵ķ�ʽ�������������λ��λ*/

module tmp_sim();
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] C;
    tmp gate(A,B,C);
    
    initial begin
        A=5;
        B=3;
    end
    
always #50 A={$random}%256;
always #77 B={$random}%256;

endmodule
