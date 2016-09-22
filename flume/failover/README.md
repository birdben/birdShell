##### Failover架构

![Failover](http://img.blog.csdn.net/20160824170052276?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

##### 启动Flume Agent

```
# 启动采集端，AgentX
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_failover_agent.conf -Dflume.root.logger=DEBUG,console -n agentX

# 启动2个Collect端，Collector1和Collector2
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_failover_collector1.conf -Dflume.root.logger=DEBUG,console -n agent1
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_failover_collector2.conf -Dflume.root.logger=DEBUG,console -n agent2
```