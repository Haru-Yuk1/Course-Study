.data
    show_begin:  .asciiz  "\nWelcome to our caculator,which operation do you want to perform?              \n 1.add caculate  \n 2.sub caculate  \n 3.multiply  \n 4.divide  \n 5.exit  \n Choose a operation:"
    show_exit:   .asciiz  "Thank you for choosing our calculator!BYE!"
    show_cin1:   .asciiz  "Please enter the first number:"
    show_cin2:   .asciiz  "Please enter the second number:"
    show_wrong:  .asciiz  "Operation error,please re_enter\n"
    show_underflow:  .asciiz  "underflow error,please re_enter\n"
    show_overflow:  .asciiz  "overflow error,please re_enter\n"
    show_div:    .asciiz  "divider cannot be zero!\n"
    show_binary:   .asciiz  "\nBinary:\n"
    show_hex:  .asciiz  "\nHexdecimal:\n"
.text

#t4,t5,t6:进制的符号，阶数，尾数
main:
    #开始，提示用户选择操作
    la  $a0,  show_begin
    li  $v0,  4
    syscall
    li  $v0,  5
    syscall
    move $t0,  $v0
    #选择5则退出
    beq  $t0, 5, exit
    #选择1，2，3，4则进入计算函数
    jal  calutation
    j main

calutation:
    addi  $sp,  $sp,  -32 
    sw  $ra,  20($sp)
    sw  $fp,  16($sp)
    addiu  $fp, $sp, 28
    sw  $a0, 0($fp)

    #输入第一个浮点数
    la  $a0,  show_cin1
    li  $v0,  4
    syscall
    li  $v0,  6
    syscall

    mfc1  $a1,  $f0
    #取$a1的符号位$s0
    srl  $s0,  $a1,  31
    #取$a1的阶码$s1
    sll  $s1,  $a1,  1
    srl  $s1,  $s1,  24
    #取$a1的尾数$s2
    sll  $s2,  $a1,  9
    srl  $s2,  $s2,  9
    #补全隐藏1
    addi  $s2,  $s2,  0x00800000

    #输入第二个浮点数
    la  $a0,  show_cin2
    li  $v0,  4
    syscall
    li  $v0,  6
    syscall
    mfc1  $a2,  $f0

    #取$a2的符号位$s3
    srl  $s3,  $a2,  31
    #取$a2的阶码$s4
    sll  $s4,  $a2,  1
    srl  $s4,  $s4, 24
    #取$a1的尾数$s5
    sll  $s5,  $a2,  9
    srl  $s5,  $s5,  9
    #补全隐藏1
    addi  $s5,  $s5, 0x00800000

    #加法运算
    beq  $t0, 1, add_caculate
    #减法运算
    beq  $t0, 2, sub_caculate
    #乘法运算
    beq  $t0,3, mutiply_caculate
    #除法运算
    beq  $t0,4, divide_caculate

add_caculate:
#对阶
    sub  $t1,  $s1,  $s4
    #小数对大数阶
    bltz  $t1,  exp1
    bgtz  $t1,  exp2
    beqz  $t1,  add_sub

exp1:
    addi  $s1,  $s1, 1
    srl   $s2,  $s2, 1
    j add_caculate

exp2:
    addi  $s4,  $s4, 1
    srl  $s5,  $s5, 1
    j add_caculate

#判断同号或异号相加
add_sub:
    sub  $t1, $s0, $s3
    #同号加
    beqz  $t1,  add_sum
    #异号减
    j sub_sum

sub_sum:
    #比较尾数绝对值大小
    sub  $t2,  $s2,  $s5
    bgtz  $t2,  a_b
    bltz  $t2,  b_a
    #相等输出0
    j cout0

a_b:
    #尾数过小或过大
    blt  $t2,  0x00800000, a_bmove
    bge  $t2,  0x01000000,a_bmove2 
    j addsub_result

a_bmove:
    sll  $t2,  $t2, 1
    subi  $s1,  $s1,  1
    blt  $t2,  0x00800000, a_bmove
    j addsub_result

a_bmove2:
    srl  $t2,  $t2, 1
    add  $s1,  $s1, 1
    bge  $t2,  0x01000000, a_bmove2 
    j addsub_result

b_a:
    sub  $t2,  $s5,  $s2
    xori  $s0,  $s0,  0x00000001
    j a_b

add_sum:
    #尾数相加
    add  $t2,  $s2,  $s5
    sge  $t3,  $t2,  0x01000000 
    bgtz  $t3,  yichu
    j addsub_result

#溢出处理
yichu:
    srl   $t2,  $t2,  1
    add  $s1,  $s1,  1
    sge  $t3,  $t2,  0x01000000 
    bgtz  $t3,  yichu
    j addsub_result

addsub_result:
    blt  $s1,  0,  under_flow
    bgt  $s1,  255,  over_flow
    sll  $s0,  $s0,  31
    sll  $s1,  $s1,  23
    sll  $t2,  $t2,  9
    srl  $t2,  $t2,  9
    add  $s1,  $s1,  $t2
    add  $s0,  $s0,  $s1
    mtc1 $s0,  $f12
    li  $v0, 2
    syscall
    move  $t4,  $s0
    j result

sub_caculate:
    xori  $s3,  $s3,  0x00000001
    j add_caculate

mutiply_caculate:
    #指数是否为零
    beqz  $s1,  zeroexp
    beqz  $s4,  zeroexptwo
    j  multnozero

zeroexp:
    beq  $s2,  0x800000,  multZero
    beqz  $s4,  zeroexptwo
    j  multnozero

zeroexptwo:
    beq  $s5,  0x800000,  multZero
    j  multnozero

#有0就输出0
multZero:
    li  $t4,  0
    li  $t5,  0
    li  $t6,  0
    j  cout0

