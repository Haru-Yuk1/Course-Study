`timescale 1ns / 1ps
/* Controller������IR[31:26]��IR[5:0]�����
    memtoreg��д��register���������� ��R�ͣ�ALU������ or ��lw���洢����ȡ������
    memwrite���Ƿ���Ҫд��sw�����ݼĴ���
    pcsrc����һ����ַ�Ƿ�ΪPC+4
    alusrc������ALU B�˿ڵ�ֵ�ǣ�addi��32λ������ or ��R/sw/beq���Ĵ����Ѷ�ȡ������
    regdst��д��洢���ѵĵ�ַ�ǣ�lw��rt(0) or ��R�ͣ�rd(1) �����regwrite�źţ�
    regwrite���Ƿ���Ҫд�Ĵ����ѣ�R�͡�lw��Ҫд�ؼĴ����ѣ�
    branch���Ƿ�����branchָ�����ת����
    jump���Ƿ�Ϊjumpָ��
    alucontrol��ALU�����źţ�ֻҪ��ʵ��R��ָ���add��sub��and��or��slt
    �����źų���alucontrol��ALU decoder��������������������Main decoder��������м��ź�aluop
��Main decoder���������ALU decoder��

ԭ��32λMIPSָ���ڲ�ͬ����ָ���зֱ��в�ͬ�ṹ����IR[31:26]��ʾ��opcode��IR[5:0] ��ʾ��funct��
Ϊ����׶���ȷָ������źŵ���Ҫ�ֶΡ�����ʵ��Ҫ��ʵ��R��lw��sw��beq��addi��j��ָ������롣
    ���ڰ���Main decoder��ALU decoder����˷�ģ���д��Controller������á�Main decoder����IR[31:26]
��Ϊopcode�����memtoreg��memwrite��pcsrc��alusrc��regdst��regwrite��branch��jump��aluop��ALU decoder
����aluop��IR[5:0]��Ϊfunct�����alu control
*/

module controller(
    input wire[5:0] op,
    input wire[5:0] funct,
    output wire[2:0] aluctrl,
    output wire memtoreg,memwrite,alusrc,regdst,regwrite,branch,jump
);
    wire[1:0] aluop;
    maindec gate1(op,aluop,memtoreg,memwrite,alusrc,regdst,regwrite,branch,jump);
    aludec gate2(aluop,funct,aluctrl);
    
endmodule
