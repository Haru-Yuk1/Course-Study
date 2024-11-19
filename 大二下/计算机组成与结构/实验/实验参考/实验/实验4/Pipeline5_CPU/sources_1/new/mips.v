`timescale 1ns / 1ps

module mips(
	input wire clk,
    input wire rst,
    input wire [31:0] mem_rdata,
	input wire [31:0] instr,	
	output wire [31:0] mem_wdata,
    output wire [31:0] pc,
    output wire inst_ram_ena,
    output wire data_ram_ena,  //Dataram�Ķ��ź�
    output wire data_ram_wea,  //ԭ��data_ram��wea��4λ����controller�з�����ָ����1λ�ģ��ʴ˴�����Ϊ1λ
    output wire [31:0] alu_result    
    );
	
	wire memtoreg,alusrc,regdst,regwrite,jump,regwriteM,memtoregE,regwriteE,memtoregM,branch;
	wire[2:0] alucontrol;
	wire [31:0] instrD;
	assign inst_ram_ena = 1'b1;    //����cpuһֱ���ڶ�ָ��ģ�����instr--ram--ena��Ϊ1
	//mips = datapath + controller
	controller c(.clka(clk),.rst(rst),.instr(instrD),.jump(jump),.branch(branch),.alusrc(alusrc),
		.memwrite(data_ram_wea),.memetoreg(memtoreg),.regwrite(regwrite),.regdst(regdst),
		.data_ram_ena(data_ram_ena),
    	.regwriteM(regwriteM),    //����datapath�е�hazard
		.memtoregE(memtoregE),    //����datapath�е�hazard
		.regwriteE(regwriteE),    //����datapath�е�hazard
		.memtoregM(memtoregM),    //����datapath�е�hazard
		.alucontrol(alucontrol)
	);
	datapath dp(.clka(clk),.rst(rst),.instr(instr),.mem_rdata(mem_rdata),.pc(pc),.writedataM(mem_wdata),
		.alu_resultM(alu_result),.memtoreg(memtoreg),.alusrc(alusrc),.regdst(regdst),
		.regwrite(regwrite),.jump(jump),.branch(branch),.regwriteM(regwriteM),.memtoregE(memtoregE),
		.regwriteE(regwriteE),.memtoregM(memtoregM),.alucontrol(alucontrol),.instrD_to_controller(instrD)
	);
	
endmodule


