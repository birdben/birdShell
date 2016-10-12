CREATE EXTERNAL TABLE IF NOT EXISTS command_json_table(time STRING, hostname STRING, li STRING, lu STRING, nu STRING, cmd STRING)
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events';