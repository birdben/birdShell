java -cp KafkaOffsetMonitor-assembly-0.2.1.jar \
     com.quantifind.kafka.offsetapp.OffsetGetterWeb \
     --zk hadoop1,hadoop2,hadoop3 \
     --port 9999 \
     --refresh 10.seconds \
     --retain 2.days