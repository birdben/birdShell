#!bin/bash

# ----------------------------------------------------------------------
# name:         redis.sh
# version:      1.0
# createTime:   2016-08-11
# description:  redis环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

software_path=$1

################ Redis install #################
echo "安装目录是：$software_path"
echo "################# Redis install start #################"
redis_version='3.2.3'
redis_tar='redis-'${redis_version}'.tar.gz'
redis_home=$software_path'/redis-'${redis_version}
redis_config=$software_path'/redis.conf'
redis_config_name='redis.conf'

if [ -d $redis_home ]; then
  echo "delete $redis_home"
  rm -rf $redis_home
fi

if [ ! -f $redis_tar ]; then
  echo "redis tar not found - downloading $redis_tar..."
  curl -o $redis_tar http://download.redis.io/releases/$redis_tar
fi

redis_install_cmd="tar -zxf $redis_tar -C $software_path/ && cp $redis_config_name $redis_home/ && cd $redis_home && make && ./src/redis-server redis.conf"
echo "running $redis_install_cmd"
# 执行安装redis命令
eval ${redis_install_cmd}
echo "################# Redis install end #################"

sleep 30
echo "################# check redis process start #################"
ps -aux | grep redis
echo "################# check redis process end #################"