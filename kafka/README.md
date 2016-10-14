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