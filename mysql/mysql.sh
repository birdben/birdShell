#!/bin/bash
##########################################################################################################
#Target Table : cluster_monitor.test
#Source Table : all tables
#Interface Name : 抓取当前数据源所有数据库，表，列的对应关系
#Refresh Frequency : per day 每天处理
#Refresh Mode : 无
#修改人       修改时间     修改原因
#-------     -----------   -------------------
#birdben     2016-07-09   新建
##########################################################################################################

HOST="127.0.0.1"
PORT="3306"
USER="root"
PASS="root"
DATABASE="cluster_monitor"

# select * from $TABLE;
databaseNameStr=`mysql -u$USER -p$PASS <<EOF
show databases;
EOF`

#echo $databaseNameStr;

OLD_IFS="$IFS";
IFS=" ";
databaseArray=("$databaseNameStr");
IFS="$OLD_IFS";
i=1;
for databaseName in ${databaseArray[@]} 
do 
    ((i++));
    #echo "$databaseName";
	
	# mysql -h$HOST -u$USER -p$PASS -P$PORT -D$DATABASE -e "use cluster_monitor;insert into test (id, url) values('$i', '$databaseName');";

	tableNameStr=`mysql -h$HOST -u$USER -p$PASS -P$PORT -D$DATABASE -e "use $databaseName; show tables;"`;
	# echo $tableNameStr;
    OLD_IFS="$IFS";
    IFS=" ";
    tableArray=("$tableNameStr");
    IFS="$OLD_IFS";
    j=1;
    for tableName in ${tableArray[@]}
    do
    	if [[ "$j" == 1 ]]; then
    	    ((j++));
    		continue;
    	fi
    	#echo "$tableName";
		columnNameStr=`mysql -h$HOST -u$USER -p$PASS -P$PORT -D$DATABASE -e "select COLUMN_NAME from information_schema.columns where table_name='$tableName';"`;
		#echo $columnNameStr;
	    OLD_IFS="$IFS";
	    IFS=" ";
	    columnArray=("$columnNameStr");
	    IFS="$OLD_IFS";
	    k=1;
	    for columnName in ${columnArray[@]}
	    do
	    	if [[ "$k" == 1 ]]; then
	    	    ((k++));
	    		continue;
	    	fi
	    	#echo "$columnName";
	    	mysql -h$HOST -u$USER -p$PASS -P$PORT -D$DATABASE -e "insert into test (id, dbName, tableName, columnName) values('$k', '$databaseName', '$tableName', '$columnName');";
	    	((k++));
	    done
    	((j++));
    done
done

