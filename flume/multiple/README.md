##### 多个Agent的数据汇聚到同一个Agent

![多个Agent的数据汇聚到同一个Agent](http://7xnrdo.com1.z0.glb.clouddn.com/2014/flume-join-agent.png)

##### 分别启动汇总节点和三个Agent节点

```
# 最好先启动汇总节点的Agent
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_collect.conf -Dflume.root.logger=DEBUG,console -n agentX
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume.conf -Dflume.root.logger=DEBUG,console -n agent1
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume.conf -Dflume.root.logger=DEBUG,console -n agent2
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume.conf -Dflume.root.logger=DEBUG,console -n agent3
```

##### 验证结果

这时候我们只要在system.log, install.log, command.log中产生任何日志，都会输出对应的日志文件到/Users/yunyu/Downloads/sinkout/路径