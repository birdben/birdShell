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
#echo `dirname $0`
shell_path=$(cd `dirname $0`; pwd)
echo "执行脚本的目录是：$shell_path"

# --------------------------------------------------------------------------------------------------------------------------------------------
# es的版本和ik插件的版本
es_ik_config_tar='ik.tar.gz'

# 已测试
#es_version='1.7.3'
#es_ik_version='1.4.1'
#es_bigdesk_version='2.5.0'
#es_kopf_version='v1.6.2'

# 已测试
es_version='2.3.5'
es_ik_version='1.9.5'
es_bigdesk_version='master'
es_kopf_version='master'

# 已测试
#es_version='2.2.1'
#es_ik_version='1.8.1'
#es_bigdesk_version='v2.2.a'
#es_kopf_version='v2.1.2'

# 已测试
#es_version='2.0.0'
#es_ik_version='1.5.0'
#es_bigdesk_version='v2.2.a'
#es_kopf_version='v2.1.2'

if [[ $es_version =~ 1.* ]]; then
  es_base_version='1.x'
  es_head_version='1.x'
fi
if [[ $es_version =~ 2.* ]]; then
  es_base_version='2.x'
  es_head_version='master'
fi
# --------------------------------------------------------------------------------------------------------------------------------------------
# 通用的参数
es_skip_ik_plugin='no'
es_skip_head_plugin='no'
es_skip_bigdesk_plugin='no'
es_skip_kopf_plugin='no'
es_tar='elasticsearch-'${es_version}'.tar.gz'
es_home=$install_path'/elasticsearch-'${es_version}
es_config_file='elasticsearch.yml'
# --------------------------------------------------------------------------------------------------------------------------------------------
# 安装head插件命令
if [ $es_head_version = '1.x' ]; then
  es_install_head_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-head-'${es_head_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin --install head --url file://'$install_path'/elasticsearch-head-'${es_head_version}'.zip'
fi
if [ $es_head_version == 'master' ]; then
  es_install_head_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-head-'${es_head_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin install file://'$install_path'/elasticsearch-head-'${es_head_version}'.zip'
fi

# 安装bigdesk插件命令
if [ $es_bigdesk_version == '2.5.0' ]; then
  es_install_bigdesk_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin --install bigdesk --url file://'$install_path'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip'
fi
if [ $es_bigdesk_version == 'v2.2.a' ]; then
  es_install_bigdesk_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin install file://'$install_path'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip'
fi
if [ $es_bigdesk_version == 'master' ]; then
  es_install_bigdesk_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin install file://'$install_path'/elasticsearch-bigdesk-'${es_bigdesk_version}'.zip'
fi

# 安装kopf插件命令
if [ $es_kopf_version == 'v1.6.2' ]; then
  es_install_kopf_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-kopf-'${es_kopf_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin --install kopf --url file://'$install_path'/elasticsearch-kopf-'${es_kopf_version}'.zip'
fi
if [ $es_kopf_version == 'v2.1.2' ]; then
  es_install_kopf_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-kopf-'${es_kopf_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin install file://'$install_path'/elasticsearch-kopf-'${es_kopf_version}'.zip'
fi
if [ $es_kopf_version == 'master' ]; then
  es_install_kopf_plugin_cmd='cd '$shell_path' && cp '$es_base_version'/elasticsearch-kopf-'${es_kopf_version}'.zip '$install_path'/ && cd '$es_home' && ./bin/plugin install file://'$install_path'/elasticsearch-kopf-'${es_kopf_version}'.zip'
fi

# 安装ik插件命令
if [[ $es_ik_version =~ 1.4.* ]]; then
  es_install_ik_plugin_cmd='mkdir -p '$es_home'/plugins/ik && unzip -o '$es_base_version'/elasticsearch-analysis-ik-'${es_ik_version}'.zip -d '$es_home'/plugins/ik/ && tar -zxf '$es_base_version'/'$es_ik_config_tar' -C '$es_home'/config/'
fi
if [[ $es_ik_version =~ 1.5.* ]]; then
  es_install_ik_plugin_cmd='mkdir -p '$es_home'/plugins/ik && unzip -o '$es_base_version'/elasticsearch-analysis-ik-'${es_ik_version}'.zip -d '$es_home'/plugins/ik/ && tar -zxf '$es_base_version'/'$es_ik_config_tar' -C '$es_home'/config/'
fi
if [[ $es_ik_version =~ 1.8.* ]]; then
  es_install_ik_plugin_cmd='mkdir -p '$es_home'/plugins/ik && unzip -o '$es_base_version'/elasticsearch-analysis-ik-'${es_ik_version}'.zip -d '$es_home'/plugins/ik/'
fi
if [[ $es_ik_version =~ 1.9.* ]]; then
  es_install_ik_plugin_cmd='mkdir -p '$es_home'/plugins/ik && unzip -o '$es_base_version'/elasticsearch-analysis-ik-'${es_ik_version}'.zip -d '$es_home'/plugins/ik/'
fi

# 安装ES命令
es_install_cmd="tar -zxf $es_base_version/$es_tar -C $install_path/ && cp $es_base_version/$es_config_file $es_home/config/"
es_startup_cmd="cd $es_home && ./bin/elasticsearch -d"
# --------------------------------------------------------------------------------------------------------------------------------------------
################# ES install #################
echo "安装目录是：$install_path"
echo "################# ES install start #################"

