#!bin/bash

software_path=$1

################# Logstash install #################
echo "安装目录是：$software_path"
echo "################# Logstash install start #################"
logstash_version='1.5.6'
logstash_tar='logstash-'${logstash_version}'.tar.gz'
logstash_home=$software_path'/logstash-'${logstash_version}
logstash_config=$software_path'/logstash-indexer.conf'
logstash_config_name='logstash-indexer.conf'
logstash_pattern='postfix'

if [ -d $logstash_home ]; then
  echo "delete $logstash_home"
  rm -rf $logstash_home
fi

if [ ! -f $logstash_tar ]; then
  echo "logstash tar not found - downloading $logstash_tar..."
  curl -o $logstash_tar https://download.elastic.co/logstash/logstash/$logstash_tar
fi

logstash_install_cmd="tar -zxf $logstash_tar -C $software_path/ && mkdir -p $logstash_home/conf/ && mkdir -p $logstash_home/patterns/ && cp $logstash_config_name $logstash_home/conf/ && cp $logstash_pattern $logstash_home/patterns/ && cd $logstash_home && nohup ./bin/logstash -f conf/$logstash_config_name &"
echo "running $logstash_install_cmd"
# 执行安装logstash命令
eval ${logstash_install_cmd}
echo "################# Logstash install end #################"

sleep 30
echo "################# check logstash process start #################"
ps -aux | grep logstash
echo "################# check logstash process end #################"