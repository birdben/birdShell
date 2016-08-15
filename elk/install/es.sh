#!bin/bash

# ----------------------------------------------------------------------
# name:         es.sh
# version:      1.0
# createTime:   2016-08-11
# description:  es环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

software_path=$1

################# ES install #################
echo "安装目录是：$software_path"
echo "################# ES install start #################"
es_version='1.7.3'
es_tar='elasticsearch-'${es_version}'.tar.gz'
es_head_plugin='elasticsearch-head-1.x.zip'
es_home=$software_path'/elasticsearch-'${es_version}
es_config=$software_path'/elasticsearch.yml'
es_config_name='elasticsearch.yml'
es_httpclient_name='httpclient-4.5.jar'
es_httpcore_name='httpcore-4.4.1.jar'
es_ik_name='elasticsearch-analysis-ik-1.4.1.jar'
es_ik_config_tar='ik.tar.gz'

if [ -d $es_home ]; then
  echo "delete $es_home"
  rm -rf $es_home
fi

if [ ! -f $es_tar ]; then
  echo "elasticsearch tar not found - downloading $es_tar..."
  curl -o $es_tar https://download.elastic.co/elasticsearch/elasticsearch/$es_tar
fi

if [ ! -f $es_head_plugin ]; then
  echo "elasticsearch-head zip not found - downloading $es_head_plugin..."
  curl -o $es_head_plugin https://codeload.github.com/mobz/elasticsearch-head/zip/1.x
fi

es_install_cmd="tar -zxf $es_tar -C $software_path/ && tar -zxf $es_ik_config_tar -C $es_home/config/ && cp $es_ik_name $es_httpclient_name $es_httpcore_name $es_home/lib/ && cp $es_config_name $es_home/config/"
es_install_plugin_cmd="cp $es_head_plugin $software_path/ && cd $es_home && ./bin/plugin --install head --url file://$software_path/$es_head_plugin"
es_startup_cmd="./bin/elasticsearch -d"
echo "running $es_install_cmd"
# 执行安装es命令
eval ${es_install_cmd}
eval ${es_install_plugin_cmd}
eval ${es_startup_cmd}
echo "################# ES install end #################"

sleep 30
echo "################# check elasticsearch process start #################"
ps -aux | grep elasticsearch
echo "################# check elasticsearch process end #################"