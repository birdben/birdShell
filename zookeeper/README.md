## zookeeper集群环境搭建

#### 配置每个服务器的myid，对应zoo序号执行
```
$ echo 1 > /var/zookeeper/myid
$ echo 2 > /var/zookeeper/myid
$ echo 3 > /var/zookeeper/myid
```

#### 配置每个服务器的/etc/hosts文件
```
172.17.0.51     zoo1
172.17.0.52     zoo2
172.17.0.53     zoo3
```

#### 分别启动每个服务器的zookeeper服务
```
$ ./{ZOOKEEPER_HOME}/bin/zkServer.sh start
```

#### 查看每个服务器的zookeeper运行状态，会出现类似如下的结果就说明zookeeper集群环境运行正常
```
$ ./{ZOOKEEPER_HOME}/bin/zkServer.sh status
```

```
root@zoo1:/software/zookeeper-3.4.8/bin# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /software/zookeeper-3.4.8/bin/../conf/zoo.cfg
Mode: follower

root@zoo2:/software/zookeeper-3.4.8/bin# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /software/zookeeper-3.4.8/bin/../conf/zoo.cfg
Mode: leader

root@zoo3:/software/zookeeper-3.4.8/bin# ./zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /software/zookeeper-3.4.8/bin/../conf/zoo.cfg
Mode: follower
```