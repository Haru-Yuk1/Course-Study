`timescale 1ns / 1ps
/*��ѡһѡ����
    ʹ��always��ֵ������·�϶�ʱ�����ӳ٣�����assign��ֵ�����ӳ�
*/

module mux2#(parameter WIDTH=32)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input sel,
    output [WIDTH-1:0] c 
    );
//    always@(*)begin
//        if(!sel)    c=a;
//        else        c=b;
//    end
    assign c = sel ? b:a;
    
endmodule