#无零乘法运算
multnozero:
    #指数相加
    add  $t5,  $s1,  $s4
    li  $t7,  127
    sub  $t5, $t5, $t7
    #尾数相乘
    mult  $s2,  $s5
    mfhi  $t6    #高32位
    mflo  $t7    #低32位
    sll  $t6,  $t6,  9
    srl  $t7,  $t7,  23
    or  $t6,  $t6,  $t7
    #规格化
    srl  $t7,  $t6, 24
    beqz  $t7,  normalized
    srl  $t6,  $t6,  1
    addi  $t5,  $t5, 1

normalized:
    xor  $t4,  $s0,  $s3
    #溢出
    sgt  $t7,  $t5, $zero
    beqz  $t7, under_flow
    slti  $t7,  $t5, 255
    beqz $t7,  over_flow
    j mult_result

mult_result:
    sll  $t4,  $t4,  31
    sll  $t5,  $t5,  23
    sll  $t6,  $t6,  9
    srl  $t6,  $t6,  9
    add  $t5,  $t5,  $t6
    add  $t4,  $t4,  $t5
    mtc1  $t4,  $f12
    li  $v0, 2
    syscall
    j result

#除法
#t0:选择操作；$t1:对阶操作 ；$t2:尾数加减 ；$t3:判断是否溢出
#t4,t5,t6是结果的符号，阶数，尾数
divide_caculate:
    #被除数是否为0
    beqz  $s1,  divzeroexp
    j  divnozero

divzeroexp:
    beq  $s2,  0x800000,  divZero
    j divnozero

divZero:
    li  $t4,  0
    li  $t5,  0
    li  $t6,  0
    j cout0

divnozero:
    #除数是否为0
    bnez  $s4, divoperate
    bne  $s5, 0x800000, divoperate
    la  $a0, show_div
    li  $v0, 4
    syscall
    j main

divoperate:
    #指数相减
    sub  $t5,  $s1,  $s4
    addi  $t5,  $t5, 127
    #符号
    xor  $t4, $s0, $s3
    #尾数相除
    div  $s2, $s5
    mflo  $t6 #商
    mfhi  $t7 #余数
    beqz  $t6, div_result
    li $t8, 1

#商右移
divloop1:
    srlv  $t9,  $t6,  $t8
    bne  $t9,  $zero, divloop1
    li  $t9, 1
    sub  $t8,  $t8,  $t9
    #指数加
    add  $t5,  $t5,  $t8

    #溢出
    slti  $t2,  $t5, 0
    beq  $t2, 1, under_flow
    li  $t2,  255
    slt  $t2,  $t2,  $t5
    beq  $t2,  1,  over_flow

    li  $t3,  23
    sub  $t3,  $t3,  $t8
    #计数器
    li  $t1, 0

divloop2:
    sll  $t7,  $t7, 1
    div  $t7,  $s5
    mflo  $k0
    mfhi  $t7
    #尾数
    sll  $t6,  $t6, 1
    add  $t6,  $t6,  $k0
    addi  $t1,  $t1, 1
    beq  $t1,  $t3,  div_result
    beqz  $t7,  div_comp_dec
    j divloop2

div_comp_dec:
    sub  $t1,  $t3,  $t1
    sllv  $t6,  $t6,  $t1

div_result:
    sll  $t4,  $t4,  31
    sll  $t5,  $t5,  23
    sll  $t6,  $t6,  9
    srl  $t6,  $t6,  9
    add  $t5,  $t5, $t6
    add  $t4, $t4, $t5
    mtc1  $t4,  $f12
    li  $v0, 2
    syscall
    j result

#下溢
under_flow:
    la  $a0,  show_underflow
    li  $v0,  4
    syscall
    j main

#上溢：
over_flow:
    la  $a0,  show_overflow
    li  $v0,  4
    syscall
    j main

#输出0
cout0:
    li  $a0, 0
    li  $v0,1
    syscall
    j main

#打印输出结果
result:
    #"Binary:"
    la  $a0,  show_binary
    li  $v0,  4
    syscall

    binary:
    #$t7用于计数
    addu  $k0,  $t4,  $zero
    addi  $t7,  $0,  32
    addi  $t8,  $0,  0x80000000
    addi  $t9,  $0,  0
    binary_output:
    subi  $t7,  $t7,  1
    and  $t9,  $k0,  $t8
    srl  $t8,  $t8,  1
    srlv  $t9,  $t9,  $t7
    add  $a0,  $t9,  $0
    #循环输出，一次一位
    li  $v0,  1
    syscall
    beq  $t7,  $0,  hexbegin
    j binary_output

#十六进制输出    
hexbegin:   
    #"Hex:"
    la  $a0,  show_hex
    li  $v0,  4
    syscall
    
    hex:
    li  $t7, 0
    addi  $t7,	 $zero, 8
    add	$t9,	$t4, $zero
    add  $t8,	$t4, $zero 
    
    hex_output:
    beqz  $t7, return
    addi  $t7,  $t7,  -1
    srl  $t8,  $t9,  28
    sll  $t9,  $t9,  4
    bgt  $t8,  9,  hex_char
    li $v0,  1
    addi  $a0,  $t8,  0
    syscall
    j hex_output
    
    hex_char:
    addi  $t8,  $t8,  55
    li  $v0, 11
    addi  $a0, $t8,  0
    syscall
    j hex_output
    
 return:
   lw  $t1,  28($sp)
   lw  $t6,  24($sp)		
   lw  $ra,  20($sp)
   lw  $fp, 16($sp)
   addiu  $sp,	$sp,32
   jr $ra
#退出
exit:
    la  $a0,  show_exit
    li  $v0,  4
    syscall 