`timescale 1ns / 1ps
/*ð�ս����������ð�գ�����ǰ��+��ˮ����ͣ��������ð�գ���ǰ�жϷ�֧���µ�����ǰ�ơ���ˮ����ͣ
    ������ˮ����ͣʱ��Ҫ�����һ����ˮ�ߡ���ǰ�жϷ�֧����datapath��ʵ�֣�������hazard��ʵ��
*/
module hazard(
    input wire rst,
    input wire [4:0] rsD,       //instr2[25:21]��ͬһʱ��rsD��rsE��Ӧ�Ⱥ�����ָ���rs�ֶΣ�������ͬ��
    input wire [4:0] rtD,       //instr2[20:15]
    input wire [4:0] rsE,       //instr1[25:21]
    input wire [4:0] rtE,       //instr1[20:15]
    input wire regwriteE,       //�Ĵ����ѵ�дʹ���źţ�E��M��W��ʾexcute��memory��writeback�׶Σ�
    input wire regwriteM,  
    input wire regwriteW,  
    input wire memtoregE,       //�ж�д�ؼĴ����ѵ�������sw��ReadData(0)����R��ALUOut(1)
    input wire memtoregM,
    input wire branchD,         //��ǰ�жϷ�֧
    input wire [4:0] writeregE, //�Ĵ����ѵ�д��ַ������wa3W
    input wire [4:0] writeregM,
    input wire [4:0] writeregW,
    output [1:0] forwordAE,     //��excute�׶ο���mux3ѡ��SrcA������ð�գ�
    output [1:0] forwordBE,     //��excute�׶ο���mux3ѡ��SrcB
    output [1:0] forwordAD,     //��decode�׶ο��ƶ�ѡһѡ��regfile rd1���������ݣ�����ð���µ�����ð�գ�
    output [1:0] forwordBD,     //��decode�׶ο��ƶ�ѡһѡ��regfile rd2����������
    output reg stallF,          //instr fetch����ͣ
    output reg stallD,          //decoder��ͣ
    output reg flushE           //excute��������ˮ����Ҫ���
    );
//����ǰ�ƽ��Rָ���ǰ����lwָ�������ð��
    /*ALU�˿�SrcAE�����ݿ������ԣ���ע���ж�reE!=0������������Ĵ���ֱ�������
        �Ĵ����ѣ���ð������£���forwordAE=00��SrcAE=RsD
        ���ݴ洢��(lw������ð��)��forwordAE=01��SrcAE=ResultW��lwָ��д�ؼĴ�������MEM�׶Σ����ڶ���ָ������Ҫ�����ݻ���Ӱ�죩
        ALUOut��ALU���������ð�գ���forwordAE=10��SrcAE=ALUOutM��R��ָ��д�ؼĴ�������WB�׶Σ����һ��ָ������Ҫ�����ݶ�����Ӱ�죩
    */
    assign forwordAE = ((rsE != 5'b0) & (rsE == writeregM) & regwriteM) ? 2'b10:    //ǰһ��ָ����R�ͣ�ֱ�ӽ�ALUOut����
                       ((rsE != 5'b0) & (rsE == writeregW) & regwriteW) ? 2'b01:    //ǰ����ָ����lw
                        2'b00;
    assign forwordBE = ((rtE != 5'b0) & (rtE == writeregM) & regwriteM) ? 2'b10:    //SrcBEͬSrcAE
                       ((rtE != 5'b0) & (rtE == writeregW) & regwriteW) ? 2'b01:
                        2'b00;
//��ǰ�жϷ�֧���beq��2��3��ָ��Ŀ���ð��ʱ���ֵ�����ð��
    assign forwordAD = ((rsD != 5'b0) & (rsD == writeregE) & regwriteE);            //ǰһ��ָ��Ҫд�ؼĴ������Ҹ����ݱ�beqָ������
    assign forwordBD = ((rtD != 5'b0) & (rtD == writeregE) & regwriteE);
//��ˮ����ͣ���lw��һ��ָ����Ҫ�üĴ��������ݴ���������ð�ա�beq��Ҫ��ǰһ��ָ��д�ؼĴ����ѵ�����
    /*lwָ��д��Ĵ����ѵĵ�ַΪrt�������һ��ָ����Ҫ�õ�rt����Ҫ��ͣ����rsD==rtE��rtD==rtE
      beqָ����Ҫrs��rt�żĴ��������ݣ�����һ��ָ��Ҫд���üĴ���������Ҫ��ͣ��ˮ��
    */
    wire lwstall,branch_stall;                                      //��ˮ����ͣ�ź�
    assign lwstall = (((rsD == rtE) | (rtD == rtE)) & memtoregE);   //�ж�ǰһ��ָ����Ҫ�ԼĴ�����д��(memturegE)����д���ַrtE�뱻��ǰָ���õ�
    assign branch_stall=( branchD&regwriteE&((writeregE==rsD)|(writeregE==rtD)) )   //��ǰָ��Ϊbranch����һ��ָ��Ҫд�Ĵ�������д�����ݵ�ǰҪ��
                       |( branchD&memtoregM&((writeregM==rsD)|(writeregM==rtD)) );  //��ǰָ��Ϊbranch����2��ָ��Ҫд�Ĵ�������д�����ݵ�ǰҪ��
    always @(*)begin
        stallF = rst? 1'b0 : (lwstall | branch_stall);      //����������ȫ������
        stallD = rst? 1'b0 : (lwstall | branch_stall);      //lw����������ð�ջ���ǰ�жϷ�֧����������ð�ն�������ͣ��ˮ��
        flushE = rst? 1'b0 : (lwstall | branch_stall);      //lw/beq��һ���Ѿ�ִ�е���Ҫ���
    end

endmodule

