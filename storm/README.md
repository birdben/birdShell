## Storm安装配置

### 启动Zookeeper集群
```
$ ./bin/zkServer.sh start
```

### storm.yaml配置文件说明

- storm.zookeeper.servers : Storm依赖的Zookeeper集群地址
- storm.zookeeper.port : 如果Zookeeper集群使用的不是默认的端口号配置此项来修改
- storm.local.dir : Nimbus和Supervisor进程用于存储少量状态，如jars、confs等的本地磁盘目录，需要提前创建该目录并给以足够的访问权限。需要在每个Storm机器中都创建这样一个目录。
- nimbus.seeds : Storm集群Nimbus机器地址，各个Supervisor工作节点需要知道哪个机器是Nimbus，以便下载Topologies的jars、confs等文件。
- supervisor.slots.ports : 对于每个Supervisor工作节点，需要配置该工作节点可以运行的worker数量。每个worker占用一个单独的端口用于接收消息，该配置选项即用于定义哪些端口是可被worker使用的。默认情况下，每个节点上可运行4个workers，分别在6700、6701、6702和6703端口

### storm.yaml配置文件内容
```
storm.zookeeper.servers:
    - "hadoop2"
    - "hadoop3"

nimbus.host: "hadoop1"
```


### 启动Storm
```
# 启动Nimbus
$ bin/storm nimbus

# 启动Supervisor
$ bin/storm supervisor

# 启动UI
$ bin/storm ui
```

### 启动成功后访问Storm UI
```
http://hadoop1:8080
```