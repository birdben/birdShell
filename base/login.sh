#!/usr/bin/expect -f

# ----------------------------------------------------------------------
# name:			login.sh
# version:		1.0
# createTime:	2016-08-11
# description:	ssh远程登录脚本
# author:		birdben
# email:		191654006@163.com
# github:		https://github.com/birdben
# ----------------------------------------------------------------------

# ssh登录用户名
set user birdben
# ssh登录host主机地址
set host 127.0.0.1
# ssh登录port端口号
set port 50022
# ssh登录密码
set password 123456
# ssh登录超时时间
set timeout -1

spawn ssh $user@$host -p $port
expect "password:"
send "$password\r"
interact