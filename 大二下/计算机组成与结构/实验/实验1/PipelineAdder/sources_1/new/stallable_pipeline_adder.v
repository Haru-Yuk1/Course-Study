`timescale 1ns / 1ps

/*ʵ��Ҫ��
  1.ʵ��4����ˮ��32bitȫ������ÿһ������8bit�ӷ����㣬�������ˮ����ͣ��ˢ�£�
  2.ģ����ˮ����ͣ������ʱ����10���ں���ͣ��ˮ��2���ڣ���2��������ˮ�߻ָ�������
  3.ģ����ˮ��ˢ�£�����ʱ����15����ʱ��ˮ��ˢ�£���3������
  ��ˮ�ߵ��������ڽ�������ֽ��С���⣬�����10000��a��b��ӣ���ˮ��ֻ��Ҫ(10000+3)T
������ӷ�����Ҫ10000*4T
  ʵ��˼·����32λ���ݷ�Ϊ4������1������a[7:0]+b[7:0]����2������a[8:15]+b[8:15]����3��
����a[16:23]+b[16:23]����4������a[24:31]+b[24:31]������ÿ��֮�������ˮ�߼Ĵ������洢
��λ����û�ӵ������Լ��Ѿ��ӵõĺ�
  ʵ�黹Ҫ��ʵ�ֶԸ����ֱ���ͣ��ˢ�£�ԭ�����Ǽ���valid��¼����֮���Ƿ���Դ������ݣ���
����if...elseȡ��
��ĳһ������ͣ����ǰ��ļ�������ִ���굱ǰ����Ȼ����ͣ�����漸����ִ�����Ȼ����ͣ��
��ĳһ����ˢ�£���ü�������ȫ�����㣬ֻӰ��һ�ν��
  ע�⣺��ˮ��Ӧ�ò��÷�������ֵ��������ˮ��˼�룬������ͬһ���ڼ�������
*/

module stallable_pipeline_adder(
    input clk,
    input [3:0] refresh,    //��ˮ��ˢ��
    input [3:0] halt,       //��ˮ����ͣ
    input [31:0] cin_a,     //����a
    input [31:0] cin_b,     //������b
    input c_in,             //ǰһ���Ե�ǰ���Ľ�λ
    output reg c_out,       //��ǰһ���Ժ�һ���Ľ�λ
    output reg[31:0] sum_out    //��
    );
    reg c_out_12,c_out_23,c_out_34;    //��ˮ�߼Ĵ������洢��λ
    //reg [7:0] sum1,sum2,sum3;         //��Ϊ��ˮ�߼Ĵ���ÿһ��clk�������ᱻ���ǣ����Բ���ÿһ��8λ�ȵ����ϲ�
    reg [7:0] sum1;                     //��ˮ�߼Ĵ������洢��ǰ��
    reg [15:0] sum2;
    reg [23:0] sum3;
    reg [23:0] tmpa1,tmpb1;             //�洢��û�����23λa��b
    reg [15:0] tmpa2,tmpb2;
    reg [7:0] tmpa3,tmpb3;
    //assign tmpa1=cin_a[31:8];         //������assign������ֵ��������һ���ڴ����µ�a��һ���ڵ�a�ᱻ����

//    reg go1,go2,go3;                    //��ʾĳһ����������һ��������
//    reg come2,come3,come4;              //��ʾĳһ�����������һ������
//    wire valid_12,valid_23,valid_34;    //��ʾĳ����֮������������
//    assign valid_12=go1&come2;          //ǰ������ͬʱ����ſ��Դ�������
//    assign valid_23=go2&come3;
//    assign valid_34=go3&come4;

    // pipeline 1
    always@(posedge clk)begin
        if(halt[0])begin
        //1����ˮ����ͣ��ʹ�ú�����ˮ�������ͷ������ͣ�£������2����Z
            {c_out_12,sum1}<='bz;
            tmpa1<='bz;
            tmpb1<='bz;
        end
        else if(refresh[0])begin
            {c_out_12,sum1}<=9'b0;
            tmpa1<=24'b0;
            tmpb1<=24'b0;
        end
        else begin                      //pipeline 1���ÿ��Ǳ�ǰһ����ͣ
            {c_out_12,sum1}<=cin_a[7:0]+cin_b[7:0];
            tmpa1<=cin_a[31:8];
            tmpb1<=cin_b[31:8];
//            go1<=1;
        end
    end
    // pipeline 2
    always@(posedge clk)begin
        if(halt[1])begin
        //2����ˮ����ͣ��1��û��Ӱ�죬2�����Բ�ʹ��1�����������
            {c_out_23,sum2}<='bz;
            tmpa2<='bz;
            tmpb2<='bz;
        end
        else if(refresh[1])begin
            {c_out_23,sum2}<=17'b0;
            tmpa2<=16'b0;
            tmpb2<=16'b0;
        end
        else begin
            if(c_out_12===1'bz)begin    //ǰһ����ͣ
                sum2[7:0]<='bz;
                {c_out_23,sum2[15:8]}<='bz;
                tmpa2<='bz;
                tmpb2<='bz;
            end
            else begin
                sum2[7:0]<=sum1;
                {c_out_23,sum2[15:8]}<=tmpa1[7:0]+tmpb1[7:0]+c_out_12;
                tmpa2<=tmpa1[23:8];
                tmpb2<=tmpb1[23:8];
    //            go2<=1;
    //            come2<=1;
            end
        end
    end
    // pipeline 3
    always@(posedge clk)begin
        if(halt[2])begin
            {c_out_34,sum3}<='bz;
            tmpa3<='bz;
            tmpb3<='bz;
        end
        else if(refresh[2])begin
            {c_out_34,sum3}<=25'b0;
            tmpa3<=8'b0;
            tmpb3<=8'b0;
        end
        else begin
            if(c_out_23===1'bz)begin    //ǰһ����ͣ
                sum3[15:0]<='bz;
                {c_out_34,sum3[23:16]}<='bz;
                tmpa3<='bz;
                tmpb3<='bz;
            end
            else begin
                sum3[15:0]<=sum2;
                {c_out_34,sum3[23:16]}<=tmpa2[7:0]+tmpb2[7:0]+c_out_23;
                tmpa3<=tmpa2[15:8];
                tmpb3<=tmpb2[15:8];
    //            go3<=1;
    //            come3<=1;
            end
        end
    end
    // pipeline 4
    always@(posedge clk)begin
        if(halt[3])begin
//            {c_out,sum_out}<=33'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;    //����32λ����
            c_out<='bz;
            sum_out<='bz;
        end
        else if(refresh[3])begin
            c_out<='b0;
            sum_out<='b0;
        end
        else begin
            if(c_out_34===1'bz)begin
                sum_out[23:0]<='bz;
                {c_out,sum_out[31:24]}<='bz;
            end
            else begin
                sum_out[23:0]<=sum3;
                {c_out,sum_out[31:24]}<=tmpa3[7:0]+tmpb3[7:0]+c_out_34;
    //            come4<=1;
            end
        end
    end

    
endmodule
