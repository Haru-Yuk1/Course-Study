`timescale 1ns / 1ps

/* ALUģ��ʵ������32bit����add��sub��and��or��not��slt���ܣ�
������Nexy7��������ƣ���num1��Ϊ8λ���ڹ�������extend��32λ��num2��Ϊ�ڲ�wire���и�ֵ���˴���Ϊ5
�������Ľ����top.v�����߶��������ʾ��32λ���������led��nexy4��ʾ��������32λ���û������*/

module alu(
    input wire [2:0] op,
    input wire [7:0] num1,
    output reg [31:0] result
    );
    wire [31:0] num2;
    wire [31:0] a;
    assign num2=32'h0000_0001;
    assign a={24'h0,num1};
    
    always@(*)begin
        case(op)
            3'b000:result=a+num2;// �޷��żӷ�
            3'b001:result=a-num2;// �޷��ż���
            3'b010:result=a&num2;// �����
            3'b011:result=a|num2;// �����
            3'b100:result=~a; // �ǲ���
            3'b101:result = (a < num2) ? 32'h0000_0001 : 32'h0000_0000; // С������λ
                
            default:result=32'hxxxx_xxxx;
        endcase
    end
    
endmodule
