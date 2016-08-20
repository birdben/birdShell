#!bin/bash

# ----------------------------------------------------------------------
# name:         logstash_indexer.sh
# version:      1.1
# createTime:   2016-08-11
# description:  logstash_indexer环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

install_path=$1

################# Logstash_indexer install #################
echo "安装目录是：$install_path"
echo "################# Logstash_indexer install start #################"

# logstash基础版本配置
logstash_base_version='1.x'

# 1.x版本配置
logstash_version='1.5.6'

logstash_tar='logstash-'${logstash_version}'.tar.gz'
logstash_home_before=$install_path'/logstash-'${logstash_version}
logstash_home=$install_path'/logstash-indexer-'${logstash_version}
logstash_config=$install_path'/logstash-indexer.conf'
logstash_config_file='logstash-indexer.conf'
logstash_pattern_file='postfix'

if [ -d $logstash_home ]; then
  echo "delete $logstash_home"
  rm -rf $logstash_home
fi

if [ ! -f $logstash_base_version/$logstash_tar ]; then
  echo "logstash tar not found - downloading $logstash_tar..."
  curl -o $logstash_tar https://download.elastic.co/logstash/logstash/$logstash_tar
fi

logstash_install_cmd="tar -zxf $logstash_base_version/$logstash_tar -C $install_path/ && mv $logstash_home_before $logstash_home && mkdir -p $logstash_home/conf/ && mkdir -p $logstash_home/patterns/ && cp $logstash_base_version/$logstash_config_file $logstash_home/conf/ && cp $logstash_base_version/$logstash_pattern_file $logstash_home/patterns/ && cd $logstash_home && nohup ./bin/logstash -f conf/$logstash_config_file &"
echo "running $logstash_install_cmd"
# 执行安装logstash命令
eval ${logstash_install_cmd}
echo "################# Logstash_indexer install end #################"

sleep 30
echo "################# check logstash process start #################"
ps -aux | grep logstash
echo "################# check logstash process end #################"