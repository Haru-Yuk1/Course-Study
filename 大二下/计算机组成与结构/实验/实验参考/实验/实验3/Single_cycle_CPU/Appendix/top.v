`timescale 1ns / 1ps
/*����ģ�飺����clk��rst�źţ�ִ��һ��ָ������Ҫд��Data memory������
    ��� datapath ��ָ��洢�����������ش����Ļ���ָ��Ĵ������������յ��������ź��൱����һ�����ڵĵ�ַ��
    ��˽�ָ��Ĵ����ĳ��½��ش�����������~clk
*/

module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite
    );
	wire[31:0] pc,instr,readdata;

	mips mp(clk,rst,instr,pc,memwrite,dataadr,writedata,readdata);
	Instr_mem imem(.clka(~clk),.addra({26'b0,pc[7:2]}),.douta(instr));
	Data_mem dmem(.clka(clk),.wea({3'b0,memwrite}),.addra(dataadr),.dina(writedata),.douta(readdata));
endmodule
