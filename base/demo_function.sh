#!/bin/bash

###### 函数定义 ######
echo "函数定义";

# 注意：所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。
function hello() {
    echo "Hello!";
}

function hello_param() {
    echo "Hello $1 !";
}
###### 函数调用 ######
# 函数调用
echo "函数调用";
hello;

###### 参数传递 ######
echo "函数传参调用";
hello_param ben;

###### 函数文件 ######
echo "函数文件调用";
# 调用函数文件，点和demo_call之间有个空格
. demo_call.sh;
# 调用函数
callFunction ben;

###### 载入和删除 ######
echo "载入和删除";

# 用unset functionname 取消载入
# unset callFunction;
# 因为已经取消载入，所以会出错
# callFunction ben;

###### 参数读取 ######
echo "参数读取";

# 参数读取的方式和终端读取参数的方式一样
funWithParam(){
    echo "The value of the first parameter is $1 !"
    echo "The value of the second parameter is $2 !"
    echo "The value of the tenth parameter is $10 !"
    echo "The value of the tenth parameter is ${10} !"
    echo "The value of the eleventh parameter is ${11} !"
    echo "The amount of the parameters is $# !"
    echo "The string of the parameters is $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73

###### 函数return ######
echo "函数return";

funWithReturn(){
    echo "The function is to get the sum of two numbers..."
    echo -n "Input first number: "
    read aNum
    echo -n "Input another number: "
    read anotherNum
    echo "The two numbers are $aNum and $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
# 函数返回值在调用该函数后通过 $? 来获得
echo "The sum of two numbers is $? !"