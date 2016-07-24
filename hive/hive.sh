#!/bin/bash
##########################################################################################################
#Target Table : cluster_monitor.test
#Source Table : hive all tables
#Interface Name : 抓取当前hive所有数据库，表，列的对应关系
#Refresh Frequency : per day 每天处理
#Refresh Mode : 无
#修改人       修改时间     修改原因
#-------     -----------   -------------------
#birdben     2016-07-09   新建
##########################################################################################################

MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_USER="root"
MYSQL_PASS="root"
MYSQL_DATABASE="cluster_monitor"
MYSQL_TABLE="test"

databaseNameArray=(`./hive -e "show databases;"`);

# echo ${databaseNameArray[*]};
i=1
for databaseName in ${databaseNameArray[@]} 
do 
    echo "$databaseName";
    ((i++));
    #echo "$databaseName";
	
	# mysql -h$HOST -u$USER -p$PASS -P$PORT -D$DATABASE -e "use cluster_monitor;insert into test (id, url) values('$i', '$databaseName');";

	tableNameArray=(`./hive -e "use $databaseName; show tables;"`);
	# echo $tableNameStr;
    j=1;
    for tableName in ${tableNameArray[@]}
    do
    	echo "$tableName";
		columnNameArray=(`./hive -e "use $databaseName; desc $tableName;" | while read a b; do echo "$a"; done`);
		# echo "$columnNameArray";
	    k=1;
	    for columnName in ${columnNameArray[@]}
	    do
	    	echo "$columnName";
	    	mysql -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -P$MYSQL_PORT -D$MYSQL_DATABASE -e "insert into $MYSQL_TABLE (id, dbName, tableName, columnName) values('$k', '$databaseName', '$tableName', '$columnName');";
	    	((k++));
	    done
    	((j++));
    done
done
echo "OK!"

