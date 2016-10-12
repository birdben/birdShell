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

### Flume配置文件

这里将日志中的name属性添加到Header中，用来做HDFS存储的目录结构，type_name属性就是从日志文件中解析出来的name属性的值

```
agentX.sources.flume-avro-sink.interceptors = i1 i2
agentX.sources.flume-avro-sink.interceptors.i1.type = timestamp
agentX.sources.flume-avro-sink.interceptors.i2.type = regex_extractor
agentX.sources.flume-avro-sink.interceptors.i2.regex = "name":"(.*?)"
agentX.sources.flume-avro-sink.interceptors.i2.serializers = s1
agentX.sources.flume-avro-sink.interceptors.i2.serializers.s1.name = type_name

agentX.channels.chX.type = memory
agentX.channels.chX.capacity = 1000
agentX.channels.chX.transactionCapacity = 100

agentX.sinks.flume-hdfs-sink.type = hdfs
agentX.sinks.flume-hdfs-sink.channel = chX
agentX.sinks.flume-hdfs-sink.hdfs.path = hdfs://10.10.1.64:8020/flume/events/%{type_name}
agentX.sinks.flume-hdfs-sink.hdfs.fileType = DataStream
agentX.sinks.flume-hdfs-sink.hdfs.filePrefix = events-
agentX.sinks.flume-hdfs-sink.hdfs.rollInterval = 300
agentX.sinks.flume-hdfs-sink.hdfs.rollSize = 0
agentX.sinks.flume-hdfs-sink.hdfs.rollCount = 300
```