#!bin/bash

# ----------------------------------------------------------------------
# name:         jenkins_scp.sh
# version:      1.1
# createTime:   2016-08-11
# description:  elk环境安装，可以指定分发的host，并且可选择安装部分组件，各个组件支持不同版本的安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

<<COMMENT
--------------------------------------------------------------------------------------------------------------------------------------------
==== java环境变量配置 ====
安装软件目录/software/，创建软连接目录/usr/local指向/software目录
这样用jdk举例，安装目录始终是/software/jdk，但是java_home环境变量始终是/usr/local/java
因为/usr/local/java -> /software/jdk软连接指向的是实际安装的目录
--------------------------------------------------------------------------------------------------------------------------------------------
==== 其他工具的安装（这里需要根据不同的系统自己修改） ====
1.安装unzip解压工具
  sudo apt-get install unzip
2.安装make工具
  sudo apt-get update
  sudo apt-get install build-essential
--------------------------------------------------------------------------------------------------------------------------------------------
==== 修改各个组件的shell脚本中的版本信息 ====
1.需要修改xxx_base_version主版本号
2.需要修改xxx_version小版本号
3.需要修改对应插件的版本信息（注意：这里可能每个ES版本对应的插件版本都不一样，需要看具体插件的github上对应版本来决定安装哪个版本）
--------------------------------------------------------------------------------------------------------------------------------------------
==== 配置文件的修改 ====
1.修改elasticsearch.yml
  network.host : 指定可以访问ES的IP地址（1.x版本不需要修改）
  discovery.zen.ping.unicast.hosts : 单播的ES集群地址（只有集群搭建的时候需要）
2.修改logstash-shipper.conf
  input-file : log日志文件路径
  output-redis : redis的IP地址，port端口号，pass密码
3.修改logstash-indexer.conf
  intput-redis : redis的IP地址，port端口号，pass密码
  filter-grok : grok表达式
  output-elasticsearch : es的IP地址
4.kibana.yml配置文件
  host : 可访问Kibana的IP地址
  elasticsearch_url : 绑定ES的IP地址
--------------------------------------------------------------------------------------------------------------------------------------------
==== 修改我们command.log日志相关配置 ====
1.需要将下面的代码配置到/etc/bashrc 或者 /etc/bash.bashrc，根据自己的系统环境配置
2.注意配置下面代码片段中的日志输出路径，我这里配置的是：/software/command.log
```
# HISTDIR是Command命令保存的log文件路径，这里需要注意当前操作用户一定要对该log文件路径有读写权限
HISTDIR='/software/command.log'
if [ ! -f $HISTDIR ];
    then touch $HISTDIR sudo chmod 666 $HISTDIR
fi

# 定义Command日志的格式
export HISTTIMEFORMAT="{\"TIME\":\"%F %T\",\"HOSTNAME\":\"$HOSTNAME\",\"LI\":\"$(who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g')\",\"LU\":\"$(who am i|awk '{print $1}')\",\"NU\":\"${USER}\",\"CMD\":\""

# 输出日志到指定的log文件
export PROMPT_COMMAND='history 1|tail -1|sed "s/^[ ]\+[0-9]\+ //"|sed "s/$/\"}/">> /software/command.log'
```
--------------------------------------------------------------------------------------------------------------------------------------------
COMMENT

# 脚本和tar包在本地主机的存放路径
local_base_path="/Users/ben/workspace_git/birdShell/elk/install"
# elk环境安装的远程主机的根路径
remote_install_path="/software"
# 脚本和tar包使用scp发送到远程主机的存放路径
remote_base_path="/test"
# ssh登录信息
ssh_user="ubuntu"
ssh_hosts="54.222.234.162"
# 安装的组件
install_components="java es logstash_indexer logstash_shipper kibana redis"

ssh_host_arr=($ssh_hosts)
install_component_arr=($install_components)
for ssh_host in ${ssh_host_arr[@]}
do
    echo "正在登陆主机$ssh_host"
	ssh -t -t $ssh_user@$ssh_host <<EOF
    if [ ! -d $remote_install_path ]; then
    	echo "创建$remote_install_path"
    	sudo mkdir $remote_install_path
    	sudo chown -R $ssh_user:$ssh_user $remote_install_path
    fi
    if [ ! -d $remote_base_path ]; then
    	echo "创建$remote_base_path"
    	sudo mkdir $remote_base_path
    	sudo chown -R $ssh_user:$ssh_user $remote_base_path
    fi
	exit
EOF
	# 不需要每次都上传全部的文件，根据修改来上传
	#scp -r $local_base_path/* $ssh_user@$ssh_host:$remote_base_path/
	for install_component in ${install_component_arr[@]}
	do
		ssh -t -t $ssh_user@$ssh_host <<EOF
		echo "正在安装${install_component}............."
		cd $remote_base_path/$install_component
		sh $install_component.sh $remote_install_path
		exit
EOF
	done
done
