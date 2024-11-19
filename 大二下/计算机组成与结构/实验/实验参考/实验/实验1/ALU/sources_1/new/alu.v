`timescale 1ns / 1ps

/* ALU模块实现两个32bit数的add、sub、and、or、not、slt功能，
但由于Nexy7输入口限制，将num1简化为8位，在过程中再extend成32位，num2作为内部wire自行赋值，此处赋为5
由于最后的结果在top.v中以七段数码管显示，32位结果不用以led在nexy4显示，因此输出32位结果没有问题*/

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
            3'b000:result=a+num2;// 无符号加法
            3'b001:result=a-num2;// 无符号减法
            3'b010:result=a&num2;// 与操作
            3'b011:result=a|num2;// 或操作
            3'b100:result=~a; // 非操作
            3'b101:result = (a < num2) ? 32'h0000_0001 : 32'h0000_0000; // 小于则置位
                
            default:result=32'hxxxx_xxxx;
        endcase
    end
    
endmodule
