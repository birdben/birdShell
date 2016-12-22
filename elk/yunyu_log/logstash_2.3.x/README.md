
track.log, proxy.log日志都使用json的方式读取，在Logstash写入Kafka时，默认的和自定义的header（host，type）也被添加到当前的json字符串中

```
$ kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic node_log
{"message":"::1 [16/Jun/2016:09:05:22 +0800] \"GET /api/login HTTP/1.1\" 200 - \"http://121.42.52.69:3005/app/mock\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\" -","@version":"1","@timestamp":"2016-12-08T12:19:20.936Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:09:05:41 +0800] \"GET /api/login?partner=demo&user_id=admin&mobile=1111111&channel=1a2b3c&timestamp=1466039122&sign=222222222222222222222 HTTP/1.1\" 302 46 \"http://121.42.52.69:3005/app/mock\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\" -","@version":"1","@timestamp":"2016-12-08T12:19:21.279Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:10:42:57 +0800] \"POST /api/test HTTP/1.1\" 200 412 \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.4.2; vivo Xplay3S Build/KVT49L)\" 111111111111","@version":"1","@timestamp":"2016-12-08T12:19:21.280Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:10:42:58 +0800] \"GET /api/settings HTTP/1.1\" 200 - \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.4.2; vivo Xplay3S Build/KVT49L)\" 111111111111","@version":"1","@timestamp":"2016-12-08T12:19:21.281Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:29:03 +0800] \"GET / HTTP/1.0\" 302 26 \"-\" \"-\" -","@version":"1","@timestamp":"2016-12-08T12:19:21.282Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:29:03 +0800] \"GET / HTTP/1.1\" 302 26 \"-\" \"-\" -","@version":"1","@timestamp":"2016-12-08T12:19:21.283Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:31:32 +0800] \"HEAD /09 HTTP/1.1\" 302 32 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2269.0 Safari/537.36 webbat-util 638 TenXcan/1.0.602\" -","@version":"1","@timestamp":"2016-12-08T12:19:21.283Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"request-id":"14759126775778103","device-id":"12345678","version":"android_rp_3.2.0","api":"GET /api/test?ID=12345678","bid":"111","uid":"","hb_uid":"222","duid":"3333","dealer_id":"4444","dealer_code":"5555","target":"http://10.10.1.10:9182","level":"info","message":"proxy begin","timestamp":"2016-10-08T07:44:50.757Z","@version":"1","@timestamp":"2016-12-08T12:19:21.338Z","path":"/home/yunyu/Downloads/proxy.log","host":"hadoop1","type":"node_proxy"}
{"request-id":"14759126775822136","device-id":"87654321","version":"android_rp_3.2.0","api":"GET /api/settings","bid":"111","uid":"","hb_uid":"222","duid":"3333","dealer_id":"4444","dealer_code":"5555","target":"http://10.10.1.10:91","level":"info","message":"proxy begin","timestamp":"2016-10-08T07:44:50.768Z","@version":"1","@timestamp":"2016-12-08T12:19:21.339Z","path":"/home/yunyu/Downloads/proxy.log","host":"hadoop1","type":"node_proxy"}
{"logs":[{"name":"birdben.api.call","request":"GET /api/login","status":"succeeded","uid":0,"did":104,"duid":"12345678","ua":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36","device_id":"","ip":"::1","server_timestamp":1466039122789}],"level":"info","message":"logs","timestamp":"2016-06-16T01:05:22.791Z","@version":"1","@timestamp":"2016-12-08T12:19:21.340Z","path":"/home/yunyu/Downloads/track.log","host":"hadoop1","type":"node_track"}
{"logs":[{"name":"birdben.api.call","request":"GET /api/test/card","status":"succeeded","uid":0,"did":100,"duid":"admin123","ua":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36","device_id":"","ip":"::1","server_timestamp":1466039142595}],"level":"info","message":"logs","timestamp":"2016-06-16T01:05:42.595Z","@version":"1","@timestamp":"2016-12-08T12:19:21.341Z","path":"/home/yunyu/Downloads/track.log","host":"hadoop1","type":"node_track"}
```


track.log, proxy.log, access.log三种日志都使用plain的方式读取，所有原始日志被Logstash封装到message属性中，然后Logstash写入Kafka默认是json格式的字符串，message是其中json字符串的属性，还有默认的和自定义的header（host，type）也是json字符串的属性

