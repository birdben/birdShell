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
# 02 0 */1 * * /bin/bash /data/task/ls_shipper_logrotate.sh > /dev/null 2>&1
# 每天的00:02执行/data/task/ls_shipper_logrotate.sh脚本
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

################################################ 变量定义开始 ################################################
# 定义时间
WEEK_DT=`date -d "last-week" +%Y.%m.%d`

# 删除最近一周之前的索引
DELETE_DT=$WEEK_DT;
################################################ 变量定义结束 ################################################


################################################ 清理日志开始 ################################################
# 修改KEEP_CLEAN_FLAG=1开启定期清理
KEEP_CLEAN_FLAG=1

# 索引前缀
DELETE_INDEX_PREFIX=(
    go_logs_index_
    node_access_logs_index_
    node_proxy_logs_index_
    node_track_logs_index_
    php_logs_index_
)

# ES服务器地址
ES_HOST=localhost
ES_PORT=9200
ES_ADDRESS=${ES_HOST}:${ES_PORT}

if [ $KEEP_CLEAN_FLAG == 1 ]; then
    # 循环删除
    for ((i=0;i<${#DELETE_INDEX_PREFIX[*]};i++))
    do
        DELETE_INDEX_NAME=${DELETE_INDEX_PREFIX[$i]}${DELETE_DT}
        curl -XDELETE "http://${ES_ADDRESS}/${DELETE_INDEX_NAME}"
    done
fi
################################################ 清理日志结束 ################################################
