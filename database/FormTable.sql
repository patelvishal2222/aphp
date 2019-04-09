-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: account
-- ------------------------------------------------------
-- Server version	5.6.17

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
-- Table structure for table `formtable`
--

DROP TABLE IF EXISTS `formtable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formtable` (
  `FormTableId` int(11) NOT NULL AUTO_INCREMENT,
  `FormMasterId` int(11) DEFAULT NULL,
  `TableMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`FormTableId`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formtable`
--

LOCK TABLES `formtable` WRITE;
/*!40000 ALTER TABLE `formtable` DISABLE KEYS */;
INSERT INTO `formtable` VALUES (1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,4,5),(6,5,4),(7,5,5),(8,6,4),(9,7,4),(10,7,6),(11,8,4),(12,8,6),(13,9,4),(14,9,6);
/*!40000 ALTER TABLE `formtable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tablecontrolmaster`
--

DROP TABLE IF EXISTS `tablecontrolmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tablecontrolmaster` (
  `TableMasterId` int(11) NOT NULL,
  `FieldName` varchar(45) DEFAULT NULL,
  `ControlTypeName` varchar(45) DEFAULT NULL,
  `Caption` varchar(45) DEFAULT NULL,
  `TableName` varchar(45) DEFAULT NULL,
  `Query` varchar(500) DEFAULT NULL,
  `ComboQuery` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablecontrolmaster`
--

LOCK TABLES `tablecontrolmaster` WRITE;
/*!40000 ALTER TABLE `tablecontrolmaster` DISABLE KEYS */;
INSERT INTO `tablecontrolmaster` VALUES (1,'ItemMasterId','Hideen','ItemMasterId',NULL,'',''),(1,'ItemName','text','ItemName',NULL,'',''),(1,'PurRate','text','Purchase Rate',NULL,'',''),(1,'SaleRate','text','Sale Rate',NULL,'',''),(1,'VirtualQuantityType','ComboBox','Name','quantitytype','select *  from quantitytype','y.Name for (x,y) in quantitytype track by y.QuantityTypeId'),(2,'AccountMasterId','Hideen','AccountMasterId',NULL,'',''),(2,'AccountName','text','Account Name',NULL,'',''),(2,'Address','text','Address',NULL,'',''),(2,'City','text','City',NULL,'',''),(2,'Phone','text','Phone',NULL,'',''),(2,'VirtualGroupMaster','ComboBox','GroupName','groupmaster','select *  from groupmaster','y.GroupName for (x,y) in groupmaster track by y.GroupMasterId'),(3,'UnitMasterId','Hideen','UnitMasterId',NULL,'',''),(3,'Name','text','Name',NULL,'',''),(3,'FullName','text','FullName',NULL,'',''),(4,'TranId','Hideen','TranId',NULL,'',''),(4,'BillNo','text','BillNo',NULL,'',''),(4,'BillDate','date','BillDate',NULL,'',''),(4,'VirtualAccountMaster','ComboBox','AccountName','accountmaster','select *  from accountmaster','y.AccountName for (x,y) in accountmaster track by y.AccountMasterId'),(4,'VoucherTypeId','text','VoucherTypeId',NULL,'',''),(4,'Total','text','Total',NULL,'',''),(4,'Remarks','text','Remarks',NULL,'',''),(5,'TranDetailsId','Hideen','TranDetailsId',NULL,'',''),(5,'TranId','Hideen','TranId','tran','',''),(5,'Srno','text','Srno',NULL,'',''),(5,'VirtualItemMaster','ComboBox','ItemName','itemmaster','select *  from itemmaster','y.ItemName for (x,y) in itemmaster track by y.ItemMasterId'),(5,'Height','text','Height',NULL,'',''),(5,'Length','text','Length',NULL,'',''),(5,'Width','text','Width',NULL,'',''),(5,'Quantity','text','Quantity',NULL,'',''),(5,'Nos','text','Nos',NULL,'',''),(5,'TotalQuantity','text','TotalQuantity',NULL,'',''),(5,'Rate','text','Rate',NULL,'',''),(5,'Amount','text','Amount',NULL,'',''),(5,'details','text','details',NULL,'',''),(5,'IsDeleted','text','IsDeleted',NULL,'',''),(6,'TranId','Hideen','TranId',NULL,'',''),(6,'Srno','Hideen','Srno',NULL,'',''),(6,'TranfinId','Hideen','TranfinId',NULL,'',''),(6,'VirtualCrDrMaster','ComboBox','CrDrName','crdrmaster','select *  from crdrmaster','y.CrDrName for (x,y) in crdrmaster track by y.CrDrMasterId'),(6,'VirtualAccountMaster','ComboBox','AccountName','accountmaster','select *  from accountmaster','y.AccountName for (x,y) in accountmaster track by y.AccountMasterId'),(6,'Amount','text','Amount',NULL,'',''),(6,'BankDate','text','BankDate',NULL,'',''),(6,'Remark','text','Remark',NULL,'','');
/*!40000 ALTER TABLE `tablecontrolmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tablemaster`
--

DROP TABLE IF EXISTS `tablemaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tablemaster` (
  `TableMasterId` int(11) NOT NULL,
  `TableName` varchar(45) DEFAULT NULL,
  `MasterKey` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TableMasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablemaster`
--

LOCK TABLES `tablemaster` WRITE;
/*!40000 ALTER TABLE `tablemaster` DISABLE KEYS */;
INSERT INTO `tablemaster` VALUES (1,'ItemMaster','ItemMasterId'),(2,'AccountMaster','AccountMasterId'),(3,'UnitMaster','UnitMasterId'),(4,'Tran','TranId'),(5,'TranDetails','TranId'),(6,'Tranfin','TranId');
/*!40000 ALTER TABLE `tablemaster` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-09 10:19:22
