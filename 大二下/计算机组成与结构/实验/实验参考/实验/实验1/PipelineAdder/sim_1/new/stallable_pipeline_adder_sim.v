`timescale 1ns / 1ps
/*����Ҫ��
1.ģ����ˮ����ͣ������ʱ���� 10 ���ں���ͣ��ˮ�� 2 ���ڣ��� 2 ��������ˮ�߻ָ�������
2.ģ����ˮ��ˢ�£�����ʱ���� 15 ����ʱ��ˮ��ˢ�£��� 3 ������
ע�⣺������Ӧ���÷�������ֵ��
*/

module stallable_pipeline_adder_sim( );
    reg [31:0] cin_a;
    reg [31:0] cin_b;
    reg clk;
    reg [3:0]rst;
    reg cin;
    reg [3:0]stop;
    wire cout;
    wire [31:0] sum;
    
    
    initial begin
        clk = 1;
        rst = 4'b0000;
        stop = 4'b0000;
        cin_a = 32'h0000_0000;cin_b=32'h0000_0000;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_0000;cin_b=32'h0000_0000;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_0000;cin_b=32'h0000_0000;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_0001;cin_b=32'h0000_0001;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_0010;cin_b=32'h0000_0001;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_0100;cin_b=32'h0000_0001;cin=1'b0;
        @(posedge clk) cin_a = 32'h0000_1000;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h0001_0000;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h0010_0000;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) stop=4'b0001;cin_a = 32'h0100_0000;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0001;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) stop=4'b0010;cin_a = 32'h1000_1111;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0001;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0001;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0001;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) rst=4'b0100;cin_a = 32'h1000_0001;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0011;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_1011;cin_b=32'h0000_0001;cin=1'b1;
        @(posedge clk) cin_a = 32'h1000_0111;cin_b=32'h0000_0001;cin=1'b1;
        repeat(10) @(posedge clk);
        $finish;       
    end
    
    always #5  clk = ~clk;

    stallable_pipeline_adder a(cin_a,cin_b,rst,clk,stop,cin,cout,sum);

endmodule

