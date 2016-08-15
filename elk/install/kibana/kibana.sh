#!bin/bash

# ----------------------------------------------------------------------
# name:         kibana.sh
# version:      1.0
# createTime:   2016-08-11
# description:  kibana环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

software_path=$1

################# Kibana install #################
echo "安装目录是：$software_path"
echo "################# Kibana install start #################"
kibana_version='4.1.8'
kibana_tar='kibana-'${kibana_version}'-linux-x64.tar.gz'
kibana_home=$software_path'/kibana-'${kibana_version}'-linux-x64'
kibana_config=$software_path'/kibana.yml'
kibana_config_name='kibana.yml'

if [ ! -f $kibana_tar ]; then
  echo "elasticsearch tar not found - downloading $kibana_tar..."
  curl -o $kibana_tar https://download.elastic.co/kibana/kibana/$kibana_tar
fi

kibana_install_cmd="tar -zxf $kibana_tar -C $software_path/ && cp $kibana_config_name $kibana_home/config/ && cd $kibana_home && nohup ./bin/kibana &"
echo "running $kibana_install_cmd"
# 执行安装kibana命令
eval ${kibana_install_cmd}
echo "################# Kibana install end #################"

sleep 30
echo "################# check kibana process start #################"
ps -aux | grep kibana
echo "################# check kibana process end #################"