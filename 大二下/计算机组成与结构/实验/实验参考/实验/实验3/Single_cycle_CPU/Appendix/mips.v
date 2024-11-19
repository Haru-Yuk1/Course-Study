`timescale 1ns / 1ps
/*MIPSָ���ģ�飺����clk��rst��ָ�������
ע�⣺controllerΪ������߼����������κδ洢���ܣ�datapathΪʱ���߼�����Ҫʱ���źſ��ơ���Ϊ��ʵ
    ���ǵ�����CPU����datapath��Ϊһ������(��ͬһ��ʱ���źſ���)��ָ��Ĵ���ȡָ�datapath���ݴ�
    �䡢Data memory��ȡ���ݶ���Ҫ��ͬһ��ʱ����������ɡ����Instruction memory��Data memory����
    ���½��ش�����Datapath���������ش�������clk�����ص���ʱ��Datapath�������IR�͸������źŽ�����
    �㣬���PC��WriteData��ALUOut��clk�½�������ʱ��Data memory��WriteDataд��(sw)/ALUOutȡ��(lw)/
    ALUOut����(R)��ͬʱInstruction memoryȡָ������ȵ���һ��clk���������٣�Datapath���մ��ص�
    ReadData(lw)/ALUOut(R)д�ؼĴ����ѡ����˴�������һ����ͻ������һ��ָ����Ҫ�õ���һ��д�صļ�
    �����������ݣ���ʵ����ʱ�����Ǵ˳�ͻ��    
*/
module mips(
	input wire clk,rst,
	input wire[31:0] IR,
	output wire[31:0] pc_out,	
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata 
    );
	wire[2:0] aluctrl;
	wire memtoreg,alusrc,regdst,regwrite,branch,jump,pcsrc,zero;
	assign pcsrc=branch&zero;

	controller gate15(IR[31:26],IR[5:0],aluctrl,memtoreg,memwrite,alusrc,regdst,regwrite,branch,jump);
	datapath gate16(clk,rst,aluctrl,memtoreg,alusrc,regdst,regwrite,pcsrc,jump,readdata,IR,aluout,writedata,pc_out,zero);

endmodule
