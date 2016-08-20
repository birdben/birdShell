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

# 安装软件目录/software/
# 创建软连接目录/usr/local指向/software目录
# 这样用jdk举例，安装目录始终是/software/jdk，但是java_home环境变量始终是/usr/local/java
# 因为/usr/local/java -> /software/jdk软连接指向的是实际安装的目录

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
install_components="java es"

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
	scp -r $local_base_path/* $ssh_user@$ssh_host:$remote_base_path/
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
