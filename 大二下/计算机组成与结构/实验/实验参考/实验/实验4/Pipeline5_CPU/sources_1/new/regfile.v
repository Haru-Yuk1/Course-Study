`timescale 1ns / 1ps
//�Ĵ�����ģ�飺������Ϊ����߼�����������ַ�����������ݣ�д����Ϊʱ���߼���дʹ�ܿ���
module regfile(
	input wire clk,
	input wire we3,                //дʹ��
	input wire[4:0] ra1,ra2,wa3,   //ra1��ra2Ϊ���ĵ�ַ��wa3Ϊд�ĵ�ַ
	input wire[31:0] wd3, 	        //д����
	output wire[31:0] rd1,rd2 	    //������
    );
	reg [31:0] rf[31:0];           //�Ĵ�����
	//д��ʱ���߼�
	always @(negedge clk) begin
		if(we3) begin
			 rf[wa3] <= wd3;
		end
	end
	//��������߼�
	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;  //0�żĴ�������0
	assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule
