### 运行KafkaOffsetMonitor监控服务

下载 [KafkaOffsetMonitor](https://github.com/quantifind/KafkaOffsetMonitor/releases/latest) 的jar包，然后执行下面的运行命令，然后我们就能够访问 http://localhost:9999/ 来进入KafkaOffsetMonitor的监控后台。

```
java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk hadoop1,hadoop2,hadoop3 \
     --port 9999 \
     --refresh 10.seconds \
     --retain 2.days
```

- offsetStorage : 已取消
- zk : Zookeeper服务器地址
- port : KafkaOffsetMonitor监控服务使用的Web服务器端口
- refresh : 多长时间将app数据刷新一次到DB
- retain : 保存多久的数据到DB
- dbName : 历史数据存储的数据库名(default 'offsetapp')
- kafkaOffsetForceFromStart : 已取消
- stormZKOffsetBase : 已取消
- pluginsArgs : 扩展使用

注意：这里使用的0.2.1版本，0.2.1版本已经没有offsetStorage参数了，所以网上搜索的一些文章中使用的老版本还配置了offsetStorage参数，这里需要注意一下。
