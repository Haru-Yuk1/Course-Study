`timescale 1ns / 1ps
//pcģ�飺����ʱ���źż����������ǰָ���ַ
//addr������ֵ�����������⣬��һ��ָ��ᱻ�̵�
module pc(
    input clk,rst,
    output reg[31:0] addr=0,    //����ָ��Ĵ����������ַ�˿�
    output wire ena             //����ָ��Ĵ�����ʹ�ܶ˿�
);
    reg [31:0] cnt=0;           //��ַ����������+4
    assign ena=(addr<1024)?1:0; //ROM���õĶ˿�DepthΪ1024�����>1024�ĵ�ַΪ��Ч��ַ
//    assign ena =1;
    always@(posedge clk)begin
        if(rst)begin
            cnt=0;
            addr=cnt;
        end
        else begin
           cnt=cnt+4;
           addr=cnt;
        end
    end
endmodule
