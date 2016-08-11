software_path='/software'

################# Logstash install #################
logstash_version='1.5.6'
logstash_tar='logstash-$version.tar.gz'
logstash_home='$software_path/logstash-$version'
logstash_config='$software_path/logstash-java.conf'
logstash_config_name='logstash-java.conf'

if [ ! -f $logstash_tar ]; then
  echo "logstash tar not found - downloading $logstash_tar..."
  curl -o $logstash_tar https://download.elastic.co/logstash/logstash/$logstash_tar
fi

logstash_install_cmd="tar -zxvf $logstash_tar -C $software_path && cp $logstash_config $logstash_home/conf && cd $logstash_home && nohup ./bin/logstash -f $logstash_config_name &"
echo "running $logstash_install_cmd"
$logstash_install_cmd


################# ES install #################
es_version='1.7.3'
es_tar='elasticsearch-$version.tar.gz'
es_home='$software_path/elasticsearch-$version'
es_config='$software_path/elasticsearch.yml'
es_config_name='elasticsearch.yml'

if [ ! -f $es_tar ]; then
  echo "elasticsearch tar not found - downloading $es_tar..."
  curl -o $es_tar https://download.elastic.co/elasticsearch/elasticsearch/$es_tar
fi

es_install_cmd="tar -zxvf $es_tar -C $software_path && cp $es_config $es_home/conf && cd $es_home && ./bin/elasticsearch -d"
echo "running $es_install_cmd"
$es_install_cmd


################# Kibana install #################
kibana_version='4.1.8'
kibana_tar='kibana-$version-linux-x64.tar.gz'
kibana_home='$software_path/kibana-$version-linux-x64'
kibana_config='$software_path/kibana.yml'
kibana_config_name='kibana.yml'

if [ ! -f $kibana_tar ]; then
  echo "elasticsearch tar not found - downloading $kibana_tar..."
  curl -o $kibana_tar https://download.elastic.co/kibana/kibana/$kibana_tar
fi

kibana_install_cmd="tar -zxvf $kibana_tar -C $software_path && cp $kibana_config $kibana_home/config && cd $kibana_home && nohup ./bin/kibana &"
echo "running $kibana_install_cmd"
$kibana_install_cmd
