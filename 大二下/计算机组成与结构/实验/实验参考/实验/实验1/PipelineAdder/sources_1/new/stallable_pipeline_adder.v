`timescale 1ns / 1ps
module stallable_pipeline_adder(
    input [31:0] cin_a, //输入两个操作数
    input [31:0] cin_b, 
    input [3:0]rst, //归零
    input clk, //时钟
    input [3:0]stop, //停止
    input c_in, //进位标志
    output wire c_out, //溢出标志
    output wire [31:0] sum //和
    );
    
    reg cout1,cout2,cout3,cout4; //存储溢出位
    //存储对应每级累加后的结果
    reg [7:0] sum1;
    reg [15:0] sum2;
    reg [23:0] sum3;
    reg [31:0] sum4;
    //存储每次加8位后剩余的数据
    reg [23:0] surA1,surB1;
    reg [15:0] surA2,surB2;
    reg [7:0] surA3,surB3;
    
    //第一级
    always@(posedge clk)
    begin
        if(rst[0])
        begin
            cout1<=0;
            sum1<=0;
            surA1<=0;
            surB1<=0;
        end
        else if(stop[0])
        begin
            cout1<=cout1;
            sum1<=sum1;
            surA1<=surA1;
            surB1<=surB1;
        end
        else
        begin
            {cout1,sum1} <= {1'b0,cin_a[7:0]} + {1'b0,cin_b[7:0]} + {7'b0000_000,c_in};
            surA1<=cin_a[31:8];
            surB1<=cin_b[31:8];
        end
    end
    
    //第二级
    always@(posedge clk)
    begin
        if(rst[1])
        begin
            cout2<=0;
            sum2<=0;
            surA2<=0;
            surB2<=0;
        end
        else if(stop[1])
        begin
            cout2<=cout2;
            sum2<=sum2;
            surA2<=surA2;
            surB2<=surB2;
        end
        else
        begin
            {cout2,sum2[15:7]} <= {1'b0,surA1[7:0]} + {1'b0,surB1[7:0]} + {7'b0000_000,cout1};
            sum2[7:0]<=sum1;
            surA2<=surA1[23:8];
            surB2<=surB1[23:8];
        end
    end
    
    //第三级
    always@(posedge clk)
    begin
        if(rst[2])
        begin
            cout3<=0;
            sum3<=0;
            surA3<=0;
            surB3<=0;
        end
        else if(stop[2])
        begin
            cout3<=cout3;
            sum3<=sum3;
            surA3<=surA3;
            surB3<=surB3;
        end
        else
        begin
            {cout3,sum3[23:16]} <= {1'b0,surA2[7:0]} + {1'b0,surB2[7:0]} + {7'b0000_000,cout2};
            sum3[15:0]<=sum2;
            surA3<=surA2[15:8];
            surB3<=surB2[15:8];
        end
    end
    
    //第四级
    always@(posedge clk)
    begin
        if(rst[3])
        begin
            cout4<=0;
            sum4<=0;
        end
        else if(stop[3])
        begin
            cout4<=cout4;
            sum4<=sum4;
        end
        else
        begin
            {cout4,sum4[31:24]} <= {1'b0,surA3[7:0]} + {1'b0,surB3[7:0]} + {7'b0000_000,cout3};
            sum4[23:0]<=sum3;
        end
    end     
    
    assign sum=sum4;
    assign c_out=cout4;
    
endmodule

