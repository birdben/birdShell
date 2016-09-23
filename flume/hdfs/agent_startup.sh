#!/bin/bash
nohup ./bin/flume-ng agent --conf ./conf/ -f conf/flume_agent_file.conf -Dflume.root.logger=DEBUG,console -n agent3 &