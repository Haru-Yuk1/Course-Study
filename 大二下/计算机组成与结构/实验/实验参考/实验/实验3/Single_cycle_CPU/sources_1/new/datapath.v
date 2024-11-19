`timescale 1ns / 1ps
/*����ͨ·ģ�飺��Controller����Ŀ����źŴ���datapath��Controller�����memwrite����Data memory������
�ľ�����datapath����������Data memory�����data��Instruction memory�����IR�����ALU��������д����
�ݡ�pc�ź��Լ�zero�ź�
    datapathģ��������ģ�飺��Ҫ���Է�ΪPC��Data�������֣�
        PC���֣�PC->PC+4->�ж�branch(IR[15:0]<<2+PC+4)->�ж�jump({PCPlus4[31:28],IR[25:0]<<2})->����PC
        Data���֣�IR-�Ĵ�����->RD1��RD2(��SignImmѡ��)-ALU->ALUReult��WriteData-DataMem->ReadData��ALUResult->Result
*/

module datapath(
    input clk,rst,
    input[2:0] aluctrl,
    input memtoreg,alusrc,regdst,regwrite,pcsrc,jump,   //pcsrc=branch&zero�����ⲿ����
    input[31:0] readdata,               //lwָ���Data memory������ָ��
    input[31:0] IR,
    output[31:0] aluresult,
    output[31:0] writedata,
    output[31:0] pc_out,
    output zero
    );
    //PC����
    wire[31:0] PC_1,PC_2,PC,PCPlus4;    //PC_1Ϊ�ж�branch��ĵ�ַ�źţ�PC_2Ϊ�ж�jump��ĵ�ַ�ź�
    assign pc_out=PC;
    pc gate1(clk,rst,PC_2,PC);          //PCģ��
    adder gate2(PC,32'h00000004,PCPlus4);      //PC+4
    
    wire[31:0] SignImm;
    wire[15:0] tmp;
    assign tmp=IR[15:0];
    signext gate3(tmp,SignImm);    //lw��sw��addi��beqָ����Ҫ��IR[15:0]������չ
    
    wire[31:0] PCBranch_in;
    wire[31:0] PCBranch_out;
    sl2 gate4(SignImm,PCBranch_in);
    adder gate5(PCBranch_in,PCPlus4,PCBranch_out);      //����branch��תָ��
    
    mux2 gate6(PCPlus4,PCBranch_out,pcsrc,PC_1);        //�ж��Ƿ�ִ��branch
    mux2 gate7(PC_1,{PCPlus4[31:28],IR[25:0],2'b00},jump,PC_2);    //�ж��Ƿ�ִ��jump
    
    //Data����
    wire[4:0] WriteReg;                 //д�Ĵ�����
    wire[31:0] Result;                  //д�ؼĴ�������
    wire[31:0] RD1,RD2;                 //�Ĵ����Ѷ�������
    assign writedata=RD2;
    mux2 #(5) gate8(IR[20:16],IR[15:11],regdst,WriteReg);    //�ж�д�Ĵ�����
    regfile gate9(clk,regwrite,IR[25:21],IR[20:16],WriteReg,Result,RD1,RD2);
    
    wire[31:0] SrcB,ALUResult;
    assign aluresult=ALUResult;
    mux2 gate10(RD2,SignImm,alusrc,SrcB);               //�ж�RD2 or SignImm
    alu gate11(aluctrl,RD1,SrcB,ALUResult,zero);        //ALU����
    
    mux2 gate12(ALUResult,readdata,memtoreg,Result);    //�ж�д�ؼĴ����ѵ���ALU�ļ����� or lw��ȡ��data
        
endmodule
