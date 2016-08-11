software_path='/software'
install_home='/test'


################# Java install #################
echo "################# Java install start #################"
java_download_version='8u91'
java_version='1.8.0_91'
java_tar='jdk-'${java_download_version}'-linux-x64.tar.gz'
java_home=$software_path'/jdk'${java_version}
java_path='/usr/local/java'

cd $install_home
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
eval ${java_install_cmd}
java -version
echo "################# Java install end #################"


################# Redis install #################
echo "################# Redis install start #################"
redis_version='3.2.3'
redis_tar='redis-'${redis_version}'.tar.gz'
redis_home=$software_path'/redis-'${redis_version}
redis_config=$software_path'/redis.conf'
redis_config_name='redis.conf'

cd $install_home
if [ -d $redis_home ]; then
  echo "delete $redis_home"
  rm -rf $redis_home
fi

if [ ! -f $redis_tar ]; then
  echo "redis tar not found - downloading $redis_tar..."
  curl -o $redis_tar http://download.redis.io/releases/$redis_tar
fi

redis_install_cmd="tar -zxf $redis_tar -C $software_path/ && cp $redis_config_name $redis_home/ && cd $redis_home && make && ./src/redis-server redis.conf"
echo "running $redis_install_cmd"
eval ${redis_install_cmd}
echo "################# Redis install end #################"


################# Logstash install #################
echo "################# Logstash install start #################"
logstash_version='1.5.6'
logstash_tar='logstash-'${logstash_version}'.tar.gz'
logstash_home=$software_path'/logstash-'${logstash_version}
logstash_config=$software_path'/logstash-java.conf'
logstash_config_name='logstash-java.conf'

cd $install_home
if [ -d $logstash_home ]; then
  echo "delete $logstash_home"
  rm -rf $logstash_home
fi

if [ ! -f $logstash_tar ]; then
  echo "logstash tar not found - downloading $logstash_tar..."
  curl -o $logstash_tar https://download.elastic.co/logstash/logstash/$logstash_tar
fi

logstash_install_cmd="tar -zxf $logstash_tar -C $software_path/ && mkdir -p $logstash_home/conf/ && cp $logstash_config_name $logstash_home/conf/ && cd $logstash_home && nohup ./bin/logstash -f conf/$logstash_config_name &"
echo "running $logstash_install_cmd"
eval ${logstash_install_cmd}
echo "################# Logstash install end #################"


################# ES install #################
echo "################# ES install start #################"
es_version='1.7.3'
es_tar='elasticsearch-'${es_version}'.tar.gz'
es_home=$software_path'/elasticsearch-'${es_version}
es_config=$software_path'/elasticsearch.yml'
es_config_name='elasticsearch.yml'
es_httpclient_name='httpclient-4.5.jar'
es_httpcore_name='httpcore-4.4.1.jar'
es_ik_name='elasticsearch-analysis-ik-1.4.1.jar'
es_ik_config_tar='ik.tar.gz'

cd $install_home
if [ -d $es_home ]; then
  echo "delete $es_home"
  rm -rf $es_home
fi

if [ ! -f $es_tar ]; then
  echo "elasticsearch tar not found - downloading $es_tar..."
  curl -o $es_tar https://download.elastic.co/elasticsearch/elasticsearch/$es_tar
fi

es_install_cmd="tar -zxf $es_tar -C $software_path/ && tar -zxf $es_ik_config_tar -C $es_home/config/ && cp $es_ik_name $es_httpclient_name $es_httpcore_name $es_home/lib/ && cp $es_config_name $es_home/config/ && cd $es_home && ./bin/plugin --install mobz/elasticsearch-head && ./bin/elasticsearch -d"
echo "running $es_install_cmd"
eval ${es_install_cmd}
echo "################# ES install end #################"


################# Kibana install #################
echo "################# Kibana install start #################"
kibana_version='4.1.8'
kibana_tar='kibana-'${kibana_version}'-linux-x64.tar.gz'
kibana_home=$software_path'/kibana-'${kibana_version}'-linux-x64'
kibana_config=$software_path'/kibana.yml'
kibana_config_name='kibana.yml'

cd $install_home
if [ ! -f $kibana_tar ]; then
  echo "elasticsearch tar not found - downloading $kibana_tar..."
  curl -o $kibana_tar https://download.elastic.co/kibana/kibana/$kibana_tar
fi

kibana_install_cmd="tar -zxf $kibana_tar -C $software_path/ && cp $kibana_config_name $kibana_home/config/ && cd $kibana_home && nohup ./bin/kibana &"
echo "running $kibana_install_cmd"
eval ${kibana_install_cmd}
echo "################# Kibana install end #################"


################# check process #################
sleep 30
echo "################# check logstash process start #################"
ps -aux | grep logstash
echo "################# check logstash process end #################"
echo "################# check elasticsearch process start #################"
ps -aux | grep elasticsearch
echo "################# check elasticsearch process end #################"
echo "################# check kibana process start #################"
ps -aux | grep kibana
echo "################# check kibana process end #################"

