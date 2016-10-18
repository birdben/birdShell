#!/bin/bash
nohup ./bin/flume-ng agent --conf ./conf/ -f conf/flume_collector_kafka.conf -Dflume.root.logger=DEBUG,console -n agentX &