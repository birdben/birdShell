#!bin/bash

# ----------------------------------------------------------------------
# name:         kibana.sh
# version:      1.1
# createTime:   2016-08-11
# description:  kibana环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

install_path=$1

################# Kibana install #################
echo "安装目录是：$install_path"
echo "################# Kibana install start #################"

# Kibana基础版本配置
kibana_base_version='4.5.x'

# 4.x版本配置
#kibana_version='4.1.8'
kibana_version='4.5.4'

kibana_tar='kibana-'${kibana_version}'-linux-x64.tar.gz'
kibana_home=$install_path'/kibana-'${kibana_version}'-linux-x64'
kibana_config=$install_path'/kibana.yml'
kibana_config_file='kibana.yml'

if [ -d $kibana_home ]; then
  echo "delete $kibana_home"
  rm -rf $kibana_home
fi

if [ ! -f $kibana_base_version/$kibana_tar ]; then
  echo "$kibana_tar not found - downloading $kibana_tar..."
  curl -o $kibana_base_version/$kibana_tar https://download.elastic.co/kibana/kibana/$kibana_tar
fi

kibana_install_cmd="tar -zxf $kibana_base_version/$kibana_tar -C $install_path/ && cp $kibana_base_version/$kibana_config_file $kibana_home/config/ && cd $kibana_home && nohup ./bin/kibana &"
echo "running $kibana_install_cmd"
# 执行安装kibana命令
eval ${kibana_install_cmd}
echo "################# Kibana install end #################"

sleep 30
echo "################# check kibana process start #################"
ps -aux | grep kibana
echo "################# check kibana process end #################"