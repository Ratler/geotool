#!/bin/bash
#
# This script populate mysql from a geolite csv files
#

TMPSQL=$(mktemp /tmp/geolitecountry.$$.XXXXXX)

mysql geotool_development < geoip_table.sql

# Populate table data from CSV
cat <<EOF>>$TMPSQL
LOAD DATA LOCAL INFILE '/tmp/csv.csv'
		INTO TABLE geotool_development.csvcountry
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n';
DELETE FROM country;
INSERT INTO country SELECT DISTINCT NULL,NULL,cc,cn FROM csvcountry;
DELETE FROM ip;
INSERT INTO ip select NULL, NULL, t2.id, t1.end, t1.start from csvcountry t1 join country t2 on t1.cc = t2.country_code;
DROP TABLE csvcountry;
LOAD DATA LOCAL INFILE '/tmp/GeoLiteCity-Blocks.csv'
		INTO TABLE geotool_development.csvcity_block
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE '/tmp/GeoLiteCity-Location.csv'
		INTO TABLE geotool_development.csvcity_location
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n';
INSERT INTO city_block SELECT NULL, t1.startIpNum, t1.endIpNum, t1.city_location_id, NULL FROM csvcity_block t1;
UPDATE city_block SET index_geo = (end - mod(end, 65536));
DROP TABLE csvcity_block;
INSERT INTO city_location SELECT t1.locId, t2.id, t1.region, t1.city, t1.postalCode, t1.latitude, t1.longitude, t1.metrocode, t1.areaCode
       FROM csvcity_location t1
       JOIN country t2 ON t1.country = t2.country_code;
DROP TABLE csvcity_location;
EOF

mysql geotool_development < $TMPSQL
rm -f $TMPSQL
