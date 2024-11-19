`timescale 1ns / 1ps
/*Controllerģ�飺���벿��ԭ��ͬʵ������˴���������ź�ʱ����ֱ�����8bit sigs�����ǵ��������
    ��ģ�鲻��������룬����Ҫ�ٿ�ÿһ����ˮ�ߺ���ˮ�߼Ĵ���֮������ݽ�������Ϊ���ź����λ�ã�
    jump��branch��Main Decoder��
    alucontrol��alusrc��regdst��regwriteE��memtoregE����ˮ�߼Ĵ���DE��
    memwrite��data_ram_ena��memtoregM��regwriteM����ˮ�Ĵ���EM��
    regwrite��memtoreg����ˮ�Ĵ���MW��
    ����regwriteE,memtoregM,regwriteM,memtoregE��Ϊ����datapath�е�hazardģ�飬����ð�����
*/
module controller(
    input clka,rst,
    input wire [31:0] instr,
    output wire jump,branch,alusrc,memwrite,memetoreg,regwrite,regdst,data_ram_ena,regwriteE,memtoregM,
    output wire regwriteM,  //regwriteE,memtoregM,regwriteM,memtoregE����datapath�е�hazard��Ҫ
    output wire memtoregE,
    output wire [2:0] alucontrol
    );
//����instr[31:26]��instr[5:0]����
    wire [1:0] aluop;       //Main Decode�����aluop�źţ�����ALU Decoder
    wire [7:0] sigsD;       //Main Decode�����8bit�����ź�
    //main_dec ʵ����
    main_dec Main_Decoder(.op(instr[31:26]),.sigs(sigsD),.aluop(aluop));
    wire [2:0] alucontrolD; //ALU Decoder�����ALU�����źţ�������ˮ�߼Ĵ���
    //alu_dec ʵ����
    alu_dec ALU_Control(.funct(instr[5:0]),.op(aluop),.alucontrol(alucontrolD));
    assign jump = sigsD[7]; //jump��branch�źŲ��ü������䣬ֱ�Ӵ�����һ��ָ���Լ��ٿ���ð��
    assign branch = sigsD[3];
    
//��ˮ�߼Ĵ���DE������ݽ�����{regwrite,regdst,alusrc,memwrite,memetoreg,data_ram_ena}��ALUControlD
    wire [5:0] sigsE;       //{regwrite,regdst,alusrc,memwrite,memetoreg,data_ram_ena}
    wire [2:0] alucontrolE; //����ˮ�߼Ĵ���DE������ALU�����ź�
    floprc #(6) r1E(.clk(clka),.rst(rst),.clear(1'b0),.d({sigsD[6:4],sigsD[2:0]}),.q(sigsE));
    floprc #(3) r2E(.clk(clka),.rst(rst),.clear(1'b0),.d(alucontrolD),.q(alucontrolE));
    assign regdst = sigsE[4];
    assign alusrc = sigsE[3];
    assign alucontrol = alucontrolE;
    assign memtoregE = sigsE[1];
    assign regwriteE = sigsE[5];
    
//��ˮ�߼Ĵ���EM������ݽ�����{regwrite,memwrite,memetoreg,data_ram_ena}
    wire [3:0] sigsM;
    floprc #(4) r1M(.clk(clka),.rst(rst),.clear(1'b0),.d({sigsE[5],sigsE[2:0]}),.q(sigsM));
    assign memwrite = sigsM[2];
    assign data_ram_ena = sigsM[0];
    assign regwriteM = sigsM[3];  //����datapath�е�hazard��Ҫ
    assign memtoregM = sigsM[1]; //����datapath�е�hazard��Ҫ
    
//��ˮ�߼Ĵ���MW������ݽ�����{regwrite,memwrite,memetoreg}
    wire [1:0] sigsW;
    floprc #(2) r1W(.clk(clka),.rst(rst),.clear(1'b0),.d({sigsM[3],sigsM[1]}),.q(sigsW));
    assign regwrite = sigsW[1];
    assign memetoreg = sigsW[0];

endmodule