#!bin/bash

# ----------------------------------------------------------------------
# name:         jenkins_scp.sh
# version:      1.0
# createTime:   2016-08-11
# description:  elk环境安装，可以指定分发的host，并且可选择安装部分组件
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

# 安装软件目录/software/
# 创建软连接目录/usr/local指向/software目录
# 这样用jdk举例，安装目录始终是/software/jdk，但是java_home环境变量始终是/usr/local/java
# 因为/usr/local/java -> /software/jdk软连接指向的是实际安装的目录

local_tar_path="/Users/ben/workspace_git/birdShell/elk/install"
online_soft_path="/software"
online_tar_path="/test"
ssh_user="ubuntu"
ssh_hosts="54.223.46.179"
install_components="java es logstash_indexer kibana"

ssh_host_arr=($ssh_hosts)
install_component_arr=($install_components)
for ssh_host in ${ssh_host_arr[@]}
do
    echo "正在登陆主机$ssh_host"
	ssh -t -t $ssh_user@$ssh_host <<EOF
    if [ ! -d $online_soft_path ]; then
    	echo "创建$online_soft_path"
    	sudo mkdir $online_soft_path
    	sudo chown -R $ssh_user:$ssh_user $online_soft_path
    fi
    if [ ! -d $online_tar_path ]; then
    	echo "创建$online_tar_path"
    	sudo mkdir $online_tar_path
    	sudo chown -R $ssh_user:$ssh_user $online_tar_path
    fi
	exit
EOF
	scp -r $local_tar_path/* $ssh_user@$ssh_host:$online_tar_path/
	for install_component in ${install_component_arr[@]}
	do
		ssh -t -t $ssh_user@$ssh_host <<EOF
		echo "正在安装${install_component}............."
		cd $online_tar_path/$install_component
		sh $install_component.sh $online_soft_path
		exit
EOF
	done
done