```
$ kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic node_log_plain
{"message":"{\"request-id\":\"14759126775778103\",\"device-id\":\"12345678\",\"version\":\"android_rp_3.2.0\",\"api\":\"GET /api/test?ID=12345678\",\"bid\":\"111\",\"uid\":\"\",\"hb_uid\":\"222\",\"duid\":\"3333\",\"dealer_id\":\"4444\",\"dealer_code\":\"5555\",\"target\":\"http://10.10.1.10:9182\",\"level\":\"info\",\"message\":\"proxy begin\",\"timestamp\":\"2016-10-08T07:44:50.757Z\"}","@version":"1","@timestamp":"2016-12-08T13:27:11.743Z","path":"/home/yunyu/Downloads/proxy.log","host":"hadoop1","type":"node_proxy"}
{"message":"::1 [16/Jun/2016:09:05:22 +0800] \"GET /api/login HTTP/1.1\" 200 - \"http://121.42.52.69:3005/app/mock\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\" -","@version":"1","@timestamp":"2016-12-08T13:27:11.739Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"{\"request-id\":\"14759126775822136\",\"device-id\":\"87654321\",\"version\":\"android_rp_3.2.0\",\"api\":\"GET /api/settings\",\"bid\":\"111\",\"uid\":\"\",\"hb_uid\":\"222\",\"duid\":\"3333\",\"dealer_id\":\"4444\",\"dealer_code\":\"5555\",\"target\":\"http://10.10.1.10:91\",\"level\":\"info\",\"message\":\"proxy begin\",\"timestamp\":\"2016-10-08T07:44:50.768Z\"}","@version":"1","@timestamp":"2016-12-08T13:27:11.949Z","path":"/home/yunyu/Downloads/proxy.log","host":"hadoop1","type":"node_proxy"}
{"message":"::1 [16/Jun/2016:09:05:41 +0800] \"GET /api/login?partner=demo&user_id=admin&mobile=1111111&channel=1a2b3c&timestamp=1466039122&sign=222222222222222222222 HTTP/1.1\" 302 46 \"http://121.42.52.69:3005/app/mock\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\" -","@version":"1","@timestamp":"2016-12-08T13:27:11.949Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:10:42:57 +0800] \"POST /api/test HTTP/1.1\" 200 412 \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.4.2; vivo Xplay3S Build/KVT49L)\" 111111111111","@version":"1","@timestamp":"2016-12-08T13:27:11.950Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:10:42:58 +0800] \"GET /api/settings HTTP/1.1\" 200 - \"-\" \"Dalvik/1.6.0 (Linux; U; Android 4.4.2; vivo Xplay3S Build/KVT49L)\" 111111111111","@version":"1","@timestamp":"2016-12-08T13:27:11.951Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:29:03 +0800] \"GET / HTTP/1.0\" 302 26 \"-\" \"-\" -","@version":"1","@timestamp":"2016-12-08T13:27:11.951Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:29:03 +0800] \"GET / HTTP/1.1\" 302 26 \"-\" \"-\" -","@version":"1","@timestamp":"2016-12-08T13:27:11.952Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"::1 [16/Jun/2016:14:31:32 +0800] \"HEAD /09 HTTP/1.1\" 302 32 \"-\" \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2269.0 Safari/537.36 webbat-util 638 TenXcan/1.0.602\" -","@version":"1","@timestamp":"2016-12-08T13:27:11.955Z","path":"/home/yunyu/Downloads/access.log","host":"hadoop1","type":"node_access"}
{"message":"{\"logs\":[{\"name\":\"birdben.api.call\",\"request\":\"GET /api/login\",\"status\":\"succeeded\",\"uid\":0,\"did\":104,\"duid\":\"12345678\",\"ua\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\",\"device_id\":\"\",\"ip\":\"::1\",\"server_timestamp\":1466039122789}],\"level\":\"info\",\"message\":\"logs\",\"timestamp\":\"2016-06-16T01:05:22.791Z\"}","@version":"1","@timestamp":"2016-12-08T13:27:11.727Z","path":"/home/yunyu/Downloads/track.log","host":"hadoop1","type":"node_track"}
{"message":"{\"logs\":[{\"name\":\"birdben.api.call\",\"request\":\"GET /api/test/card\",\"status\":\"succeeded\",\"uid\":0,\"did\":100,\"duid\":\"admin123\",\"ua\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.86 Safari/537.36\",\"device_id\":\"\",\"ip\":\"::1\",\"server_timestamp\":1466039142595}],\"level\":\"info\",\"message\":\"logs\",\"timestamp\":\"2016-06-16T01:05:42.595Z\"}","@version":"1","@timestamp":"2016-12-08T13:27:11.956Z","path":"/home/yunyu/Downloads/track.log","host":"hadoop1","type":"node_track"}
```