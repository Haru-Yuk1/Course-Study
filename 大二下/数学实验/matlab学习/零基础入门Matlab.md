 ## 零基础入门matlab

### 1.界面认识

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/890abb5d1de514e7e98d3e8c102b031b.png#pic_center)

### 2.变量命名

注：Matlab中的注释

%% 独占一行的注释（有上下横线分割）

% 普通注释

1）清空环境变量及命令

clear all 清除Workspace中的所有变量（右侧工作区）

clc 清除Command Window中的所有命令（命令行窗口）

2）变量命名规则

①变量名区分大小写

②变量名长度不超过63位（hhh，不会有人把变量名弄这么长吧~）

③变量名简洁明了，尽量做到见名知意

### 3.数据类型

1）数字

2 + 4

10-7

3\*5

8/2

2）字符与字符串

s = ‘a’ （单引号表示字符串）

\==abs(s)==ASCII码

char(97) 输出 a （ASCII码转字符串）

num2str(65) 输出数字65

str\=‘I love MATLAB & Machine Learning’

length(str) 字符串长度

doc num2str

3）矩阵（Matlab最NB的东西）

`A = [1 2 3; 4 5 2; 3 2 7]`  
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/4ddfa58464627785d2656ab7e64f24b7.png#pic_center)  
`B = A'`把A进行[转置](https://so.csdn.net/so/search?q=%E8%BD%AC%E7%BD%AE&spm=1001.2101.3001.7020)，行变列，列变行

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/4f39144db4a15d46f6bdc7c603a03634.png#pic_center)  
`C = A(:)` 竖向拉长（不好描述，直接看下图）

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/cb2ebb3e15c4e445ffc39564f4ae1324.png#pic_center)

`D = inv(A)` [逆矩阵](https://so.csdn.net/so/search?q=%E9%80%86%E7%9F%A9%E9%98%B5&spm=1001.2101.3001.7020)（必须时方阵才能求逆矩阵）

执行下面两条语句

D = [inv](https://so.csdn.net/so/search?q=inv&spm=1001.2101.3001.7020)(A) （求逆矩阵）  
A \* D （相当于A×A的逆）

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/9b6babceff8f9d8b4eaf820f10d33a93.png#pic_center)  
`E = zeros(10,5,3)` 创建一个10行5列3维的全0矩阵

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/2628b2ba1aef18388545a7bc6d6fff18.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/9d69c79eaef1f61e97ad612cf46842c0.png#pic_center)

`E(:,:,1) = rand(10,5)`

rand生成均匀分布的伪随机数。分布在（0~1）之间

主要语法：rand(m,n)生成m行n列的均匀分布的伪随机数

rand(m,n,‘double’)生成指定精度的均匀分布的伪随机数，参数还可以是’single’

rand(RandStream,m,n)利用指定的RandStream（随机种子）生成伪随机数

`E(:,:,2) = randi(5,10,5)`

randi生成均匀分布的伪随机数

主要语法：randi(iMax)在开区间(0,iMax)生成均匀分布的伪随机数

randi(iMax,m,n)在开区间(0,iMax)生成mXn型随机矩阵

r = randi(\[iMin,iMax\],m,n)在开区间(iMin，iMax)生成mXn型随机矩阵

`E(:,:,3) = randn(10,5)`

randn生成标准正态分布的伪随机数（均值为0，方差为1）

主要语法：和上面一样

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/493e095db1fa39f865b960a2fb9c0873.png#pic_center)  
![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/843d895d78bca83c436cba1eed2699be.png#pic_center)

### 4.元胞数组和结构体

**元胞数组**：是MATLAB中特有的一种数据类型，是数组的一种，其内部元素可以是属于不同的布局类型，概念理解上，可以认为它和C语言里面的结构体、C++里面的对象很类似。元胞数组是MATLAB中的特色数据类型，它不同于其它数据类型（如字符型，字符数组或者字符串，以及一般的算数数据和数组）。它特有的存取数据方法决定了它的特点，它有给人一种查询信息的感觉，可以逐渐追踪一直到所有的变量全部翻译成基本数据信息。它的class函数输出就是cell（细胞）

```matlab
%元胞数组
A = cell(1,6)
A{2} = eye(3) %2021版本前的matlab下标从1开始
A{5} = magic(5)
B = A{5}
```

注：magic：字面意思是魔方，魔术的意思。在MATLAB中用来生成n阶幻方。比如三阶幻方就是1-9九个数字，组成一个3\*3的矩阵，使得该矩阵无论横、竖还是斜三个方向上的三个数的和总是相同的。幻方是一个很古老的问题，试一下就知道了！

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/0d4b4c7f8c4fb9108564376fbebdb229.png#pic_center)

**结构体**

```matlab
%结构体
books = struct('name',{{'Machine Learning','Data Mining'}},'price',[30,40])
books.name %属性
books.name(1)
books.name{1}
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/ee65e72ac9f5f3f6f22a663ac7b87871.png#pic_center)

### 5.矩阵操作

1）矩阵的定义与构造

```matlab
A = [1,2,3,4,5,6,5,4,6]
B = 1:2:9 %第二个参数为步长，不可缺省
B = 1:3:9
C = repmat(B,3,2) %重复执行3行2列
D = ones(2,4) %生成一个2行4列的全1矩阵
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/825ce5e1376df12ba7378ce549ce3b54.png#pic_center)

2）矩阵的四则运算

```matlab
A = [1 2 3 4; 5 6 7 8]
B = [1 1 2 2; 2 2 1 1]
C = A + B
D = A - B
E = A * B'
F = A .* B % .*表示对应项相乘
G = A / B %相当于A*B的逆 G*B = A  G*B*pinv(B) = A*pinv(B)  G = A*pinv(B),相当于A乘B
H = A ./ B % ./表示对应项相除
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/ef32fa505490412934a2ecb0f9813ed0.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/1c183cfcef4871831b97c4087e441b42.png#pic_center)

3）矩阵的下标

```matlab
A = magic(5)
B = A(2,3)
C = A(3,:) % :为取全部,那么这条语句表示取第三行
D = A(:,4) %取第四列
[m,n] = find(A > 20) %找到大于20的序号值/矩阵
%取的是索引值
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/de2948f045070c0b4b7a167e50092117.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/734fa7e27b35eafb3e2389f51ec3f3b8.png#pic_center)

### 6.程序结构

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/9bddbf66f46aa2fc9d3ddecca45bf723.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/4c02dc8ec5602daa1bb30dfae2f6bc21.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/1042a9995e80eb503462ecb3d4a2e62b.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/028064334b49ccc40646208b039797c1.png#pic_center)

### 7.基本绘图操作

#### 7.1.二维平面绘图

```matlab
%1.二维平面绘图
x = 0:0.01:2*pi %定义x的范围，第二个参数表示步长
y = sin(x)
figure %建立一个幕布
plot(x,y) %绘制当前二维平面图
title('y = sin(x)') %标题
xlabel('x') %x轴
ylabel('sin(x)') %y轴
xlim([0 2*pi]) % x坐标值的范围
```

![在这里插入图片描述](%E9%9B%B6%E5%9F%BA%E7%A1%80%E5%85%A5%E9%97%A8Matlab.assets/3dbd87fcb48fc49270fcdc7620c4adea.png)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/d0ddf7393cd7e0c2f8cbc04708aa1383.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/93f1472bea2243231b56ea2a759c9105.png#pic_center)

```matlab
x = 0:0.01:20;
y1 = 200*exp(-0.05*x).*sin(x);
y2 = 0.8*exp(-0.5*x).*sin(10*x);
figure
[AX,H1,H2] = plotyy(x,y1,x,y2,'plot'); %共用一个x的坐标系，在y上有不同的取值
%设置相应的标签
set(get(AX(1),'Ylabel'),'String','Slow Decay')
set(get(AX(2),'Ylabel'),'String','Fast Decay')
xlabel('Time(\musec)')
title('Multiple Decay Rates')
set(H1,'LineStyle','--')
set(H2,'LineStyle',':')
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/ef59f8838154024a7acdfbca9cba68bf.png#pic_center)

#### 7.2.三维立体绘图

```matlab
%2.三维立体绘图
t = 0: pi/50: 10*pi;
plot3(sin(t),cos(t),t)
xlabel('sin(t)')
ylabel('cos(t)')
zlabel('t')
%hold on
%hold off %不保留当前操作
grid on %把图片绘制出来，在图片中加一些网格线
axis square %使整个图（连同坐标系）呈方体
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/1d316e37b4b9cbf3d2e06f1a624459bf.png#pic_center)  
注：**关于hold on 和 hold off的用法：**[点这](https://blog.csdn.net/fsfsfsdfsdfdr/article/details/83818482?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522162693253916780264026512%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=162693253916780264026512&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-2-83818482.pc_search_all_es&utm_term=matlab%20hold%20on&spm=1018.2226.3001.4187)

### 8.图形的保存与导出

如果直接用截图的方式截取matlab生成的图像，会影响图像的清晰度。因此我们建议：可以用如下方法保存与导出图形。

1）如图![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/06134a0eb2c5dec8cdadc17fd6c66cc4.png#pic_center)

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/01b8d5b9f1706ebf2009207f9dc70939.png#pic_center)

2）编辑→复制选项

可调节相应元素

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/83cb203970cec4a5f19575336783ebe5.png#pic_center)

3）编辑→图窗属性

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/c70b0ce7f1106187aef1009cf0044644.png#pic_center)

4）文件→导出设置

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/bd64c232faf4711fb0cb8191be3065f8.png#pic_center)

通过调节宽度、高度等像素值属性，可以让图片即使很小，文字依然清晰。

_Matlab基础的部分到这就结束了，下面作一点补充~_

### 9.补充

```matlab
[x,y,z] = peaks(30); %peaks命令用于产生双峰函数或者是用双峰函数绘图
mesh(x,y,z)
grid
```

![在这里插入图片描述](https://img-blog.csdnimg.cn/img_convert/bb9f2cdb2e9cad3c2181bf336709952c.png#pic_center)  
完结~  
感谢大家的支持、点赞、收藏、关注以及批评指正~

本文转自 <https://blog.csdn.net/weixin_46125998/article/details/118991929?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522170899492816800197094335%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=170899492816800197094335&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_positive~default-1-118991929-null-null.142^v99^pc_search_result_base5&utm_term=matlab&spm=1018.2226.3001.4187>，如有侵权，请联系删除。