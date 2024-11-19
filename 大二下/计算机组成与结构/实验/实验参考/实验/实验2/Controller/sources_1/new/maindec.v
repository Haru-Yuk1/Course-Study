`timescale 1ns / 1ps
/* Main decoder�����������opcode�ж�ָ�����ͣ�����õ���Ԫ���Ŀ����ź�
    aluop[1:0]��alu�����ź�
    memtoreg��д��register���������� ��R�ͣ�ALU������ or ��lw���洢����ȡ������
    memwrite���Ƿ���Ҫд��sw�����ݼĴ���
    //pcsrc����һ����ַ�Ƿ�ΪPC+4        //����Controller��ʵ��
    alusrc������ALU B�˿ڵ�ֵ�ǣ�addi��32λ������ or ��R/sw/beq���Ĵ����Ѷ�ȡ������
    regdst��д��洢���ѵĵ�ַ�ǣ�lw��rt(0) or ��R�ͣ�rd(1) �����regwrite�źţ�
    regwrite���Ƿ���Ҫд�Ĵ����ѣ�R�͡�lw��Ҫд�ؼĴ����ѣ�
    branch���Ƿ�����branchָ�����ת����
    jump���Ƿ�Ϊjumpָ��
*/

module maindec(
    input [5:0] op,              //����opcode
    output reg[1:0] aluop,      //���alu�����ź�
    output reg memtoreg,memwrite,alusrc,regdst,regwrite,branch,jump
);
    always@(*)begin
        case(op)
            6'b000000:begin     //R��
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b1100000;  //˳��ָ�����5
                aluop=2'b10;
            end
            6'b100011:begin     //lw
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b1010010;
                aluop=2'b00;
            end
            6'b101011:begin     //sw
//                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b0z101z0;
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b0010100;
                aluop=2'b00;
            end
            6'b000100:begin     //beq
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b0001000;
                aluop=2'b01;
            end
            6'b001000:begin     //I��(addi)
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b1010000;
                aluop=2'b00;
            end
            6'b000010:begin     //jump
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}=7'b0000001;
                aluop=2'b00;
            end
            default:begin
                {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump}='b0;
                aluop=2'b00;
            end
        endcase
    end
endmodule
