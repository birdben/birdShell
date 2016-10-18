### 启动Flume收集端
```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_collector_hdfs.conf -Dflume.root.logger=DEBUG,console -n agentX
```

### 启动Flume采集端，发送数据到Collector测试
```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_agent_file.conf -Dflume.root.logger=DEBUG,console -n agent3
```

### 后台启动Flume收集端
``` 
$ chmod +x agent_startup.sh
$ ./agent_startup.sh
```

### 后台启动Flume采集端
```
$ chmod +x collector_startup.sh
$ ./collector_startup.sh
```

### 需要依赖Hadoop的jar包
```
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/common/hadoop-common-2.7.1.jar ~/dev/flume-1.6.0/lib
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/common/lib/commons-configuration-1.6.jar ~/dev/flume-1.6.0/lib
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/common/lib/hadoop-auth-2.7.1.jar ~/dev/flume-1.6.0/lib
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/httpfs/tomcat/webapps/webhdfs/WEB-INF/lib/hadoop-hdfs-2.7.1.jar ~/dev/flume-1.6.0/lib
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/hdfs/lib/htrace-core-3.1.0-incubating.jar ~/dev/flume-1.6.0/lib
# 覆盖已有的commons-io.jar
cp ~/Downloads/develop/hadoop-2.7.1/share/hadoop/common/lib/commons-io-2.4.jar ~/dev/flume-1.6.0/lib
```