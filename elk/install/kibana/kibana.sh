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
#echo `dirname $0`
shell_path=$(cd `dirname $0`; pwd)
echo "执行脚本的目录是：$shell_path"

# --------------------------------------------------------------------------------------------------------------------------------------------
# kibana的版本和sense插件的版本

#kibana_version='4.1.8'
#kibana_sense_version='4.1.8'

#kibana_version='4.4.2'
#kibana_sense_version='kibana-4.4'

kibana_version='4.5.4'
kibana_sense_version='2.0.0-beta7'

if [[ $kibana_version =~ 4.1.* ]]; then
  kibana_base_version='4.1.x'
fi
if [[ $kibana_version =~ 4.4.* ]]; then
  kibana_base_version='4.4.x'
fi
if [[ $kibana_version =~ 4.5.* ]]; then
  kibana_base_version='4.5.x'
fi
# --------------------------------------------------------------------------------------------------------------------------------------------
# 通用的参数
kibana_skip_sense_plugin='no'
kibana_tar='kibana-'${kibana_version}'-linux-x64.tar.gz'
kibana_home=$install_path'/kibana-'${kibana_version}'-linux-x64'
kibana_config=$install_path'/kibana.yml'
kibana_config_file='kibana.yml'
# --------------------------------------------------------------------------------------------------------------------------------------------
# 安装sense插件命令
if [ $kibana_sense_version = '2.0.0-beta7' ]; then
  kibana_install_sense_plugin_cmd='cd '$shell_path' && cp '$kibana_base_version'/kibana-sense-'${kibana_sense_version}'.tar.gz '$install_path'/ && cd '$kibana_home' && ./bin/kibana plugin --install sense --url file://'$install_path'/kibana-sense-'${kibana_sense_version}'.tar.gz'
fi

if [ ! -f $kibana_base_version/$kibana_tar ]; then
  echo "$kibana_tar not found - downloading $kibana_tar..."
  curl -o $kibana_base_version/$kibana_tar https://download.elastic.co/kibana/kibana/$kibana_tar
fi

# 安装Kibana命令
kibana_install_cmd="tar -zxf $kibana_base_version/$kibana_tar -C $install_path/ && cp $kibana_base_version/$kibana_config_file $kibana_home/config/"
kibana_startup_cmd="cd $kibana_home && nohup ./bin/kibana &"
# --------------------------------------------------------------------------------------------------------------------------------------------
################# Kibana install #################
echo "安装目录是：$install_path"
echo "################# Kibana install start #################"

if [ -d $kibana_home ]; then
  echo "delete $kibana_home"
  rm -rf $kibana_home
fi

if [ ! -f $kibana_base_version/kibana-sense-${kibana_sense_version}.tar.gz ]; then
  echo "$kibana_base_version/kibana-sense-${kibana_sense_version}.tar.gz not found - downloading kibana-sense-${kibana_sense_version}.tar.gz..."
  if [ $kibana_sense_version = '2.0.0-beta7' ]; then
    curl -o $kibana_base_version/'kibana-sense-'${kibana_sense_version}'.tar.gz' https://download.elasticsearch.org/elasticsearch/sense/sense-${kibana_sense_version}.tar.gz
  fi
fi
# --------------------------------------------------------------------------------------------------------------------------------------------
# 执行安装kibana命令
echo "running ${kibana_install_cmd}"
eval ${kibana_install_cmd}
if [ $kibana_skip_sense_plugin = 'no' ]; then
  # 安装sense插件
  echo "running ${kibana_install_sense_plugin_cmd}"
  eval ${kibana_install_sense_plugin_cmd}
fi
sleep 5
echo "running ${kibana_startup_cmd}"
eval ${kibana_startup_cmd}
echo "################# Kibana install end #################"

sleep 30
echo "################# check kibana process start #################"
ps -ef | grep kibana
echo "################# check kibana process end #################"