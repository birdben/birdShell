#### 日志解析正则表达式

```
"name":(.*),"request":(.*),("errorStatus":(.*),)?("errorCode":(.*),)?("errorMsg":(.*),)?"status":(.*),"uid":(.*),"did":(.*),"duid":(.*),"ua":(.*),"device_id":(.*),"ip":(.*),"server_timestamp":([0-9]*)
```

#### 启动Flume收集端
```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_hb.conf -Dflume.root.logger=DEBUG,console -n agentX
```

#### 启动Flume采集端，发送数据到Agent测试

```
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume_hb_file.conf -Dflume.root.logger=DEBUG,console -n agent1
```