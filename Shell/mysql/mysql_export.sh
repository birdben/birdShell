#!/bin/bash

# 这里将MySQL的查询结果复制给一个变量，在输出这个变量
selectResult=`mysql -uroot -proot -e "use mysql;select host,user,password from user;"`
echo $selectResult;

# 这里将MySQL的查询结果导出到文件中
mysql -uroot -proot -e "use mysql;select host,user,password from user into outfile '/Users/ben/Downloads/demo_result';"