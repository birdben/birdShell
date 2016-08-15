#!bin/bash

# ----------------------------------------------------------------------
# name:         java.sh
# version:      1.0
# createTime:   2016-08-11
# description:  java环境安装
# author:       birdben
# email:        191654006@163.com
# github:       https://github.com/birdben
# ----------------------------------------------------------------------

software_path=$1

################# Java install #################
echo "安装目录是：$software_path"
echo "################# Java install start #################"
java_download_version='8u91'
java_version='1.8.0_91'
java_tar='jdk-'${java_download_version}'-linux-x64.tar.gz'
java_home=$software_path'/jdk'${java_version}
java_path='/usr/local/java'

if [ -d $java_home ]; then
  echo "delete $java_home"
  rm -rf $java_home
else
  echo "$java_home not exists"
fi

if [ -L $java_path ]; then
  echo "delete $java_path"
  sudo rm -rf $java_path
else
  echo "$java_path not exists"
fi

if [ ! -f $java_tar ]; then
  echo "java tar not found - downloading $java_tar..."
  curl -o $java_tar http://download.oracle.com/otn-pub/java/jdk/8u101-b13/$java_tar?AuthParam=1470766477_2d256f714a88fc7517613711f219228d
else
  echo "$java_tar exists"
fi

java_install_cmd="tar -zxf $java_tar -C $software_path/ && sudo ln -s $java_home $java_path"
echo "running $java_install_cmd"
# 执行安装java命令
eval ${java_install_cmd}
echo "################# Java install end #################"

sleep 30
echo "################# check java version start #################"
java -version
echo "################# check java version end #################"