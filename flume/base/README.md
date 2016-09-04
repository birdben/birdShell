### 开启两个终端，一个执行Flume Agent，一个执行Flume AvroClient

#### 启动Flume Agent端
```
# 这里指定的agent1名称必须和flume.conf配置文件中的agent名称一致
# 这里的启动命令是./bin/flume-ng agent，开始监听41414端口
$ ./bin/flume-ng agent --conf ./conf/ -f conf/flume.conf -Dflume.root.logger=DEBUG,console -n agent1
```

#### 启动Flume AvroClient端，发送数据到Agent测试

```
# 这里我使用的是本机IP：10.10.1.23，如果是本机测试也可以使用localhost
# 这里的启动命令是./bin/flume-ng avro-client
# -H：AvroClient指定Flume-ng Agent的IP或者hostname
# -p：AvroClient指定Avro source正在监听的端口
# -f：发送指定文件的每行数据给Flume Agent
$ ./bin/flume-ng avro-client --conf conf -H 10.10.1.23 -p 41414 -F /etc/passwd -Dflume.root.logger=DEBUG,console
```