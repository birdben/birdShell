#!/bin/bash
# crontab -e : 执行文字编辑器来设定时程表
# crontab -r : 删除目前的时程表
# crontab -l : 列出目前的时程表
# 
# 使用crontab -e 创建一个定时任务，其会打开一个任务文件，将需要添加的任务添加到任务文件中，添加格式如下：
# 分    小时  日    月    星期  命令(取值范围,0表示周日,*表任意一天，一般一行对应一个任务)
# 0-59  0-23  1-31  1-12  0-6   command
# 0     0     *     *     *     ntpdate asia.pool.ntp.org
# 
# 添加的命令必须以如下格式：
# * * * * * /command path
# 
# 例如：
# 02 0 */1 * * /bin/bash /data/task/ls_indexer_logrotate.sh > /dev/null 2>&1
# 每天的00:02执行/data/task/ls_indexer_logrotate.sh脚本
# 
# 前5个字段分别表示：
# 分钟：0-59
# 小时：1-23
# 日期：1-31
# 月份：1-12
# 星期：0-6（0表示周日）
# 
# 一些特殊符号：
# *：表示任何时刻
# ,：表示分割
# -：表示一个段，如：1-5，就表示1到5点
# /n：表示每个n的单位执行一次，如：*/1, 就表示每隔1个小时执行一次命令。也可以写成1-23/1.

# 定义时间
TODAY_DT=`date +%F`
YESTERDAY_DT=`date -d "yesterday" +%F`

# 定义logstash go日志目录
OLD_LS_GO_LOGS="/data/logstash_logs/go_indexer/"
NEW_LS_GO_LOGS="/data/logstash_logs/logbak/go_indexer/"

# 定义logstash node日志目录
OLD_LS_NODE_LOGS="/data/logstash_logs/node_indexer/"
NEW_LS_NODE_LOGS="/data/logstash_logs/logbak/node_indexer/"

# 定义logstash php日志目录
OLD_LS_PHP_LOGS="/data/logstash_logs/php_indexer/"
NEW_LS_PHP_LOGS="/data/logstash_logs/logbak/php_indexer/"

# 原来使用echo $TODAY_DT>$OLD_LS_GO_LOGS/logstash_go.out当文件被占用的时候不能有效的清空文件内容
# 所以修改为使用cat /dev/null>$OLD_LS_GO_LOGS/logstash_go.out方式清空文件内容
# go日志的每日切割，压缩，备份
cp $OLD_LS_GO_LOGS/logstash_go.out $OLD_LS_GO_LOGS/logstash_go.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_GO_LOGS/logstash_go.out && gzip $OLD_LS_GO_LOGS/logstash_go.$YESTERDAY_DT.out
cp $OLD_LS_GO_LOGS/logstash_go.err $OLD_LS_GO_LOGS/logstash_go.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_GO_LOGS/logstash_go.err && gzip $OLD_LS_GO_LOGS/logstash_go.$YESTERDAY_DT.err
cp $OLD_LS_GO_LOGS/logstash_go_beginning.out $OLD_LS_GO_LOGS/logstash_go_beginning.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_GO_LOGS/logstash_go_beginning.out && gzip $OLD_LS_GO_LOGS/logstash_go_beginning.$YESTERDAY_DT.out
cp $OLD_LS_GO_LOGS/logstash_go_beginning.err $OLD_LS_GO_LOGS/logstash_go_beginning.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_GO_LOGS/logstash_go_beginning.err && gzip $OLD_LS_GO_LOGS/logstash_go_beginning.$YESTERDAY_DT.err
# node日志的每日切割，压缩，备份
cp $OLD_LS_NODE_LOGS/logstash_node.out $OLD_LS_NODE_LOGS/logstash_node.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_NODE_LOGS/logstash_node.out && gzip $OLD_LS_NODE_LOGS/logstash_node.$YESTERDAY_DT.out
cp $OLD_LS_NODE_LOGS/logstash_node.err $OLD_LS_NODE_LOGS/logstash_node.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_NODE_LOGS/logstash_node.err && gzip $OLD_LS_NODE_LOGS/logstash_node.$YESTERDAY_DT.err
cp $OLD_LS_NODE_LOGS/logstash_node_beginning.out $OLD_LS_NODE_LOGS/logstash_node_beginning.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_NODE_LOGS/logstash_node_beginning.out && gzip $OLD_LS_NODE_LOGS/logstash_node_beginning.$YESTERDAY_DT.out
cp $OLD_LS_NODE_LOGS/logstash_node_beginning.err $OLD_LS_NODE_LOGS/logstash_node_beginning.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_NODE_LOGS/logstash_node_beginning.err && gzip $OLD_LS_NODE_LOGS/logstash_node_beginning.$YESTERDAY_DT.err
# php日志的每日切割，压缩，备份
cp $OLD_LS_PHP_LOGS/logstash_php.out $OLD_LS_PHP_LOGS/logstash_php.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_PHP_LOGS/logstash_php.out && gzip $OLD_LS_PHP_LOGS/logstash_php.$YESTERDAY_DT.out
cp $OLD_LS_PHP_LOGS/logstash_php.err $OLD_LS_PHP_LOGS/logstash_php.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_PHP_LOGS/logstash_php.err && gzip $OLD_LS_PHP_LOGS/logstash_php.$YESTERDAY_DT.err
cp $OLD_LS_PHP_LOGS/logstash_php_beginning.out $OLD_LS_PHP_LOGS/logstash_php_beginning.$YESTERDAY_DT.out && cat /dev/null>$OLD_LS_PHP_LOGS/logstash_php_beginning.out && gzip $OLD_LS_PHP_LOGS/logstash_php_beginning.$YESTERDAY_DT.out
cp $OLD_LS_PHP_LOGS/logstash_php_beginning.err $OLD_LS_PHP_LOGS/logstash_php_beginning.$YESTERDAY_DT.err && cat /dev/null>$OLD_LS_PHP_LOGS/logstash_php_beginning.err && gzip $OLD_LS_PHP_LOGS/logstash_php_beginning.$YESTERDAY_DT.err

