`timescale 1ns / 1ps
/*ʱ�ӷ�Ƶģ�飺��100MHz��Ƶ�ʽ�Ϊ1hz
10^8(10)=0101_1111_0101_1110_0001_0000_0000(2)��ԼΪ2^27������Ҫ27λ�洢
ע�⣺clk_division��0-1-0����һ�����ڣ���˵�26λ�仯����
    ��ģ�鲻Ӧ����rst
*/
module clk_div(
    input clk,
    output clk_division
);
    reg[27:0] cnt=0;
    assign clk_division=cnt[26];   //26th��0~1~0����2^26
    always@(posedge clk)begin
        cnt=cnt+1;
    end
    
endmodule
