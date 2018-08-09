CREATE DATABASE  IF NOT EXISTS `account` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `account`;
-- MySQL dump 10.13  Distrib 5.6.18, for Win32 (x86)
--
-- Host: localhost    Database: account
-- ------------------------------------------------------
-- Server version	5.6.19-enterprise-commercial-advanced

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accountmaster`
--

DROP TABLE IF EXISTS `accountmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accountmaster` (
  `AccountMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `AccountName` varchar(50) DEFAULT NULL,
  `Address` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Phone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`AccountMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountmaster`
--

LOCK TABLES `accountmaster` WRITE;
/*!40000 ALTER TABLE `accountmaster` DISABLE KEYS */;
INSERT INTO `accountmaster` VALUES (1,'vishal','aa','mhd','22'),(2,'Nirav','bb','mhd','555'),(4,'sdasd','333','444','66'),(5,'asdasdad','5344','444','44'),(6,'adasd','32423','3234','444'),(7,'asda','asdas','34234','234'),(8,'sdasd','345345','345345','345345'),(9,'asdad','234234','2342','23423');
/*!40000 ALTER TABLE `accountmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itemmaster`
--

DROP TABLE IF EXISTS `itemmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itemmaster` (
  `ItemMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `ItemName` varchar(50) DEFAULT NULL,
  `PurRate` float DEFAULT NULL,
  `SaleRate` float DEFAULT NULL,
  PRIMARY KEY (`ItemMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemmaster`
--

LOCK TABLES `itemmaster` WRITE;
/*!40000 ALTER TABLE `itemmaster` DISABLE KEYS */;
INSERT INTO `itemmaster` VALUES (1,'Marble',21,30),(2,'tites',11,25),(3,'ssads',333,55),(4,'data',50,100);
/*!40000 ALTER TABLE `itemmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tran`
--

DROP TABLE IF EXISTS `tran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tran` (
  `TranId` int(11) NOT NULL AUTO_INCREMENT,
  `BillNo` varchar(45) DEFAULT NULL,
  `BillDate` date DEFAULT NULL,
  `AccountName` varchar(45) DEFAULT NULL,
  `Address` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `Phone` varchar(45) DEFAULT NULL,
  `VoucherTypeId` int(11) DEFAULT NULL,
  `Total` varchar(45) DEFAULT NULL,
  `Remarks` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TranId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tran`
--

LOCK TABLES `tran` WRITE;
/*!40000 ALTER TABLE `tran` DISABLE KEYS */;
INSERT INTO `tran` VALUES (9,'1','2018-05-10','vishal','111','33','444',NULL,'833',''),(10,'12','2018-01-24','vishal','111','33','444',NULL,'985',''),(11,'56','2018-05-10','pppp','asda','2342','234',NULL,'892',''),(13,'13','2018-08-22','rrr','da','asdas','2323',NULL,'900','');
/*!40000 ALTER TABLE `tran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trandetails`
--

DROP TABLE IF EXISTS `trandetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `trandetails` (
  `TranDetailsId` int(11) NOT NULL AUTO_INCREMENT,
  `TranId` int(11) DEFAULT NULL,
  `Srno` int(11) DEFAULT NULL,
  `ItemMasterId` int(11) DEFAULT NULL,
  `Height` float DEFAULT NULL,
  `Length` float DEFAULT NULL,
  `Width` float DEFAULT NULL,
  `Quntity` float DEFAULT NULL,
  `Nos` float DEFAULT NULL,
  `TotalQuntity` float DEFAULT NULL,
  `Rate` float DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `details` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TranDetailsId`),
  KEY `Trandetails_ItemMaster_idx` (`ItemMasterId`),
  KEY `Trandetails_Tran_idx` (`TranId`),
  CONSTRAINT `Trandetails_Tran` FOREIGN KEY (`TranId`) REFERENCES `tran` (`TranId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Trandetails_ItemMaster` FOREIGN KEY (`ItemMasterId`) REFERENCES `itemmaster` (`ItemMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trandetails`
--

LOCK TABLES `trandetails` WRITE;
/*!40000 ALTER TABLE `trandetails` DISABLE KEYS */;
INSERT INTO `trandetails` VALUES (4,9,1,3,10,20,NULL,30,50,60,55,333,NULL),(5,9,2,2,1,2,NULL,3,4,5,25,500,NULL),(6,10,3,1,55,55,NULL,55,55,55,30,55,NULL),(7,11,1,4,33,33,NULL,33,33,30,100,25,NULL),(8,11,2,3,65,65,NULL,32,32,32,55,200,NULL),(9,11,3,2,33,44,NULL,55,676,77,25,667,NULL),(10,13,1,4,1,2,NULL,4,5,7,100,900,NULL);
/*!40000 ALTER TABLE `trandetails` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-04  7:52:40
