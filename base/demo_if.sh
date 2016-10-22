#!/bin/bash

# sh demo_if.sh a b c
# 打印终端命令行的所有参数
echo "$*";
echo "参数1："$1;
echo "参数2："$2;
echo "参数3："$3;

# 打印终端命令行的所有参数
echo "$@";
echo "参数1：$1";
echo "参数2：$2";
echo "参数3：$3";

# 打印终端命令行的所有参数的个数
echo $#;

# 如果终端命令行的所有参数的个数小于3，就输出所有参数
if [ $# -lt 3 ]; then
	echo $*;
else
	echo $0;
	echo "参数过多不在控制台显示";
fi

filePath=/Users/yunyu/Downloads/test
if [ -e $filePath ]; then
	echo "文件/目录存在"
else 
	echo "文件/目录不存在"
fi

if [ -d $filePath ]; then
	echo "目录存在"
else 
	echo "目录不存在"
fi

if [ -f $filePath ]; then
	echo "文件存在"
else 
	echo "文件不存在"
fi

if [ -s $filePath ]; then
	echo "文件内容不为空"
else 
	echo "文件内容为空"
fi

#var="test";
var="";
# -z 判断一个变量的值是否为空
if [ -z "$var" ]; then
	echo "var is empty"
else
	echo "var is $var"
fi

# -n 判断一个变量是否为非空
if [ -n "$var" ]; then
	echo "var is not empty, value is $var"
else
	echo "var is empty"
fi

# ! -n 和 -z 用法一样
if [ ! -n "$var" ]; then
	echo "var is empty"
else
	echo "var is $var"
fi

if [ "$var" ]; then
	echo "if var is $var"
else
	echo "if var is blank"
fi

var1="1";
var2="2";
# 判断两个变量是否相等
if [ "$var1" = "$var2" ]; then
	echo "$var1 equals $var2"
else
	echo "$var1 not equals $var2"
fi

# 判断两个变量是否不相等
if [ "$var1" != "$var2" ]; then
	echo "$var1 not equals $var2"
else
	echo "$var1 equals $var2"
fi

num1=1;
num2=2;
# 算术比较运算符
if [ "$num1" -eq "$num2" ]; then
	echo "$num1 equals $num2"
elif [ "$num1" -lt "$num2" ]; then
	echo "$num1 less than $num2"
elif [ "$num1" -le "$num2" ]; then
	echo "$num1 less than equals $num2"
elif [ "$num1" -gt "$num2" ]; then
	echo "$num1 great than $num2"
elif [ "$num1" -ge "$num2" ]; then
	echo "$num1 great than equals $num2"
elif [ "$num1" -ne "$num2" ]; then
	echo "$num1 not equals $num2"
fi

# 判断变量是否模糊匹配
base_version='2.2.0'
if [[ $base_version =~ 1.* ]]; then
	base_version='1.x'
fi
if [[ $base_version =~ 2.* ]]; then
	base_version='2.x'
fi
echo $base_version