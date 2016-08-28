#!bin/bash

# ----------------------------------------------------------------------
# name:         logstash_shipper.sh
# version:      1.1
# createTime:   2016-08-11
# description:  logstash_shipper环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

install_path=$1

################# Logstash install #################
echo "安装目录是：$install_path"
echo "################# Logstash_shipper install start #################"

# logstash基础版本配置
#logstash_base_version='1.x'
logstash_base_version='2.x'

# 1.x版本配置
#logstash_version='1.5.6'

# 2.x版本配置
logstash_version='2.3.4'

logstash_tar='logstash-'${logstash_version}'.tar.gz'
logstash_home_before=$install_path'/logstash-'${logstash_version}
logstash_home=$install_path'/logstash-shipper-'${logstash_version}
logstash_config=$install_path'/logstash-shipper.conf'
logstash_config_file='logstash-shipper.conf'

if [ -d $logstash_home ]; then
  echo "delete $logstash_home"
  rm -rf $logstash_home
fi

if [ ! -f $logstash_base_version/$logstash_tar ]; then
  echo "$logstash_tar tar not found - downloading $logstash_tar..."
  curl -o $logstash_base_version/$logstash_tar https://download.elastic.co/logstash/logstash/$logstash_tar
fi

logstash_install_cmd="tar -zxf $logstash_base_version/$logstash_tar -C $install_path/ && mv $logstash_home_before $logstash_home && mkdir -p $logstash_home/conf/ && cp $logstash_base_version/$logstash_config_file $logstash_home/conf/ && cd $logstash_home && nohup ./bin/logstash -f conf/$logstash_config_file &"
echo "running $logstash_install_cmd"
# 执行安装logstash命令
eval ${logstash_install_cmd}
echo "################# Logstash_shipper install end #################"

sleep 30
echo "################# check logstash process start #################"
ps -ef | grep logstash
echo "################# check logstash process end #################"