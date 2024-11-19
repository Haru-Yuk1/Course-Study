`timescale 1ns / 1ps
/*����Ҫ��
1.ģ����ˮ����ͣ������ʱ���� 10 ���ں���ͣ��ˮ�� 2 ���ڣ��� 2 ��������ˮ�߻ָ�������
2.ģ����ˮ��ˢ�£�����ʱ���� 15 ����ʱ��ˮ��ˢ�£��� 3 ������
ע�⣺������Ӧ���÷�������ֵ��
*/

module stallable_pipeline_adder_sim();
    reg clk;
    reg[3:0] refresh;
    reg[3:0] halt;
    reg[31:0] cin_a;
    reg[31:0] cin_b;
    reg c_in;
    wire c_out;
    wire[31:0] sum_out;
    stallable_pipeline_adder gate(clk,refresh,halt,cin_a,cin_b,c_in,c_out,sum_out);
    
    initial begin
        clk=0;refresh=0;halt=0;cin_a=0;cin_b=0;c_in=0;
        #50 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //75ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //125ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //175ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //225ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //275ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //325ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //375ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //425ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //475ns
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //525ns||10����
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;;halt[1]<=1; //2����ˮ����ͣ
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;halt[1]<=0;    //��ˮ�߻ָ�
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;  //14����
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;refresh[2]<=1;
        #25 clk<=0;refresh[2]<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
        #25 clk<=1;cin_a<={$random}%4096;cin_b<={$random}%4096;c_in<={$random}%2;
        #25 clk<=0;
    
    end
endmodule
