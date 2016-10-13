CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_click_ad(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.click_ad';

CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_open_hb(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.open_hb';

CREATE EXTERNAL TABLE IF NOT EXISTS birdben_ad_view_ad(logs array<struct<name:string, rpid:string, bid:string, uid:string, did:string, duid:string, hbuid:string, ua:string, device_id:string, ip:string, server_timestamp:BIGINT>>, level STRING, message STRING, client_timestamp BIGINT)
partitioned by (dt string)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
STORED AS TEXTFILE
LOCATION '/flume/events/birdben.ad.view_ad';

alter table birdben_ad_click_ad add partition(dt='201610') location '/flume/events/birdben_ad_click_ad/201610';
alter table birdben_ad_click_ad add partition(dt='201611') location '/flume/events/birdben_ad_click_ad/201611';

alter table birdben_ad_open_hb add partition(dt='201610') location '/flume/events/birdben.ad.open_hb/201610';
alter table birdben_ad_open_hb add partition(dt='201611') location '/flume/events/birdben.ad.open_hb/201611';

alter table birdben_ad_view_ad add partition(dt='201610') location '/flume/events/birdben.ad.view_ad/201610';
alter table birdben_ad_view_ad add partition(dt='201611') location '/flume/events/birdben.ad.view_ad/201611';
