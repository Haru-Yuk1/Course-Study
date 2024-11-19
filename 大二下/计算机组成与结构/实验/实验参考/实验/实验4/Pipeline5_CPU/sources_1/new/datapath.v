`timescale 1ns / 1ps

module datapath(
    input wire clka,rst,
    input wire [31:0] instr,
    input wire [31:0] mem_rdata,    //data_ram�ж���������
    output wire [31:0] pc,
    output wire [31:0] alu_resultM,
    output wire [31:0] writedataM,
    input wire memtoreg,		
	input wire alusrc,
	input wire regdst,
	input wire regwrite,
	input wire jump,
	input wire branch,
    input wire regwriteM,
    input wire memtoregE,
    input wire regwriteE,
    input wire memtoregM,
	input wire [2:0] alucontrol,
    output wire [31:0] instrD_to_controller//��datapath�д���������instr����ΪD�׶εĲ���ʹcontroller����ƥ�䡣ͬʱinstrD��harzard���ƣ������datapath�д�����
    );
    wire [31:0] pc_next;        //pc+4�����һλpc
    wire [31:0] pc_next_jump;   //ѡ��pc+4?branch���ٴ�ѡ���Ƿ�jump���PCֵ
    wire [31:0] rd1D;           //regfile�����rd1
    wire [31:0] rd2D;           //regfile�����rd2
    wire [31:0] imm_extend;     //i��ָ��16λimm�з�����չ��32λ
    wire [31:0] alu_result;     //alu������
    wire [31:0] alu_srcB;       //alusec���Ƶõ���alu_srcB
    wire [31:0] wd3;            //дregfile����(ReadData ? ALUOut)
    wire [4:0] wa3;             //дregfile�ļĴ����ţ�rt ? rd��
    wire [31:0] imm_sl2;        //imm_extend����2λ����branchָ���¹�����
    wire [31:0] pc_branch;      //branch��֧��ַ
    wire [31:0] pc_plus_4;      //pc+4
    wire [31:0] instr_jump_offset_sl2; //jumpָ���е�26λƫ�Ƶ�ַ������λ��Ľ����������32λ������λ����������
    wire pcsrc;                 //�ж�pc ��branchָ�����ܷ�ִ��
    wire zero;                  //��ǰ�жϷ�֧���Ƚ�branchָ�����Ƿ����
    wire [31:0] mux3_A_result;
    wire [31:0] mux3_B_result;
    //F-D���ź�
    wire [31:0] instrD;
    wire [31:0] pc_plus_4D;
    //D-E���ź�
    wire [31:0] rd1E;
    wire [31:0] rd2E;
    wire [31:0] pc_plus_4E;
    wire [31:0] imm_extendE;
    wire [4:0] rsE;             //instr[25:21]������hazardģ��
    wire [4:0] rtE;             //filereg��д��ַʱ rt�ĵ�ַ ����mux wa3
    wire [4:0] rdE;             //filereg��д��ַʱ rd�ĵ�ַ ����mux wa3
    //E-M���ź�
    wire [31:0] pc_branchM;     //branchָ����pc��ת���
    wire [4:0] wa3M;            //ѡ��rd����rsд�����ݵĽ��
    //M-W���ź�
    wire [31:0] alu_resultW;    //��д��aluresult���͵�ѡ����ȥ
    wire [31:0] mem_rdataW;     //Data_ram�ж������͵�writeback�׶ε�ѡ����
    wire [4:0] wa3W;            //ѡ��rd����rsд�����ݵĽ��
    wire zeroM;
    //hazard�������ӳ���ˢ���ź�
    wire stallF,stallD,flushE;
    //����ǰ�ƿ�����
    wire [1:0] forwordAE,forwordBE;
    wire forwordAD,forwordBD;
    wire equalD;
    //pcSrc���ж�
    assign pcsrc = branch & equalD;
    mux2 #(32) mux_pc_next(
        .a(pc_branch),          //branch����ת
        .b(pc_plus_4),
        .s(pcsrc),              //����pcSrc
        .y(pc_next)  
        );
    //jָ��ĵ�26λΪ�ֵ�ַ��������λ�õ��ֽڵ�ַ��������PC��4λƴ��
    shift_2 sl2_pc_jump(
        .a(instrD),
        .y(instr_jump_offset_sl2)  //�õ�jumpָ����ƫ�Ƶ�ַ������λ��Ľ�����˴�Ϊ32λ����4λ����
        );
    //jָ�����ת��ַ
    wire [31:0] jump_addra;
    assign jump_addra = {pc_plus_4[31:28],instr_jump_offset_sl2[27:0]} +4;
    //PC��ת
    mux2 #(32) mux_pc_jump(
        .a(jump_addra), //jumpָ���µĵ�ַ��ת
        .b(pc_next),    //PC+4
        .s(jump),       //jump�ж��ź�
        .y(pc_next_jump)  
        );
    //�ж���branchָ��ʱ�Ƿ�Ҫ���pc����ˮ���ӳٵ���branch��һ��ָ��ִ�У�
    wire pc_en;
    assign pc_en = ~(stallF & pcsrc);
    //PC
    pc pc_module(.clk(clka),.rst(rst),.en(1'b1),.din(pc_next_jump),.q(pc));
    //PC+4
    adder pc_plus_4_module(.a(pc),.b(32'h4),.y(pc_plus_4));
//��ˮ�߼Ĵ��������ź�
    wire F_D_en;
    assign F_D_en = ~(stallD & pcsrc);
    //F-D���ݴ���
    flopenrc #(32) r1D(.clk(clka),.rst(rst),.en(F_D_en),.clear(1'b0),.d(instr),.q(instrD));
    flopenrc #(32) r2D(.clk(clka),.rst(rst),.en(F_D_en),.clear(1'b0),.d(pc_plus_4),.q(pc_plus_4D));
    
    assign instrD_to_controller = instrD;//��datapath�д���������instr����ΪD�׶εĲ���ʹcontroller����ƥ�䡣ͬʱinstrD��harzard���ƣ������datapath�д�����
    
    //instr��16λƫ�Ƶ�ַ��չ������
    sign_extend sign_extend(.a(instrD[15:0]),.y(imm_extend));
    shift_2 sl2(.a(imm_extend),.y(imm_sl2));
    //����branchʱPC�Ѿ�+4�ˣ�Ҫ��ԭ
    wire [31:0] pc_plus_4D_for_brach;
    assign pc_plus_4D_for_brach = pc_plus_4D - 4;
    adder pc_branch_module(.a(pc_plus_4D_for_brach),.b(imm_sl2),.y(pc_branch));
    //�Ĵ�����
    regfile regfile(
        .clk(clka),
        .we3(regwrite),                 //дʹ�� 
        .ra1(instrD[25:21]),            //���Ĵ�����1
        .ra2(instrD[20:16]),            //���Ĵ�����2
        .wa3(wa3W),                     //д��ַ
        .wd3(wd3), 	                    //д����
        .rd1(rd1D),                     //������1
        .rd2(rd2D) 	                    //������2
        );
    
    wire [31:0] rd1_1sle_branch_A,rd2_1sle_branch_B;
    //rd1_decode_sle_branch_A
    mux2 #(32) mux_rd1_1sle_branch_A(
        .a(alu_result),                 //jumpָ���µĵ�ַ��ת
        .b(rd1D),
        .s(forwordAD),                  //jump
        .y(rd1_1sle_branch_A)  
        );
    //rd2_decode_sle_branch_B
    mux2 #(32) mux_rd2_1sle_branch_B(.a(alu_result),.b(rd2D),.s(forwordBD),.y(rd2_1sle_branch_B));
    //��ǰ�жϷ�֧���ٿ���ð��
    assign equalD = (rd1_1sle_branch_A == rd2_1sle_branch_B);
    //�ж�branchʱ�Ƿ�Ҫ���excute����ˮ��
    wire D_E_en;  
    assign D_E_en = flushE & pcsrc;
    
    //D-E���ݴ���
    flopenrc #(32) r1E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(rd1D),.q(rd1E));
    flopenrc #(32) r2E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(rd2D),.q(rd2E));
    flopenrc #(5) r3E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(instrD[20:16]),.q(rtE));
    flopenrc #(5) r4E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(instrD[15:11]),.q(rdE));
    flopenrc #(32) r5E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(pc_plus_4D),.q(pc_plus_4E));
    flopenrc #(32) r6E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(imm_extend),.q(imm_extendE));
    flopenrc #(5) r7E(.clk(clka),.rst(rst),.en(1'b1),.clear(D_E_en),.d(instrD[25:21]),.q(rsE));
    
    //����regfile��wa3,ѡ��д�����ĵ�ַ��rt��lw������rd��r-type��
    mux2 #(5) mux_wa3(
        .a(rdE),            //rt�ĵ�ַ
        .b(rtE),            //rd�ĵ�ַ
        .s(regdst),         //regdst
        .y(wa3)
        );
    
    mux3 #(32) srcA_sel3(.d0(rd1E),.d1(wd3),.d2(alu_resultM),.s(forwordAE),.y(mux3_A_result));
    
    mux3 #(32) srcB_sel3(.d0(rd2E),.d1(wd3),.d2(alu_resultM),.s(forwordBE),.y(mux3_B_result));
    
    //alu_srcB
    mux2 #(32) mux_alu_srcb(.a(imm_extendE),.b(mux3_B_result),.s(alusrc),.y(alu_srcB));
    //ALU
    alu alu(.a(mux3_A_result),.b(alu_srcB),.op(alucontrol),.result(alu_result),.zero(zero));

    //E-M���ݴ���
    flopenrc #(32) r1M(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(alu_result),.q(alu_resultM));
    flopenrc #(1) r2M(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(zero),.q(zeroM));
    flopenrc #(32) r3M(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(mux3_B_result),.q(writedataM));
    flopenrc #(32) r4M(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(pc_branch),.q(pc_branchM));
    flopenrc #(5) r5M(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(wa3),.q(wa3M));
    
    //M-W���ݴ���
    flopenrc #(32) r1W(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(alu_resultM),.q(alu_resultW));
    flopenrc #(32) r2W(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(mem_rdata),.q(mem_rdataW));
    flopenrc #(5) r3W(.clk(clka),.rst(rst),.en(1'b1),.clear(1'b0),.d(wa3M),.q(wa3W));
    
    //wd3
    mux2 #(32) mux_wd3(.a(mem_rdataW),.b(alu_resultW),.s(memtoreg),.y(wd3));
    
    hazard hazard(.rst(rst),.rsD(instrD[25:21]),.rtD(instrD[20:16]),.rsE(rsE),.rtE(rtE),
        .regwriteE(regwriteE),.regwriteM(regwriteM),.regwriteW(regwrite),.memtoregE(memtoregE), 
        .memtoregM(memtoregM),.branchD(branch),.writeregE(wa3),.writeregM(wa3M),.writeregW(wa3W),
        .forwordAE(forwordAE),.forwordBE(forwordBE),.forwordAD(forwordAD),.forwordBD(forwordBD),
        .stallF(stallF),.stallD(stallD),.flushE(flushE));

endmodule

