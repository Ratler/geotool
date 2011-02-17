#!/bin/bash
#
# This script populate mysql from a geolite csv files
#
# "This product includes GeoLite data created by MaxMind, available from http://maxmind.com/" 
#

usage() {
  cat <<EOF

Usage: geotool_populate_db.sh [options] -b <file> -l <file> -c <file> <database>

Required options:
 -b </path/to/GeoLiteCity-Blocks.csv>     Path to GeoLiteCity-Blocks CSV file
 -l </path/to/GeoLiteCity-Location.csv>   Path to GeoLiteCity-Location CSV file
 -c </path/to/GeoIPCountryWhois.csv>      Path to GeoIPCountryWhois CSV file

Options:
 -u <mysql user>   MySQL username
 -p <mysql pass>   MySQL password
 -h                This help page
EOF
}

main() {
  MYSQL=$(which mysql)

  if [ ! -x $MYSQL ]; then
    echo "Error: Mysql not found, bailing out!"
    exit 1
  fi

  DB=$1

  # Create tables and populate it with data from csv files
  $MYSQL $MYSQLOPTS $DB <<EOF
DROP TABLE IF EXISTS \`csvcountry\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`csvcountry\` (
  \`start_ip\` char(15) NOT NULL,
  \`end_ip\` char(15) NOT NULL,
  \`start\` int(10) unsigned NOT NULL,
  \`end\` int(10) unsigned NOT NULL,
  \`cc\` char(2) NOT NULL,
  \`cn\` varchar(50) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`csvcountry\` WRITE;
/*!40000 ALTER TABLE \`csvcountry\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`csvcountry\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`city_location\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`city_location\` (
    \`id\` int(10) unsigned NOT NULL,
    \`country_id\` int(10) NOT NULL,
		\`region\` char(2) NOT NULL,
		\`city\` varchar(50),
		\`postal_code\` char(5) NOT NULL,
		\`latitude\` float,
		\`longitude\` float,
		\`metro_code\` integer,
		\`area_code\` integer,
		PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`city_location\` WRITE;
/*!40000 ALTER TABLE \`city_location\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`city_location\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`csvcity_location\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`csvcity_location\` (
    \`locId\` int(10) unsigned NOT NULL,
		\`country\` char(2) NOT NULL,
		\`region\` char(2) NOT NULL,
		\`city\` varchar(50),
		\`postalCode\` char(5) NOT NULL,
		\`latitude\` float,
		\`longitude\` float,
		\`metroCode\` integer,
		\`areaCode\` integer,
		PRIMARY KEY (locId)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`csvcity_location\` WRITE;
/*!40000 ALTER TABLE \`csvcity_location\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`csvcity_location\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`city_block\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`city_block\` (
    \`id\` bigint(20) NOT NULL AUTO_INCREMENT,
		\`start\` int(10) unsigned NOT NULL,
		\`end\` int(10) unsigned NOT NULL,
		\`city_location_id\` int(10) unsigned NOT NULL,
    \`index_geo\` INT(10) UNSIGNED NOT NULL,
		PRIMARY KEY (id),
    INDEX \`idx_start\` (\`start\`),
    INDEX \`idx_end\` (\`end\`),
    INDEX \`idx_geo\` (\`index_geo\`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`city_block\` WRITE;
/*!40000 ALTER TABLE \`city_block\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`city_block\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`csvcity_block\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`csvcity_block\` (
		\`startIpNum\` int(10) unsigned NOT NULL,
		\`endIpNum\` int(10) unsigned NOT NULL,
		\`city_location_id\` int(10) unsigned NOT NULL,
		PRIMARY KEY (endIpNum)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`csvcity_block\` WRITE;
/*!40000 ALTER TABLE \`csvcity_block\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`csvcity_block\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`country\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`country\` (
  \`id\` int(10) NOT NULL AUTO_INCREMENT,
  \`version\` int(10) NOT NULL,
  \`country_code\` varchar(2) NOT NULL,
  \`country_name\` varchar(50) NOT NULL,
  PRIMARY KEY (\`id\`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`country\` WRITE;
/*!40000 ALTER TABLE \`country\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`country\` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS \`ip\`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE \`ip\` (
  \`id\` int(10) unsigned NOT NULL AUTO_INCREMENT,
  \`polygon\` polygon NOT NULL,
  \`country_id\` int(10) NOT NULL,
  \`start\` int(10) unsigned NOT NULL,
  \`end\` int(10) unsigned NOT NULL,
  PRIMARY KEY (\`id\`),
  SPATIAL KEY \`polygon\` (\`polygon\`)
) ENGINE=MyISAM AUTO_INCREMENT=140247 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES \`ip\` WRITE;
/*!40000 ALTER TABLE \`ip\` DISABLE KEYS */;
/*!40000 ALTER TABLE \`ip\` ENABLE KEYS */;
UNLOCK TABLES;

LOAD DATA LOCAL INFILE '$CSVCOUNTRY'
		INTO TABLE $DB.csvcountry
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n';
INSERT INTO country SELECT DISTINCT NULL,NULL,cc,cn FROM csvcountry;
INSERT INTO ip SELECT NULL, GEOMFROMWKB(POLYGON(LINESTRING(POINT(t1.start, -1),POINT(t1.end, -1),POINT(t1.end, 1),POINT(t1.start, 1),POINT(t1.start, -1)))), t2.id, t1.start, t1.end FROM csvcountry t1 JOIN country t2 ON t1.cc = t2.country_code;
LOAD DATA LOCAL INFILE '$CSVBLOCK'
		INTO TABLE $DB.csvcity_block
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n'
    IGNORE 2 LINES;
LOAD DATA LOCAL INFILE '$CSVLOCATION'
		INTO TABLE $DB.csvcity_location
		FIELDS TERMINATED BY ','
		OPTIONALLY ENCLOSED BY '\"'
		LINES TERMINATED BY '\n'
    IGNORE 2 LINES;
INSERT INTO city_block SELECT NULL, t1.startIpNum, t1.endIpNum, t1.city_location_id, NULL FROM csvcity_block t1;
UPDATE city_block SET index_geo = (end - mod(end, 65536));
DROP TABLE csvcity_block;
INSERT INTO city_location SELECT t1.locId, t2.id, t1.region, t1.city, t1.postalCode, t1.latitude, t1.longitude, t1.metrocode, t1.areaCode
       FROM csvcity_location t1
       JOIN country t2 ON t1.country = t2.country_code;
DROP TABLE csvcity_location;
DROP TABLE csvcountry;
EOF
}

GETOPT_ARGS=$(getopt -n geotool_populate_db.sh -o "u:p:b:l:c:h" -- "$@")

if [ "$?" -ne 0 ]; then
  usage
  exit
else
  eval set -- $GETOPT_ARGS

  while true; do
    case "$1" in
      -u) MYSQLOPTS+=" -u $2"; shift 2;;
      -p) MYSQLOPTS+=" -p$2"; shift 2;;
      -b) export CSVBLOCK=$2; shift 2;;
      -l) export CSVLOCATION=$2; shift 2;;
      -c) export CSVCOUNTRY=$2; shift 2;;
      -h) usage; exit;;
      --) shift; break;;
      *) usage; break;;
    esac
  done

  export MYSQLOPTS

  if [ -z "$1" ]; then
    echo "Error: Missing argument <database>"
    usage
    exit 1
  fi

  if [[ -z "$CSVBLOCK" || ! -f "$CSVBLOCK" ]]; then
    echo "Error: Missing GeoLiteCity-Blocks option or file not found!"
    usage
    exit 1
  fi

  if [[ -z "$CSVLOCATION" || ! -f "$CSVLOCATION" ]]; then
    echo "Error: Missing GeoLiteCity-Location option or file not found!"
    usage
    exit 1
  fi

  if [[ -z "$CSVCOUNTRY" || ! -f "$CSVCOUNTRY" ]]; then
    echo "Error: Missing GeoIPCountryWhois option or file not found!"
    usage
    exit 1
  fi
  
  main $@
fi