if [ -d $es_home ]; then
  echo "delete $es_home"
  rm -rf $es_home
fi

if [ ! -f $es_base_version/$es_tar ]; then
  echo "$es_tar not found - downloading $es_tar..."
  if [ $es_base_version = '1.x' ]; then
    curl -o $es_base_version/$es_tar https://download.elastic.co/elasticsearch/elasticsearch/$es_tar
  fi
  if [ $es_base_version = '2.x' ]; then
    curl -o $es_base_version/$es_tar https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/${es_version}/$es_tar
  fi
fi

if [ ! -f $es_base_version/elasticsearch-head-${es_head_version}.zip ]; then
  echo "$es_base_version/elasticsearch-head-${es_head_version}.zip not found - downloading elasticsearch-head-${es_head_version}.zip..."
  if [ $es_head_version = '1.x' ]; then
  	curl -o $es_base_version/'elasticsearch-head-'${es_head_version}'.zip' https://codeload.github.com/mobz/elasticsearch-head/zip/1.x
  fi
  if [ $es_head_version = 'master' ]; then
  	curl -o $es_base_version/'elasticsearch-head-'${es_head_version}'.zip' https://codeload.github.com/mobz/elasticsearch-head/zip/master
  fi
fi

if [ ! -f $es_base_version/elasticsearch-bigdesk-${es_bigdesk_version}.zip ]; then
  echo "$es_base_version/elasticsearch-bigdesk-${es_bigdesk_version}.zip not found - downloading elasticsearch-bigdesk-${es_bigdesk_version}.zip..."
  if [ $es_bigdesk_version = '2.5.0' ]; then
    curl -o $es_base_version/'elasticsearch-bigdesk-'${es_bigdesk_version}'.zip' https://codeload.github.com/lukas-vlcek/bigdesk/zip/master
  fi
  if [ $es_bigdesk_version = 'v2.2.a' ]; then
    curl -o $es_base_version/'elasticsearch-bigdesk-'${es_bigdesk_version}'.zip' https://codeload.github.com/hlstudio/bigdesk/zip/v2.2.a
  fi
  if [ $es_bigdesk_version = 'master' ]; then
    curl -o $es_base_version/'elasticsearch-bigdesk-'${es_bigdesk_version}'.zip' https://codeload.github.com/hlstudio/bigdesk/zip/master
  fi
fi

if [ ! -f $es_base_version/elasticsearch-kopf-${es_bigdesk_version}.zip ]; then
  echo "$es_base_version/elasticsearch-kopf-${es_kopf_version}.zip not found - downloading elasticsearch-kopf-${es_kopf_version}.zip..."
  if [ $es_kopf_version = 'v1.6.2' ]; then
    curl -o $es_base_version/'elasticsearch-kopf-'${es_kopf_version}'.zip' https://codeload.github.com/lmenezes/elasticsearch-kopf/zip/v1.6.2
  fi
  if [ $es_kopf_version = 'v2.1.2' ]; then
    curl -o $es_base_version/'elasticsearch-kopf-'${es_kopf_version}'.zip' https://codeload.github.com/lmenezes/elasticsearch-kopf/zip/v2.1.2
  fi
  if [ $es_kopf_version = 'master' ]; then
    curl -o $es_base_version/'elasticsearch-kopf-'${es_kopf_version}'.zip' https://codeload.github.com/lmenezes/elasticsearch-kopf/zip/master
  fi
fi

if [ ! -f $es_base_version/elasticsearch-analysis-ik-${es_ik_version}.zip ]; then
  echo "$es_base_version/elasticsearch-analysis-ik-${es_ik_version}.jar not found - skip install elasticsearch-analysis-ik-${es_ik_version}.jar..."
  es_skip_ik_plugin='yes'
fi
# --------------------------------------------------------------------------------------------------------------------------------------------
# 执行安装es命令
echo "running $es_install_cmd"
eval ${es_install_cmd}
if [ $es_skip_ik_plugin = 'no' ]; then
  # 安装ik插件
  echo "running ${es_install_ik_plugin_cmd}"
  eval ${es_install_ik_plugin_cmd}
fi
if [ $es_skip_head_plugin = 'no' ]; then
  # 安装head插件
  echo "running ${es_install_head_plugin_cmd}"
  eval ${es_install_head_plugin_cmd}
fi
if [ $es_skip_bigdesk_plugin = 'no' ]; then
  # 安装bigdesk插件
  echo "running ${es_install_bigdesk_plugin_cmd}"
  eval ${es_install_bigdesk_plugin_cmd}
fi
if [ $es_skip_kopf_plugin = 'no' ]; then
  # 安装kopf插件
  echo "running ${es_install_kopf_plugin_cmd}"
  eval ${es_install_kopf_plugin_cmd}
fi
sleep 5
echo "running ${es_startup_cmd}"
eval ${es_startup_cmd}
echo "################# ES install end #################"
# --------------------------------------------------------------------------------------------------------------------------------------------
sleep 30
echo "################# check elasticsearch process start #################"
ps -ef | grep elasticsearch
echo "################# check elasticsearch process end #################"