# find -time用法
# mtime(modify time) : 最后一次修改文件或目录的时间
# ctime(change time) : 最后一次改变文件或目录(改变的是原数据即:属性)的时间
# 如:记录该文件的inode节点被修改的时间。touch命令除了-d和-t选项外都会改变该时间。而且chmod,chown等命令也能改变该值。
# atime(access time) : 最后一次访问文件或目录的时间

# ls -l file : 查看文件修改时间
# ls -lc file : 查看文件状态改动时间
# ls -lu file : 查看文件访问时间

# -mtime ＋1 : 表示文件修改时间为大于1天的文件，即距离当前时间2天（48小时）之外的文件
# -mtime 1 : 表示文件修改时间距离当前为1天的文件，即距离当前时间1天（24小时－48小时）的文件
# -mtime 0 : 表示文件修改时间距离当前为0天的文件，即距离当前时间不到1天（24小时）以内的文件
# -mtime -1 : 表示文件修改时间为小于1天的文件，即距离当前时间1天（24小时）之内的文件

# 可以按照多种条件find
# find $OLD_LS_GO_LOGS -maxdepth 1 -type f -name "*" ! -name "*.gz"  ! -name "*.zip" ! -name "*.pid" ! -type l -mtime +1 | xargs gzip

# 将前三日go日志备份到备份目录
for gzFile in `find $OLD_LS_GO_LOGS -mtime +1 | grep "\.gz"` do
	mv $gzFile $NEW_LS_GO_LOGS/
done
# 将前三日node日志备份到备份目录
for gzFile in `find $OLD_LS_NODE_LOGS -mtime +1 | grep "\.gz"` do
	mv $gzFile $NEW_LS_NODE_LOGS/
done
# 将前三日php日志备份到备份目录
for gzFile in `find $OLD_LS_PHP_LOGS -mtime +1 | grep "\.gz"` do
	mv $gzFile $NEW_LS_PHP_LOGS/
done

# 修改KEEP_CLEAN_FLAG=1开启定期清理
KEEP_CLEAN_FLAG=0
KEEP_DAYS=3

if [ $KEEP_CLEAN_FLAG == 1 ]; then
  if [ -d "${NEW_LS_GO_LOGS}" ]; then
  	find "${NEW_LS_GO_LOGS}" -type f -name "logstash_go*.gz" -mtime +${KEEP_DAYS} -exec ls -l {} \;
    find "${NEW_LS_GO_LOGS}" -type f -name "logstash_go*.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
  fi
fi

if [ $KEEP_CLEAN_FLAG == 1 ]; then
  if [ -d "${NEW_LS_NODE_LOGS}" ]; then
  	find "${NEW_LS_NODE_LOGS}" -type f -name "logstash_node*.gz" -mtime +${KEEP_DAYS} -exec ls -l {} \;
    find "${NEW_LS_NODE_LOGS}" -type f -name "logstash_node*.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
  fi
fi

if [ $KEEP_CLEAN_FLAG == 1 ]; then
  if [ -d "${NEW_LS_PHP_LOGS}" ]; then
  	find "${NEW_LS_PHP_LOGS}" -type f -name "logstash_php*.gz" -mtime +${KEEP_DAYS} -exec ls -l {} \;
    find "${NEW_LS_PHP_LOGS}" -type f -name "logstash_php*.gz" -mtime +${KEEP_DAYS} -exec rm -f {} \;
  fi
fi
