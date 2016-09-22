### ES1.x版本

#### 启动Flume收集端
```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_collector_es1.conf -Dflume.root.logger=DEBUG,console -n agentX
```

#### 启动Flume采集端，发送数据到Collector测试

```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_agent_file.conf -Dflume.root.logger=DEBUG,console -n agent3
```

### ES2.x版本

#### 启动Flume收集端
```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_collector_es2.conf -Dflume.root.logger=DEBUG,console -n agentX
```

#### 启动Flume采集端，发送数据到Collector测试

```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_agent_file.conf -Dflume.root.logger=DEBUG,console -n agent3
```