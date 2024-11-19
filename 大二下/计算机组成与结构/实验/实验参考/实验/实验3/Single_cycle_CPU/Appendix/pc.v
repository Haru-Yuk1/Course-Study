`timescale 1ns / 1ps
/*pcģ�飺��ʵ�����PCģ������޸ģ�����PC'��Ϊ���룬������clk���PC��PC+4�Ĺ��ܷ���adder��ʵ��
    �����޷�ʵ��branch��jump����
ע�⣺addr������ֵ�����������⣬��һ��ָ��ᱻ�̵�
*/
module pc(
    input clk,rst,
    input[31:0] pc,
    output reg[31:0] pc_new=0
);
    always@(posedge clk)begin
        if(rst)begin
            pc_new=0;
        end
        else begin
           pc_new=pc;
        end
    end
endmodule
