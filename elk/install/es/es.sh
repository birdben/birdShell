#!bin/bash

# ----------------------------------------------------------------------
# name:         es.sh
# version:      1.1
# createTime:   2016-08-11
# description:  es环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

install_path=$1

################# ES install #################
echo "安装目录是：$install_path"
echo "################# ES install start #################"

# es基础版本配置
#es_base_version='1.x'
es_base_version='2.x'

# 1.x版本配置
#es_version='1.7.3'
#es_head_plugin='elasticsearch-head-1.x.zip'
#es_ik_plugin='elasticsearch-analysis-ik-1.4.1.jar'
#es_ik_config_tar='ik.tar.gz'
#es_httpclient_jar='httpclient-4.5.jar'
#es_httpcore_jar='httpcore-4.4.1.jar'

# 2.x版本配置
es_version='2.3.5'
es_head_plugin='elasticsearch-head-master.zip'
es_ik_plugin='elasticsearch-analysis-ik-1.9.5.zip'

# 通用的参数
es_tar='elasticsearch-'${es_version}'.tar.gz'
es_home=$install_path'/elasticsearch-'${es_version}
es_config_file='elasticsearch.yml'

if [ -d $es_home ]; then
  echo "delete $es_home"
  rm -rf $es_home
fi

if [ ! -f $es_base_version/$es_tar ]; then
  echo "elasticsearch tar not found - downloading $es_tar..."
  curl -o $es_base_version/$es_tar https://download.elastic.co/elasticsearch/elasticsearch/$es_tar
fi

if [ ! -f $es_base_version/$es_head_plugin ]; then
  echo "elasticsearch-head zip not found - downloading $es_head_plugin..."
  if [ $es_base_version = '1.x' ]; then
  	curl -o $es_base_version/$es_head_plugin https://codeload.github.com/mobz/elasticsearch-head/zip/1.x
  fi
  if [ $es_base_version = '2.x' ]; then
  	curl -o $es_base_version/$es_head_plugin https://codeload.github.com/mobz/elasticsearch-head/zip/master
  fi
fi

es_install_cmd="tar -zxf $es_base_version/$es_tar -C $install_path/"
es_install_1_x_ik_plugin_cmd="tar -zxf $es_base_version/$es_ik_config_tar -C $es_home/config/ && cp $es_base_version/$es_ik_plugin $es_base_version/$es_httpclient_jar $es_base_version/$es_httpcore_jar $es_home/lib/ && cp $es_base_version/$es_config_file $es_home/config/"
es_install_2_x_ik_plugin_cmd="mkdir -p $es_home/plugins/ik && unzip -o $es_base_version/$es_ik_plugin -d $es_home/plugins/ik/ && cp $es_base_version/$es_config_file $es_home/config/"
es_install_1_x_head_plugin_cmd="cp $es_base_version/$es_head_plugin $install_path/ && cd $es_home && ./bin/plugin --install head --url file://$install_path/$es_head_plugin"
es_install_2_x_head_plugin_cmd="cp $es_base_version/$es_head_plugin $install_path/ && cd $es_home && ./bin/plugin install file://$install_path/$es_head_plugin"
es_startup_cmd="cd $es_home && ./bin/elasticsearch -d"
echo "running $es_install_cmd"
# 执行安装es命令
eval ${es_install_cmd}
if [ $es_base_version = '1.x' ]; then
  echo "安装1.x版本的插件"
  eval ${es_install_1_x_ik_plugin_cmd}
  eval ${es_install_1_x_head_plugin_cmd}
fi
if [ $es_base_version = '2.x' ]; then
  echo "安装2.x版本的插件"
  eval ${es_install_2_x_ik_plugin_cmd}
  eval ${es_install_2_x_head_plugin_cmd}
fi
eval ${es_startup_cmd}
echo "################# ES install end #################"

sleep 30
echo "################# check elasticsearch process start #################"
ps -ef | grep elasticsearch
echo "################# check elasticsearch process end #################"