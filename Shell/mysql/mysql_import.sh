#!/bin/bash

while read line
do
    echo $line
    mysql -h127.0.0.1 -uroot -proot -P3306 -Dtest -e "insert into test_table(test_field) values('$line')"
done < yourFileName