## Kafka单节点模式

### 启动Zookeeper

#### 使用Kafka内置的Zookeeper服务
```
$ ./bin/zookeeper-server-start.sh config/zookeeper.properties
```

#### 使用外置的Zookeeper服务
```
# 分别启动Hadoop1，Hadoop2，Hadoop3三台服务器的Zookeeper服务
$ ./bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /data/zookeeper-3.4.8/bin/../conf/zoo.cfg
Starting zookeeper ... already running as process 4468.

# 分别查看一下Zookeeper服务的状态
$ ./bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /data/zookeeper-3.4.8/bin/../conf/zoo.cfg
Mode: leader
```

### 启动Kafka

#### 修改server.properties配置文件
```
# 添加内置的Zookeeper配置
# zookeeper.connect=127.0.0.1:2181
# 添加外置的Zookeeper集群配置
zookeeper.connect=10.10.1.64:2181,10.10.1.94:2181,10.10.1.95:2181
```

#### 启动单节点的Kafka服务
```
$ ./bin/kafka-server-start.sh config/server.properties &
```

## Kafka集群模式

### 启动Zookeeper

Zookeeper的配置方式和上面的方式一样

### 启动Kafka集群

这里三台服务器的Kafka配置基本都一样，只有server.properties配置文件中的broker.id（用来唯一标识Kafka集群节点的）不一样

#### 修改server.properties配置文件
```
# 分别在10.10.1.64，10.10.1.94，10.10.1.95三台机器上的配置文件设置broker.id为0，1，2
# broker.id是用来唯一标识Kafka集群节点的
broker.id=1
```

#### 分别启动三台机器的Kafka服务
```
$ ./bin/kafka-server-start.sh config/server.properties &
```


## 使用单节点Kafka
```
# 创建Topic test1
$ ./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test1
Created topic "test1".

# 查看我们所有的Topic，可以看到test1
$ ./bin/kafka-topics.sh --list --zookeeper localhost:2181
__consumer_offsets
connect-test
kafka_test
my-replicated-topic
streams-file-input
test1

# 启动producer服务，向test1的Topic中发送消息
$ ./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test1
this is a message
this is another message
still a message

# 启动consumer服务，从test1的Topic中接收消息
$ ./bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test1 --from-beginning
this is a message
this is another message
still a message
```

## 使用集群Kafka
```
# 创建新的Topic kafka_cluster_topic
$ ./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic kafka_cluster_topic

# 查看Topic kafka_cluster_topic的状态，发现Leader是1（broker.id=1）,有三个备份分别是0，1，2
$ ./bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic kafka_cluster_topic
Topic:kafka_cluster_topic   PartitionCount:1    ReplicationFactor:3 Configs:
    Topic: kafka_cluster_topic  Partition: 0    Leader: 1   Replicas: 1,0,2 Isr: 1,0,2

# 启动producer服务，向kafka_cluster_topic的Topic中发送消息
$ ./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic kafka_cluster_topic
this is a message
my name is birdben

# 启动consumer服务，从kafka_cluster_topic的Topic中接收消息
$ ./bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafka_cluster_topic --from-beginning
this is a message
my name is birdben
```