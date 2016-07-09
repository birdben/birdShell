#!/bin/bash

# 打印终端命令行的所有参数
echo $*;

# 打印终端命令行的所有参数的个数
echo $#;

# 如果终端命令行的所有参数的个数小于3，就输出所有参数
if [ $# -lt 3 ]; then
	echo $*;
else
	echo $0;
	echo "参数过多不在控制台显示";
fi