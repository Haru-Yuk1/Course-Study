`timescale 1ns / 1ps
/*�Ĵ�����(32*32bits)ģ�飺���ڶ�дALU����ʱ�õ������ݣ����ж�ȡΪ����߼���д��Ϊʱ���߼�*/

module regfile(
	input wire clk,
	input wire we3,                //дʹ���ź�
	input wire[4:0] ra1,ra2,wa3,   //���˿�1,2��д�˿�3
	input wire[31:0] wd3,          //д����
	output wire[31:0] rd1,rd2      //������
    );

	reg [31:0] rf[31:0];           //�Ĵ�����

	always @(posedge clk) begin
		if(we3) begin
			 rf[wa3] <= wd3;
		end
	end

	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;     //Լ��0�żĴ���ֻ�洢0
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
