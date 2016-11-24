nohup logstash -f ${LOGSTASH_HOME}/conf/logstash.conf 2>${LOGSTASH_HOME}/bin/logstash.out 1>${LOGSTASH_HOME}/bin/logstash.out &
tailf ${LOGSTASH_HOME}/bin/logstash.out
