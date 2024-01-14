# C++常用库总结

## 一、algorithm

使用algorithm头文件，需要使用名字空间，需要在头文件下面加一行“using namespace std”，才能使用。

### algorithm的常用函数

#### 1.max(),min(),abs()

max(x,y)和min(x,y)分别返回x和y的最大值和最小值，且参数必须是两个（可以是==浮点数==），如果要返回三个数x,y,z的最大值，可以使用max(max(x,y),z)的写法。abs(x)返回x的绝对值。**注意，x必须是整数，浮点型的绝对值要用math头文件下的fabs。**

#### 2.swap()

swap(x,y)用来交换x和y的值

#### 3.reverse()

reverse(it1，it2)可以将数组指针或者容器的迭代器在[it1,it2)范围内的元素进行反转。

#### 4.next_permutation()

next_permutation()给出一个序列全排列中的下一个序列。使用的方式和reverse类似。

> 例如，当n==3时的全排列为
> 123,132,213,231,312,321，这样231的下一个序列就是312。
>
> int a[ ] = {1,2,3} ;
>     do{
>         cout << a[0] << a[1] << a[2] << endl ;
> }while(next_permutation(a,a+3)) ;
> 输出结果：123
> 132
> 213
> 231
> 312
> 321
>
> 注意，这里要用do..while否则输出的结果中会少123这种情况。

#### 5.fill()

fill()函数可以把数组或者容器中的某一段区域赋为某个相同的值。和memset不同的是，这里的赋值可以是和数组类型对应范围中的任意值。

> int a[ ] = {3,1,2,5,4} ;
>   fill(a,a+2,888) ;
>   for(auto e : a) cout << e << ' ' ;
> cout << endl ;
> 输出结果：888 888 2 5 4

#### 6.sort()

sort()是用来排序的。sort()的使用方式是，==sort(首元素地址(必填)，尾元素地址的下一个地址(必填)，比较函数(非必填))==。如果不写比较函数，则默认对给出的区间进行递增排序。如果写比较函数，会根据比较函数的返回情况，对数据优秀排序

> int a[ ] = {3,1,2,5,4} ;
>     sort(a,a+2) ;
>     for(auto e : a) cout << e << ' ' ;
>     puts(" ") ;
>     sort(a,a+5) ;
>     for(auto e : a) cout << e << ' ' ;
> cout << endl ;
> 输出结果：1 3 2 5 4
> 1 2 3 4 5
>
> ==结构体的排序，具体看cmp的编写方式==
>
> <font color='red'>这里实现长度优先排序，其次是按字典序排序</font>
>
> bool cmp(string str1,string str2){
>     if(str1.size() != str2.size()) return str1.size() < str2.size() ;
>     else return str1 < str2 ;
> }
>
> int main(){
>     string a[] = {"cccc","zz","bbb","aa"} ;
>     sort(a,a+4,cmp) ;
>     for(int i=0;i<4;i++){
>         cout << a[i] << endl ;
>     }
>     return 0 ;
> }
> 输出结果：aa
> zz
> bbb
> cccc

#### 7. lower_bound()和upper_bound()

lower_bound()和upper_bound()需要用在一个有序数组或者容器中。
Lower_bound(st,ed,val)用来寻找在数组或者容器中的[st,ed)范围内第一个值==大于等于val==的元素的位置，如果是数组，则返回该位置的指针，如果是容器则返回该位置的迭代器。
Upper_bound(st,ed,val)用来寻找在数组或者容器中的[st,ed)范围内的第一个==大于val==的元素的位置，如果是数组，则返回该位置的指针，如果是容器，则返回该位置的迭代器。

> int a[10] = {1,2,2,3,3,3,5,5,5,5} ;
>
> //search -1
> int* lp = lower_bound(a,a+10,-1) ;
> int* up = upper_bound(a,a+10,-1) ;
> cout << lp - a << ' ' << up - a << endl ;
> //search 1
> lp = lower_bound(a,a+10,1) ;
> up = upper_bound(a,a+10,1) ;
> cout << lp - a << ' ' << up - a << endl ;
> //search 3
> lp = lower_bound(a,a+10,3) ;
> up = upper_bound(a,a+10,3) ;
> cout << lp - a << ' ' << up - a << endl ;
> //search 4
> lp = lower_bound(a,a+10,4) ;
> up = upper_bound(a,a+10,4) ;
> cout << lp - a << ' ' << up - a << endl ;
> //search 6
> lp = lower_bound(a,a+10,6) ;
> up = upper_bound(a,a+10,6) ;
>
> cout << lp - a << ' ' << up - a << endl ;
> 输出结果：0 0
> 0 1
> 3 6
> 6 6
> 10 10