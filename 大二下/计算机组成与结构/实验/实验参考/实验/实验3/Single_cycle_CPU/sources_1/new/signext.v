`timescale 1ns / 1ps
/*������չģ�飺������16λ����������չΪ32λ*/

module signext(
    input [15:0] a,
    output [31:0] y
    );
    assign y={{16{a[15]}},a};   //�з�������չ
endmodule
