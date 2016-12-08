### 使用Flume遇到的问题

之前的架构是Flume + KafKa + Logstash + ES

这么使用的原因是公司的历史架构原因，以前的是使用的Flume + Kafka + ES的架构，后来因为ES升级到2.x版本，Flume对新版本的ES支持的不够理想，所以我们将Indexer换成了Logstash来更好的整合ES。但是在后续的使用中发现了Shipper和Indexer使用Flume和Logstash的兼容有些问题。

在采集日志文件时，同一类型的日志文件可能会有多个，例如：php的日志可能会分为api.log, middleware.log, server.log等等，但这些都属于php的日志而且日志的格式都是相同的，只是不同的文件，需要在ES搜索时按照不同的type进行筛选。此时如果都使用Logstash不会有任何问题，我们只需要在Shipper端添加一个type作为Message的Header，然后将Message写入Kafka，Indexer读取出来的Message仍然带有此Header，最终会写入到ES中，整个过程Header都会在Message中。如果Shipper端使用Flume会有些小问题，Flume首先需要升级到1.7版本，这样才能支持Flume往Kafka中写入带有Header的Message。但是Flume写入Kafka的Message目前只支持StringSerializer和ByteArraySerializer两种序列化方式。如果是Logstash去读取该Message就无法正确的获取到Message的Header，因为Logstash Kafka插件默认读取和写入的Message都是json，但是可以灵活的定义读取和写入的Message格式，但是Flume写入的Message不是简单的String，所以使用Logstash Indexer不知道应该如何解析Message提取出来Header字段type。所以如果Message中需要带有Header建议还是Shipper和Indexer尽量统一，最终放弃使用Flume做Shipper，未来会替换成Logstash。

### Flume_1.7.0 Shipper配置

```
...
# 开启Flume写入Header，默认是使用StringSerializer方式序列化Message的
# 默认是只将body写入到Kafka的，设置为true会根据Flume Avro binary格式来存储Event
# org.apache.kafka.common.serialization.StringSerializer
# org.apache.kafka.common.serialization.ByteArraySerializer
agentX.sinks.go-kafka-sink.useFlumeEventFormat = true
...
```

### Logstash Shipper配置

```
input {
    file {
        path => ["/home/yunyu/Downloads/rpserver.INFO"]
        type => "rpserver"
        codec => "plain"
        start_position => "beginning"
        # 设置是否忽略太旧的日志的
        # 如果没设置该属性可能会导致读取不到文件内容，因为我们的日志大部分是好几个月前的，所以这里设置为不忽略
        ignore_older => 0
    }
}

output {
    stdout {
        codec => rubydebug
    }
    kafka {
        # 指定Kafka集群地址
        bootstrap_servers => "hadoop1:9092,hadoop2:9092,hadoop3:9092"
        # 指定Kafka的Topic
        topic_id => "golog_rpserver"
    }
}
```

### Kafka中存储的Message消息

- Flume默认写入到Kafka是按照StringSerializer序列化的，但是不知道应该如何解析Message提取出来Header字段type
- Logstash默认写入到Kafka是按照json的，message字段中是我们的Message正文，path，host是Logstash自动添加上的Header，type是我们配置文件中添加的Header

```
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
typerpserver�I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.644Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.792Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.793Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.793Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.794Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
{"message":"I1123 20:34:49.558131    1669 config.go:176] Load Config file = /home/birdben/conf/million.yaml","@version":"1","@timestamp":"2016-12-08T07:33:16.794Z","path":"/home/yunyu/Downloads/rpserver.INFO","host":"hadoop1","type":"rpserver"}
```