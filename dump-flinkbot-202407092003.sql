-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: flinkbot
-- ------------------------------------------------------
-- Server version	5.5.5-10.5.23-MariaDB-0+deb11u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `account_value_cycle`
--

DROP TABLE IF EXISTS `account_value_cycle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `account_value_cycle` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `period` datetime NOT NULL,
  `current_value` decimal(32,8) NOT NULL DEFAULT 0.00000000,
  `target_value` decimal(32,8) NOT NULL DEFAULT 0.00000000,
  `account_balance` decimal(32,8) NOT NULL DEFAULT 0.00000000,
  `done` tinyint(1) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_value_cycle_UN` (`bot_id`,`period`),
  CONSTRAINT `account_value_cycle_FK` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `account_value_cycle`
--

LOCK TABLES `account_value_cycle` WRITE;
/*!40000 ALTER TABLE `account_value_cycle` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_value_cycle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `api_rate_limit`
--

DROP TABLE IF EXISTS `api_rate_limit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_rate_limit` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(45) NOT NULL,
  `type` enum('proxy','hosting') NOT NULL DEFAULT 'proxy',
  `country` varchar(2) NOT NULL,
  `exchange` enum('binance') NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `request_count` int(11) unsigned NOT NULL DEFAULT 0,
  `request_last_time` timestamp NULL DEFAULT NULL,
  `request_rate_limit` int(11) unsigned NOT NULL DEFAULT 0,
  `peak_request_count` int(11) unsigned NOT NULL DEFAULT 0,
  `request_status` enum('active','exceeded') DEFAULT 'active',
  `order_count` int(11) unsigned NOT NULL DEFAULT 0,
  `order_last_time` timestamp NULL DEFAULT NULL,
  `order_rate_limit` int(11) unsigned NOT NULL DEFAULT 0,
  `peak_order_count` int(11) unsigned NOT NULL DEFAULT 0,
  `order_status` enum('active','exceeded') DEFAULT 'active',
  `status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_rate_limit`
--

LOCK TABLES `api_rate_limit` WRITE;
/*!40000 ALTER TABLE `api_rate_limit` DISABLE KEYS */;
INSERT INTO `api_rate_limit` VALUES (1,'149.100.154.134','hosting','BR','binance',0,217,'2024-07-09 22:46:32',1800,1688,'active',0,'2024-07-09 22:46:32',840,160,'active','active','2023-12-30 13:21:54','2024-07-09 22:46:32'),(2,'161.123.132.116','proxy','BR','binance',1,0,'2024-02-27 04:57:04',1000,0,'active',0,'2024-02-27 04:57:04',840,65,'active','inactive','2023-12-30 13:32:15','2024-02-27 14:22:30'),(3,'5.182.127.173','proxy','AR','binance',0,0,'2024-02-16 06:22:06',1000,0,'active',0,'2024-02-16 06:22:06',840,67,'active','inactive','2023-12-30 13:32:15','2024-02-27 14:22:30'),(4,'43.225.83.226','proxy','JP','binance',1,0,'2024-02-27 04:58:08',1000,0,'active',0,'2024-02-27 04:58:08',840,194,'active','inactive','2024-01-11 03:03:56','2024-02-27 14:22:30');
/*!40000 ALTER TABLE `api_rate_limit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER before_rate_limits_count_update
BEFORE UPDATE ON api_rate_limit
FOR EACH ROW
BEGIN
	# Count
    IF NEW.request_count >= OLD.request_rate_limit THEN
    	set NEW.request_status = 'exceeded';
	END IF;	
	IF NEW.order_count >= OLD.order_rate_limit THEN
    	set NEW.order_status = 'exceeded';
	END IF;
   
   	# Peak
	IF NEW.request_count > OLD.peak_request_count THEN
		set NEW.peak_request_count = NEW.request_count;
	END IF;
  	IF NEW.order_count > OLD.peak_order_count THEN
       set NEW.peak_order_count = NEW.order_count;
    END IF;
   
   	# Status
	IF OLD.request_status = 'exceeded' AND NEW.request_count < OLD.request_rate_limit THEN
		set NEW.request_status = 'active';
	END IF;
	IF OLD.order_status = 'exceeded' AND NEW.order_count < OLD.order_rate_limit THEN
		set NEW.order_status = 'active';
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bot_logs`
--

DROP TABLE IF EXISTS `bot_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bot_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `level` enum('INFO','WARNING','ERROR','DEBUG') NOT NULL,
  `message` longtext NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_bot_logs_bots` (`bot_id`),
  CONSTRAINT `fk_bot_logs_bots` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bot_logs`
--

LOCK TABLES `bot_logs` WRITE;
/*!40000 ALTER TABLE `bot_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `bot_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bots`
--

DROP TABLE IF EXISTS `bots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bots` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `exchange` enum('binance') NOT NULL DEFAULT 'binance',
  `api_key` varchar(255) NOT NULL,
  `api_secret` varchar(255) NOT NULL,
  `request_timeout` int(10) unsigned NOT NULL DEFAULT 5,
  `status` enum('active','inactive','suspended') NOT NULL DEFAULT 'inactive',
  `state` enum('running','stopped','error','paused') NOT NULL DEFAULT 'stopped',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `description` text DEFAULT NULL,
  `enable_debug` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `bots_FK` (`user_id`),
  CONSTRAINT `bots_FK` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bots`
--

LOCK TABLES `bots` WRITE;
/*!40000 ALTER TABLE `bots` DISABLE KEYS */;
INSERT INTO `bots` VALUES (4,1,'Beta 3','binance','-','-',10,'active','running','{\r\n    \"initialBalance\":1000,\r\n    \"operationSide\":\"both\",\r\n    \"prioritySideIndicator\":\"MovingAverageEMA\",\r\n    \"interval\":\"15m\",\r\n    \"filledInterval\":\"1h\",\r\n    \"orderCommonTimeout\":60,\r\n    \"orderTriggerTimeout\":150,\r\n    \"orderLongTriggerTimeout\":3600,\r\n    \"enableHalfPriceProtection\":true,\r\n    \"incrementTriggerPercentage\":0.25,\r\n    \"multiplierIncrementTrigger\":4,\r\n    \"averagePriceOrderCount\":6,\r\n    \"margin\":{\r\n        \"account\":25,\r\n        \"symbol\":10\r\n    },\r\n    \"position\":{\r\n        \"enableTakeIndicator\":true,\r\n        \"enableStopIndicator\":true,\r\n        \"takeIndicator\":\"MovingAverageEMA@0_0\",\r\n        \"stopIndicator\":\"Support@0_0\",\r\n        \"checkCollateralForProfitClosure\":true,\r\n        \"collateralCheckDisableThreshold\":25,\r\n        \"filledTime\":900,\r\n        \"maximumTime\":0,\r\n        \"minimumGain\":2,\r\n        \"minimumLoss\":0,\r\n        \"profit\":200,\r\n        \"loss\":0,\r\n        \"triggerActivateOnValues\":{\r\n            \"enabled\":true,\r\n            \"minPercentageGain\":100,\r\n            \"minPercentageLoss\":0,\r\n            \"valueGain\":4,\r\n            \"valueLoss\":0\r\n        },\r\n        \"triggerPreventOnGain\":{\r\n            \"enabled\":true,\r\n            \"percentage_from\":100,\r\n            \"percentage_to\":150\r\n        },\r\n        \"partialOrderProfit\":{\r\n            \"enabled\":true,\r\n            \"percentage\":20\r\n        },\r\n        \"triggerAccountOnGain\":{\r\n            \"enabled\":false,\r\n            \"percentage\":10\r\n        },\r\n        \"triggerTradeCurrentCycle\":{\r\n            \"enabled\":false,\r\n            \"percentage\":10\r\n        },\r\n        \"useBreakEvenPoint\":true\r\n    },\r\n    \"indicator\":{\r\n        \"indicators\":{\r\n            \"MovingAverageEMA\":[\r\n                {\r\n                    \"period\":7\r\n                },\r\n                {\r\n                    \"period\":25\r\n                },\r\n                {\r\n                    \"period\":99\r\n                }\r\n            ],\r\n            \"Aroon\":[\r\n                {\r\n                    \"period\":14\r\n                }\r\n            ],\r\n            \"Support\":[\r\n                {\r\n                    \r\n                }\r\n            ]\r\n        },\r\n        \"conditions\":{\r\n            \"when\":\"all\",\r\n            \"long\":{\r\n                \"MovingAverageEMA\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":\"less\",\r\n                            \"value\":\"@SYMBOL_PRICE@SUB_PERC_0.25\"\r\n                        }\r\n                    }\r\n                ],\r\n                \"Aroon\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":[\r\n                                \"less_equal\",\r\n                                \"greater_equal\"\r\n                            ],\r\n                            \"value\":[\r\n                                50,\r\n                                50\r\n                            ]\r\n                        }\r\n                    }\r\n                ],\r\n                \"Support\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":\"less\",\r\n                            \"value\":\"@SYMBOL_PRICE\"\r\n                        }\r\n                    }\r\n                ]\r\n            },\r\n            \"short\":{\r\n                \"MovingAverageEMA\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":\"greater\",\r\n                            \"value\":\"@SYMBOL_PRICE@ADD_PERC_0.25\"\r\n                        }\r\n                    }\r\n                ],\r\n                \"Aroon\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":[\r\n                                \"greater_equal\",\r\n                                \"less_equal\"\r\n                            ],\r\n                            \"value\":[\r\n                                50,\r\n                                50\r\n                            ]\r\n                        }\r\n                    }\r\n                ],\r\n                \"Support\":[\r\n                    {\r\n                        \"condition\":{\r\n                            \"operator\":\"greater\",\r\n                            \"value\":\"@SYMBOL_PRICE\"\r\n                        }\r\n                    }\r\n                ]\r\n            }\r\n        }\r\n    }\r\n}','Operational testing 4',1,'2024-01-10 19:24:52','2024-07-09 23:01:50');
/*!40000 ALTER TABLE `bots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `symbol_id` bigint(20) unsigned NOT NULL,
  `side` enum('BUY','SELL') NOT NULL,
  `position_side` enum('BOTH','LONG','SHORT') NOT NULL DEFAULT 'BOTH',
  `type` enum('LIMIT','MARKET','STOP','TAKE_PROFIT','STOP_MARKET','TAKE_PROFIT_MARKET','TRAILING_STOP_MARKET') NOT NULL,
  `quantity` decimal(16,8) NOT NULL,
  `pnl_close` decimal(16,8) DEFAULT NULL,
  `pnl_commission` decimal(16,8) DEFAULT NULL,
  `pnl_realized` decimal(16,8) DEFAULT NULL,
  `price` decimal(16,8) NOT NULL,
  `stop_price` decimal(16,8) DEFAULT NULL,
  `close_position` enum('true','false') NOT NULL DEFAULT 'false',
  `time_in_force` enum('GTC','IOC','FOK','GTD','GTE_GTC') NOT NULL DEFAULT 'GTE_GTC',
  `order_id` bigint(20) unsigned NOT NULL,
  `client_order_id` varchar(36) DEFAULT NULL,
  `status` enum('NEW','PARTIALLY_FILLED','FILLED','CANCELED','EXPIRED','EXPIRED_IN_MATCH') NOT NULL DEFAULT 'NEW',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UN_orders` (`order_id`),
  KEY `fk_orders_users` (`user_id`),
  KEY `fk_orders_symbols` (`symbol_id`),
  CONSTRAINT `fk_orders_symbols` FOREIGN KEY (`symbol_id`) REFERENCES `symbols` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `symbol_id` bigint(20) unsigned NOT NULL,
  `leverage` int(3) NOT NULL DEFAULT 1,
  `side` enum('LONG','SHORT') NOT NULL,
  `entry_price` decimal(16,8) NOT NULL DEFAULT 0.00000000,
  `break_even_price` decimal(16,8) NOT NULL DEFAULT 0.00000000,
  `size` decimal(16,8) NOT NULL,
  `pnl_roi_percent` decimal(16,8) DEFAULT NULL,
  `pnl_roi_value` decimal(16,8) DEFAULT NULL,
  `pnl_account_percent` decimal(16,8) DEFAULT NULL,
  `margin_account_percent` decimal(16,8) DEFAULT NULL,
  `margin_symbol_percent` decimal(16,8) DEFAULT NULL,
  `mark_price` decimal(16,8) DEFAULT NULL,
  `liquid_price` decimal(32,8) DEFAULT NULL,
  `margin_type` enum('ISOLATED','CROSSED') NOT NULL,
  `open_at` timestamp NULL DEFAULT NULL,
  `close_at` timestamp NULL DEFAULT NULL,
  `status` enum('open','closed','pending') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UN_positions` (`user_id`,`symbol_id`,`side`),
  KEY `fk_positions_symbols` (`symbol_id`),
  CONSTRAINT `fk_positions_symbols` FOREIGN KEY (`symbol_id`) REFERENCES `symbols` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_positions_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (1,1,168,20,'LONG',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,1.65100000,0.00000000,'CROSSED','2024-07-09 22:42:08',NULL,'closed','2024-07-09 22:42:08','2024-07-09 22:46:23'),(2,1,85,20,'LONG',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,3062.38000000,0.00000000,'CROSSED','2024-07-09 22:42:08',NULL,'closed','2024-07-09 22:42:08','2024-07-09 22:46:28'),(3,1,86,20,'LONG',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.50160000,0.00000000,'CROSSED','2024-07-09 22:42:08',NULL,'closed','2024-07-09 22:42:08','2024-07-09 22:46:30'),(4,1,88,20,'LONG',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,516.85000000,0.00000000,'CROSSED','2024-07-09 22:42:08',NULL,'closed','2024-07-09 22:42:08','2024-07-09 22:46:25'),(5,1,84,20,'LONG',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,57982.90000000,0.00000000,'CROSSED','2024-07-09 22:42:08',NULL,'closed','2024-07-09 22:42:08','2024-07-09 22:46:21'),(6,1,168,20,'SHORT',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,1.65100000,0.00000000,'CROSSED','2024-07-09 22:42:09',NULL,'closed','2024-07-09 22:42:09','2024-07-09 22:46:25'),(7,1,85,20,'SHORT',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,3062.38000000,0.00000000,'CROSSED','2024-07-09 22:42:09',NULL,'closed','2024-07-09 22:42:09','2024-07-09 22:46:29'),(8,1,86,20,'SHORT',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.50160000,0.00000000,'CROSSED','2024-07-09 22:42:09',NULL,'closed','2024-07-09 22:42:09','2024-07-09 22:46:31'),(9,1,88,20,'SHORT',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,516.85000000,0.00000000,'CROSSED','2024-07-09 22:42:09',NULL,'closed','2024-07-09 22:42:09','2024-07-09 22:46:26'),(10,1,84,20,'SHORT',0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,0.00000000,57982.90000000,0.00000000,'CROSSED','2024-07-09 22:42:10',NULL,'closed','2024-07-09 22:42:10','2024-07-09 22:46:22');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `symbols`
--

DROP TABLE IF EXISTS `symbols`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `symbols` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `bot_id` bigint(20) unsigned NOT NULL,
  `pair` varchar(25) NOT NULL,
  `side` enum('BOTH','LONG','SHORT') NOT NULL DEFAULT 'BOTH',
  `leverage` int(3) DEFAULT 1,
  `max_margin` decimal(16,8) NOT NULL DEFAULT 0.00000000,
  `status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `base_quantity` decimal(16,8) NOT NULL,
  `min_quantity` decimal(16,8) NOT NULL DEFAULT 0.00000000,
  `can_close` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `UN_symbols` (`bot_id`,`pair`),
  CONSTRAINT `fk_symbols_bots` FOREIGN KEY (`bot_id`) REFERENCES `bots` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `symbols`
--

LOCK TABLES `symbols` WRITE;
/*!40000 ALTER TABLE `symbols` DISABLE KEYS */;
INSERT INTO `symbols` VALUES (84,4,'BTCUSDT','BOTH',125,10.00000000,'active',0.00200000,0.00200000,1,'2024-01-10 19:36:39','2024-03-25 18:04:59'),(85,4,'ETHUSDT','BOTH',125,10.00000000,'active',0.00600000,0.00700000,1,'2024-01-10 19:36:39','2024-04-12 18:15:49'),(86,4,'MATICUSDT','BOTH',75,10.00000000,'active',5.00000000,10.00000000,1,'2024-01-10 19:36:39','2024-07-09 22:42:09'),(87,4,'ORDIUSDT','LONG',75,10.00000000,'inactive',0.10000000,0.10000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(88,4,'BNBUSDT','BOTH',75,10.00000000,'active',0.01000000,0.01000000,1,'2024-01-10 19:36:39','2024-03-25 18:04:58'),(89,4,'OPUSDT','BOTH',50,10.00000000,'inactive',1.70000000,1.40000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(90,4,'TRBUSDT','BOTH',50,1.00000000,'inactive',0.10000000,0.10000000,1,'2024-01-10 19:36:39','2024-01-10 19:36:39'),(91,4,'SEIUSDT','BOTH',50,10.00000000,'inactive',8.00000000,6.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:24:34'),(92,4,'FILUSDT','BOTH',75,10.00000000,'inactive',1.00000000,0.70000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(93,4,'ARBUSDT','BOTH',50,10.00000000,'inactive',2.80000000,2.60000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(94,4,'PERPUSDT','BOTH',50,10.00000000,'inactive',4.10000000,3.50000000,1,'2024-01-10 19:36:39','2024-02-27 14:24:34'),(95,4,'PEOPLEUSDT','BOTH',50,10.00000000,'inactive',145.00000000,152.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(96,4,'POWRUSDT','BOTH',50,10.00000000,'inactive',14.00000000,14.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(97,4,'XRPUSDT','BOTH',75,10.00000000,'inactive',9.70000000,9.10000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(98,4,'DOGEUSDT','BOTH',75,10.00000000,'inactive',69.00000000,55.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(99,4,'LTCUSDT','BOTH',75,10.00000000,'inactive',0.31700000,0.26600000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(100,4,'ADAUSDT','BOTH',75,10.00000000,'inactive',11.00000000,9.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(101,4,'DOTUSDT','BOTH',75,10.00000000,'inactive',0.80000000,0.70000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(102,4,'TRXUSDT','BOTH',75,10.00000000,'inactive',53.00000000,36.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(103,4,'XLMUSDT','BOTH',50,10.00000000,'inactive',45.00000000,42.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:04'),(104,4,'GMTUSDT','BOTH',50,10.00000000,'inactive',18.00000000,19.00000000,1,'2024-01-10 19:36:39','2024-02-27 14:23:37'),(168,4,'SNXUSDT','BOTH',50,10.00000000,'active',1.20000000,3.10000000,1,'2024-01-27 17:31:22','2024-07-09 22:42:09');
/*!40000 ALTER TABLE `symbols` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Francisco Jr','franciscojr.dev@gmail.com','2023-12-03 16:34:14','','','2023-12-03 01:21:12','2023-12-03 16:34:14');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'flinkbot'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `update_rate_limit` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `update_rate_limit` ON SCHEDULE EVERY 1 MINUTE STARTS '2023-12-31 06:07:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
	update
		api_rate_limit
	set
		request_count = 0,
		request_status = 'active'
	where
		DATE_FORMAT(timediff(now(), request_last_time), '%i') > 0
		or (request_status = 'exceeded' and request_count < request_rate_limit);

	update
		api_rate_limit
	set
		order_count = 0,
		order_status = 'active'
	where
		DATE_FORMAT(timediff(now(), order_last_time), '%i') > 0
		or (order_status = 'exceeded' and order_count < order_rate_limit);
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'flinkbot'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-07-09 20:03:47
