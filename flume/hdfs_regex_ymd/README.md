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

```
agentX.sources = flume-avro-sink
agentX.channels = chX
agentX.sinks = flume-hdfs-sink

agentX.sources.flume-avro-sink.channels = chX
agentX.sources.flume-avro-sink.type = avro
agentX.sources.flume-avro-sink.bind = hadoop1
agentX.sources.flume-avro-sink.port = 41414
agentX.sources.flume-avro-sink.threads = 8


#定义拦截器，为消息添加时间戳和Host地址
#将日志中的name属性添加到Header中，用来做HDFS存储的目录结构，type_name属性就是从日志文件中解析出来的name属性的值，这里使用%Y%m表达式代表按照年月分区
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
agentX.sinks.flume-hdfs-sink.hdfs.path = hdfs://10.10.1.64:8020/flume/events/%{type_name}/%Y%m
agentX.sinks.flume-hdfs-sink.hdfs.fileType = DataStream
agentX.sinks.flume-hdfs-sink.hdfs.filePrefix = events-
agentX.sinks.flume-hdfs-sink.hdfs.rollInterval = 300
agentX.sinks.flume-hdfs-sink.hdfs.rollSize = 0
agentX.sinks.flume-hdfs-sink.hdfs.rollCount = 300
```

### Hive按照不同的HDFS目录建表
```
# 这里我们是需要先理解Hive的内部表和外部表的区别，然后我们在之前的建表语句中加入partition分区，我们这里使用的是dt字段作为partition，dt字段不能够与建表语句中的字段重复，否则建表时会报错。
CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_click_ad(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.click_ad';

CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_open_hb(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.open_hb';

CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_view_ad(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.view_ad';

# 这时候我们查询表，表中是没有数据的。我们需要手工添加partition分区之后，才能查到数据。
hive> select * from birdben_ad_click_ad;

# 建表完成之后，我们需要手工添加partition目录为我们Flume之前划分的好的年月目录
alter table birdben_ad_click_ad add partition(dt='201610') location '/flume/events/birdben_ad_click_ad/201610';
alter table birdben_ad_click_ad add partition(dt='201611') location '/flume/events/birdben_ad_click_ad/201611';

alter table birdben_ad_open_hb add partition(dt='201610') location '/flume/events/birdben.ad.open_hb/201610';
alter table birdben_ad_open_hb add partition(dt='201611') location '/flume/events/birdben.ad.open_hb/201611';

alter table birdben_ad_view_ad add partition(dt='201610') location '/flume/events/birdben.ad.view_ad/201610';
alter table birdben_ad_view_ad add partition(dt='201611') location '/flume/events/birdben.ad.view_ad/201611';

# 这时候我们查询表，能够查询到全部的数据了（包括201610和201611的数据）
hive> select * from birdben_ad_click_ad;
OK
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201611
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201611
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201611
Time taken: 0.1 seconds, Fetched: 9 row(s)

# 也可以按照分区字段查询数据，这样就能够证明我们可以使用Hive的External表partition对应到我们Flume中创建好的 %Y%m（年月） 目录结构
hive> select * from birdben_ad_click_ad where dt = '201610';
OK
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201610
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201610
Time taken: 0.099 seconds, Fetched: 6 row(s)

hive> select * from birdben_ad_click_ad where dt = '201611';
OK
[{"name":"birdben.ad.click_ad","rpid":"63146996042563584","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475912715001}]	info	logs	NULL	201611
[{"name":"birdben.ad.click_ad","rpid":"63148812297830402","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475913845544}]	info	logs	NULL	201611
[{"name":"birdben.ad.click_ad","rpid":"63152468644593666","bid":"0","uid":"0","did":"0","duid":"0","hbuid":null,"ua":"","device_id":"","ip":null,"server_timestamp":1475915093792}]	info	logs	NULL	201611
Time taken: 0.11 seconds, Fetched: 3 row(s)
```