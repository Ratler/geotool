DROP TABLE IF EXISTS `csvcountry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csvcountry` (
  `start_ip` char(15) NOT NULL,
  `end_ip` char(15) NOT NULL,
  `start` int(10) unsigned NOT NULL,
  `end` int(10) unsigned NOT NULL,
  `cc` char(2) NOT NULL,
  `cn` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `csvcountry` WRITE;
/*!40000 ALTER TABLE `csvcountry` DISABLE KEYS */;
/*!40000 ALTER TABLE `csvcountry` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `city_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city_location` (
    `id` int(10) unsigned NOT NULL,
    `country_id` bigint(20) NOT NULL,
		`region` char(2) NOT NULL,
		`city` varchar(50),
		`postal_code` char(5) NOT NULL,
		`latitude` float,
		`longitude` float,
		`metro_code` integer,
		`area_code` integer,
		PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `city_location` WRITE;
/*!40000 ALTER TABLE `city_location` DISABLE KEYS */;
/*!40000 ALTER TABLE `city_location` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `csvcity_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csvcity_location` (
    `locId` int(10) unsigned NOT NULL,
		`country` char(2) NOT NULL,
		`region` char(2) NOT NULL,
		`city` varchar(50),
		`postalCode` char(5) NOT NULL,
		`latitude` float,
		`longitude` float,
		`metroCode` integer,
		`areaCode` integer,
		PRIMARY KEY (locId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `csvcity_location` WRITE;
/*!40000 ALTER TABLE `csvcity_location` DISABLE KEYS */;
/*!40000 ALTER TABLE `csvcity_location` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `city_block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `city_block` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
		`start` int(10) unsigned NOT NULL,
		`end` int(10) unsigned NOT NULL,
		`city_location_id` int(10) unsigned NOT NULL,
    `index_geo` INT(10) UNSIGNED NOT NULL,
		PRIMARY KEY (id),
    INDEX `idx_start` (`start`),
    INDEX `idx_end` (`end`),
    INDEX `idx_geo` (`index_geo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `city_block` WRITE;
/*!40000 ALTER TABLE `city_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `city_block` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `csvcity_block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csvcity_block` (
		`startIpNum` int(10) unsigned NOT NULL,
		`endIpNum` int(10) unsigned NOT NULL,
		`city_location_id` int(10) unsigned NOT NULL,
		PRIMARY KEY (endIpNum)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `csvcity_block` WRITE;
/*!40000 ALTER TABLE `csvcity_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `csvcity_block` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `country_code` varchar(2) NOT NULL,
  `country_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ip` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `country_id` bigint(20) NOT NULL,
  `end` int(10) unsigned NOT NULL,
  `start` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKD27A56A5EC7` (`country_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ip` WRITE;
/*!40000 ALTER TABLE `ip` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip` ENABLE KEYS */;
UNLOCK TABLES;

