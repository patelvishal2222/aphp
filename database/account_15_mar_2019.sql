CREATE DATABASE  IF NOT EXISTS `account` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `account`;
-- MySQL dump 10.13  Distrib 5.6.18, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: account
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
-- Table structure for table `_report`
--

DROP TABLE IF EXISTS `_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `_report` (
  `ReportId` int(11) NOT NULL AUTO_INCREMENT,
  `ReportName` varchar(45) DEFAULT NULL,
  `ProcedureName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ReportId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_report`
--

LOCK TABLES `_report` WRITE;
/*!40000 ALTER TABLE `_report` DISABLE KEYS */;
INSERT INTO `_report` VALUES (1,'DayBook','PreDayBook'),(2,'TrialBalance','PreTrialBalance'),(3,'Trading Account','PreTradingAccount'),(4,'Proft & Loss Account','PreProfitAndLoss'),(5,'Balance Sheet','PreBalanceSheet'),(6,'Cash Flow','PreCashFlow'),(7,'Fund Flow','PreFundFlow'),(8,'GST Report','PreGST');
/*!40000 ALTER TABLE `_report` ENABLE KEYS */;
UNLOCK TABLES;

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
  `StateMasterId` int(11) DEFAULT NULL,
  `GroupMasterId` int(11) DEFAULT NULL,
  `AddressMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`AccountMasterId`),
  KEY `AccountMaster_StateMaster_StateMasterId_idx` (`StateMasterId`),
  KEY `AccountMaster_GroupMaster_GroupMasterId_idx` (`GroupMasterId`),
  CONSTRAINT `AccountMaster_GroupMaster_GroupMasterId` FOREIGN KEY (`GroupMasterId`) REFERENCES `groupmaster` (`GroupMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `AccountMaster_StateMaster_StateMasterId` FOREIGN KEY (`StateMasterId`) REFERENCES `statemaster` (`StateMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accountmaster`
--

LOCK TABLES `accountmaster` WRITE;
/*!40000 ALTER TABLE `accountmaster` DISABLE KEYS */;
INSERT INTO `accountmaster` VALUES (6,'vishal patel','aa','ss','ssss',NULL,NULL,NULL),(7,'ravi','aaa','555','55',NULL,NULL,NULL),(9,'amit','asda','123','555',NULL,NULL,NULL),(10,'poonam','charsheri','dholka','9913530151',1,1,NULL),(11,'Janavi','112','dholka','8888',1,1,NULL),(12,'CASH A/c','','','',NULL,NULL,NULL),(13,'Sales Account','222','111','11',1,NULL,NULL),(14,'Purchase Account','','','',NULL,NULL,NULL),(15,'Capital A/c','','','',NULL,NULL,NULL),(16,'aaaa','aaa','aa1','111',NULL,NULL,NULL),(17,'aa','222','33','333',NULL,NULL,NULL),(18,'bbb','bb','bb','444',NULL,NULL,NULL),(19,'ddd','dd','33','333',NULL,NULL,NULL);
/*!40000 ALTER TABLE `accountmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accouttype`
--

DROP TABLE IF EXISTS `accouttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accouttype` (
  `accouttypeid` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`accouttypeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accouttype`
--

LOCK TABLES `accouttype` WRITE;
/*!40000 ALTER TABLE `accouttype` DISABLE KEYS */;
INSERT INTO `accouttype` VALUES (-1,'System'),(1,'Manual'),(2,'Creditors'),(3,'Debtors'),(4,'User'),(5,'Doctor'),(6,'Patient'),(7,'Employee'),(8,'Bank');
/*!40000 ALTER TABLE `accouttype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addressmaster`
--

DROP TABLE IF EXISTS `addressmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addressmaster` (
  `addressmasterId` int(11) NOT NULL,
  `MRDL` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Address` varchar(45) DEFAULT NULL,
  `LandMark` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `StateMasterId` int(11) DEFAULT NULL,
  `Lantidue` varchar(45) DEFAULT NULL,
  `Latitude` varchar(45) DEFAULT NULL,
  `Image` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`addressmasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addressmaster`
--

LOCK TABLES `addressmaster` WRITE;
/*!40000 ALTER TABLE `addressmaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `addressmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annualmaster`
--

DROP TABLE IF EXISTS `annualmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annualmaster` (
  `AnnualMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `AnnualName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AnnualMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annualmaster`
--

LOCK TABLES `annualmaster` WRITE;
/*!40000 ALTER TABLE `annualmaster` DISABLE KEYS */;
INSERT INTO `annualmaster` VALUES (1,'Trading Account'),(2,'Profit & Loss Account'),(3,'Balance Sheet');
/*!40000 ALTER TABLE `annualmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companymaster`
--

DROP TABLE IF EXISTS `companymaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companymaster` (
  `CompanyMasterId` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `website` varchar(45) DEFAULT NULL,
  `AddressmasterId` int(11) DEFAULT NULL,
  `GsttypeId` int(11) DEFAULT NULL,
  `StocktypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`CompanyMasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companymaster`
--

LOCK TABLES `companymaster` WRITE;
/*!40000 ALTER TABLE `companymaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `companymaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controlmaster`
--

DROP TABLE IF EXISTS `controlmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `controlmaster` (
  `ControlMasterId` int(11) NOT NULL,
  `ControlName` varchar(45) DEFAULT NULL,
  `ControlTypeId` varchar(45) DEFAULT NULL,
  `TableId` int(11) DEFAULT NULL,
  `Formula` varchar(45) DEFAULT NULL,
  `Width` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ControlMasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controlmaster`
--

LOCK TABLES `controlmaster` WRITE;
/*!40000 ALTER TABLE `controlmaster` DISABLE KEYS */;
INSERT INTO `controlmaster` VALUES (1,'BillNo','1',1,NULL,NULL),(2,'BillDate','8',1,NULL,NULL);
/*!40000 ALTER TABLE `controlmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controltype`
--

DROP TABLE IF EXISTS `controltype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `controltype` (
  `ControlType` int(11) NOT NULL AUTO_INCREMENT,
  `ControlTypeName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ControlType`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controltype`
--

LOCK TABLES `controltype` WRITE;
/*!40000 ALTER TABLE `controltype` DISABLE KEYS */;
INSERT INTO `controltype` VALUES (1,'Text'),(2,'Password'),(3,'ComboBox'),(4,'Radio'),(5,'CheckBox'),(6,'Image'),(7,'UPload'),(8,'Date');
/*!40000 ALTER TABLE `controltype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crdrmaster`
--

DROP TABLE IF EXISTS `crdrmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crdrmaster` (
  `CrDrMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `CrDrName` varchar(45) DEFAULT NULL,
  `CrDrFullName` varchar(45) DEFAULT NULL,
  `CrDrValue` int(11) DEFAULT NULL,
  PRIMARY KEY (`CrDrMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crdrmaster`
--

LOCK TABLES `crdrmaster` WRITE;
/*!40000 ALTER TABLE `crdrmaster` DISABLE KEYS */;
INSERT INTO `crdrmaster` VALUES (1,'Cr','Credit',1),(2,'Dr','Debit',-1);
/*!40000 ALTER TABLE `crdrmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formmaster`
--

DROP TABLE IF EXISTS `formmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formmaster` (
  `FormMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `TableMasterId` int(11) DEFAULT NULL,
  `jsonFileName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`FormMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formmaster`
--

LOCK TABLES `formmaster` WRITE;
/*!40000 ALTER TABLE `formmaster` DISABLE KEYS */;
INSERT INTO `formmaster` VALUES (1,1,'ItemMaster.js'),(2,2,'AccountMaster.js'),(3,3,'UnitMaster.js');
/*!40000 ALTER TABLE `formmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `formtype`
--

DROP TABLE IF EXISTS `formtype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `formtype` (
  `FormTypeId` int(11) NOT NULL,
  `FormTypeName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`FormTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `formtype`
--

LOCK TABLES `formtype` WRITE;
/*!40000 ALTER TABLE `formtype` DISABLE KEYS */;
INSERT INTO `formtype` VALUES (0,'none'),(1,'Form'),(2,'Report'),(3,'Form & Report');
/*!40000 ALTER TABLE `formtype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `godownmaster`
--

DROP TABLE IF EXISTS `godownmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `godownmaster` (
  `GodownMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `GodownName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`GodownMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `godownmaster`
--

LOCK TABLES `godownmaster` WRITE;
/*!40000 ALTER TABLE `godownmaster` DISABLE KEYS */;
INSERT INTO `godownmaster` VALUES (1,'Primary'),(2,'A Godown'),(3,'B Godown');
/*!40000 ALTER TABLE `godownmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groupmaster`
--

DROP TABLE IF EXISTS `groupmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groupmaster` (
  `GroupMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `GroupName` varchar(45) DEFAULT NULL,
  `AnnualMasterId` int(11) DEFAULT NULL,
  `CrDrMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`GroupMasterId`),
  KEY `GroupMaster_AnnualMaster_AnnualMasterId_idx` (`AnnualMasterId`),
  KEY `GroupMaster_CrDrMaster_CrDrMasterId_idx` (`CrDrMasterId`),
  CONSTRAINT `GroupMaster_AnnualMaster_AnnualMasterId` FOREIGN KEY (`AnnualMasterId`) REFERENCES `annualmaster` (`AnnualMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `GroupMaster_CrDrMaster_CrDrMasterId` FOREIGN KEY (`CrDrMasterId`) REFERENCES `crdrmaster` (`CrDrMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groupmaster`
--

LOCK TABLES `groupmaster` WRITE;
/*!40000 ALTER TABLE `groupmaster` DISABLE KEYS */;
INSERT INTO `groupmaster` VALUES (1,'Opeaning Stock',3,1),(2,'Purchase',3,2),(3,'Direct Expenses',3,1),(4,'Sales',3,2),(5,'Direct Income',NULL,NULL),(6,'Indirect Expenses',NULL,NULL),(7,'Indirect Income',NULL,NULL),(8,'Capital',NULL,NULL),(9,'Rev. & surplus',NULL,NULL),(10,'Secured Loan',NULL,NULL),(11,'UnSecured Loan',NULL,NULL),(12,'Current Libility',NULL,NULL),(13,'Creditors',NULL,NULL),(14,'Tax & Provision',NULL,NULL),(15,'Fixed Assets',NULL,NULL),(16,'Investment',NULL,NULL),(17,'Current Assets',NULL,NULL),(18,'Debtors',NULL,NULL),(20,'Misc & Assets',NULL,NULL),(21,'Bank',NULL,NULL);
/*!40000 ALTER TABLE `groupmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gsttype`
--

DROP TABLE IF EXISTS `gsttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gsttype` (
  `gsttypeId` int(11) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`gsttypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gsttype`
--

LOCK TABLES `gsttype` WRITE;
/*!40000 ALTER TABLE `gsttype` DISABLE KEYS */;
INSERT INTO `gsttype` VALUES (0,'None'),(1,'Item Wise GST'),(2,'Item Total GST'),(3,'Amount Total GST');
/*!40000 ALTER TABLE `gsttype` ENABLE KEYS */;
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
  `QuantityTypeId` int(11) DEFAULT NULL,
  `GstRate` float DEFAULT NULL,
  PRIMARY KEY (`ItemMasterId`),
  KEY `ItemMaster_QuantityType_QuantityTypeId_idx` (`QuantityTypeId`),
  CONSTRAINT `ItemMaster_QuantityType_QuantityTypeId` FOREIGN KEY (`QuantityTypeId`) REFERENCES `quantitytype` (`QuantityTypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemmaster`
--

LOCK TABLES `itemmaster` WRITE;
/*!40000 ALTER TABLE `itemmaster` DISABLE KEYS */;
INSERT INTO `itemmaster` VALUES (22,'aaa',1,2,1,5),(23,'kk',4,4,1,10),(24,'aaa',10,20,1,12),(26,'popto',10,20,2,NULL),(27,'bbb',100,200,2,NULL),(28,'ccc',1000,2000,3,NULL),(29,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `itemmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master`
--

DROP TABLE IF EXISTS `master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `master` (
  `MasterId` int(11) NOT NULL AUTO_INCREMENT,
  `MasterName` varchar(45) DEFAULT NULL,
  `MasterTableName` varchar(45) DEFAULT NULL,
  `MasterPrimaryKey` varchar(45) DEFAULT NULL,
  `MasterView` varchar(45) DEFAULT NULL,
  `MasterShow` int(11) DEFAULT NULL,
  `HyperLink` int(11) DEFAULT '0',
  `HyperName` varchar(45) DEFAULT NULL,
  `LocationPath` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master`
--

LOCK TABLES `master` WRITE;
/*!40000 ALTER TABLE `master` DISABLE KEYS */;
INSERT INTO `master` VALUES (1,'Item','ItemMaster','ItemMasterId','vwitemMaster',1,0,'master/item','master.itemdetails'),(2,'Account','AccountMaster','AccountMasterId','vwaccountmaster',1,0,'master/account','master.accountdetails'),(3,'Unit','UnitMaster','UnitMasterId','UnitMaster',1,0,'master/item',NULL),(4,'Group Master','GroupMaster','GroupMasterId','vwGroupMaster',1,0,NULL,NULL),(5,'Godown Master','GodownMaster','GodownMasterId','GodownMaster',1,0,NULL,NULL),(6,'State Master','StateMaster','StateMasterId','StateMaster',1,0,NULL,NULL);
/*!40000 ALTER TABLE `master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menumaster`
--

DROP TABLE IF EXISTS `menumaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menumaster` (
  `MenuMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `ParentMenuMasterId` int(11) DEFAULT NULL,
  `MenuName` varchar(45) DEFAULT NULL,
  `Css` varchar(45) DEFAULT NULL,
  `UiRounterName` varchar(45) DEFAULT NULL,
  `FormMasterId` int(11) DEFAULT NULL,
  `Visible` int(11) DEFAULT NULL,
  `Query` varchar(200) DEFAULT NULL,
  `VoucherTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`MenuMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=2004 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menumaster`
--

LOCK TABLES `menumaster` WRITE;
/*!40000 ALTER TABLE `menumaster` DISABLE KEYS */;
INSERT INTO `menumaster` VALUES (1,1,'Master',NULL,'deluxstate',NULL,1,NULL,NULL),(2,1,'Item',NULL,'deluxstate',1,1,'select * from vwitemmaster',NULL),(3,1,'Account',NULL,'deluxstate',2,1,'select *  from vwaccountmaster',NULL),(4,1,'Unit',NULL,'deluxstate',3,1,'select *  from UnitMaster',NULL),(5,1,'Group Master',NULL,'deluxstate',NULL,0,NULL,NULL),(6,1,'State Master',NULL,'deluxstate',NULL,0,NULL,NULL),(100,100,'Transction',NULL,'deluxstate',NULL,1,'select *  from vwtranscation',NULL),(101,100,'Purchase Vouchase',NULL,'deluxform',10,1,NULL,10),(102,100,'Sales Vouchase',NULL,'deluxform',11,1,NULL,11),(103,100,'Purachase Return',NULL,'deluxform',0,0,NULL,NULL),(104,100,'Sales Return',NULL,'deluxform',0,0,NULL,NULL),(105,100,'Cash Receipt',NULL,'deluxform',12,1,NULL,12),(106,100,'Cash Payment',NULL,'deluxform',13,1,NULL,13),(107,100,'Bank Receipt',NULL,'deluxform',14,1,NULL,14),(108,100,'Bank Payment',NULL,'deluxform',15,1,NULL,15),(109,100,'Journal Vourcher',NULL,'deluxform',16,1,NULL,16),(1000,1000,'Report',NULL,'deluxstate',NULL,1,NULL,NULL),(1001,1000,'DayBook',NULL,NULL,NULL,1,'call  preDaybook',NULL),(1002,1000,'TrialBalance',NULL,NULL,NULL,1,'call  preTrialBalance',NULL),(1003,1000,'Trading Account',NULL,'deluxstate',NULL,1,'call preTradingAccount',NULL),(1004,1000,'Proft & Loss Account',NULL,'deluxstate',NULL,1,'call preProfitAndLoss',NULL),(1005,1000,'Balance Sheet',NULL,'deluxstate',NULL,1,'call  preBalanceSheet',NULL),(1006,1000,'Cash Flow',NULL,'deluxstate',NULL,1,'call preCashFlow',NULL),(1007,1000,'Fund Flow',NULL,'deluxstate',NULL,1,'call preFundFlow',NULL),(1008,1000,'GST Report',NULL,NULL,NULL,1,'call PreGST',NULL),(2000,2000,'Utility',NULL,'deluxstate',NULL,1,'',NULL),(2001,2000,'Setting',NULL,'deluxstate',NULL,1,NULL,NULL),(2002,2000,'Change Password',NULL,'deluxstate',NULL,1,NULL,NULL),(2003,2000,'Buckup & Restore',NULL,'deluxstate',NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `menumaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectmaster`
--

DROP TABLE IF EXISTS `projectmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectmaster` (
  `ProjectMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ProjectMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectmaster`
--

LOCK TABLES `projectmaster` WRITE;
/*!40000 ALTER TABLE `projectmaster` DISABLE KEYS */;
INSERT INTO `projectmaster` VALUES (1,'Account System'),(2,'HRMS System'),(3,'Time Clock & PayRoll ');
/*!40000 ALTER TABLE `projectmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectmenudetails`
--

DROP TABLE IF EXISTS `projectmenudetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `projectmenudetails` (
  `ProjectMenuDetailsId` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectMasterId` int(11) DEFAULT NULL,
  `MenuMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`ProjectMenuDetailsId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectmenudetails`
--

LOCK TABLES `projectmenudetails` WRITE;
/*!40000 ALTER TABLE `projectmenudetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `projectmenudetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quantitytype`
--

DROP TABLE IF EXISTS `quantitytype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quantitytype` (
  `QuantityTypeId` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`QuantityTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quantitytype`
--

LOCK TABLES `quantitytype` WRITE;
/*!40000 ALTER TABLE `quantitytype` DISABLE KEYS */;
INSERT INTO `quantitytype` VALUES (0,'None'),(1,'TotalQuantity'),(2,'Length and Heigth'),(3,'Length Heigth and Width');
/*!40000 ALTER TABLE `quantitytype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratetype`
--

DROP TABLE IF EXISTS `ratetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratetype` (
  `RateTypeId` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`RateTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratetype`
--

LOCK TABLES `ratetype` WRITE;
/*!40000 ALTER TABLE `ratetype` DISABLE KEYS */;
INSERT INTO `ratetype` VALUES (0,'None'),(1,'Unit Type Rate');
/*!40000 ALTER TABLE `ratetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statemaster`
--

DROP TABLE IF EXISTS `statemaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `statemaster` (
  `StateMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `StateName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`StateMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statemaster`
--

LOCK TABLES `statemaster` WRITE;
/*!40000 ALTER TABLE `statemaster` DISABLE KEYS */;
INSERT INTO `statemaster` VALUES (1,'Gujrate'),(2,'Rajshtan'),(3,'Maharastra');
/*!40000 ALTER TABLE `statemaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stocktype`
--

DROP TABLE IF EXISTS `stocktype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stocktype` (
  `StockTypeId` int(11) NOT NULL,
  `StockMethodName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`StockTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stocktype`
--

LOCK TABLES `stocktype` WRITE;
/*!40000 ALTER TABLE `stocktype` DISABLE KEYS */;
INSERT INTO `stocktype` VALUES (1,'AVG'),(2,'FiFO'),(3,'LIFO'),(4,'Weight AVG'),(5,'Last  Purchase'),(6,'Last Sale'),(7,'Fixed Rate'),(8,'Transcation Wise');
/*!40000 ALTER TABLE `stocktype` ENABLE KEYS */;
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
  `ParentTableMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`TableMasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tablemaster`
--

LOCK TABLES `tablemaster` WRITE;
/*!40000 ALTER TABLE `tablemaster` DISABLE KEYS */;
INSERT INTO `tablemaster` VALUES (1,'ItemMaster','ItemMasterId',1),(2,'AccountMaster','AccountMasterId',2),(3,'UnitMaster','UnitMasterId',3);
/*!40000 ALTER TABLE `tablemaster` ENABLE KEYS */;
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
  `AccountMasterId` int(11) DEFAULT NULL,
  `VoucherTypeId` int(11) DEFAULT NULL,
  `Total` varchar(45) DEFAULT NULL,
  `Remarks` varchar(45) DEFAULT NULL,
  `GstAmount` int(11) DEFAULT NULL,
  `SgstAmount` int(11) DEFAULT NULL,
  `GrantTotal` int(11) DEFAULT NULL,
  PRIMARY KEY (`TranId`),
  KEY `Tran_AccountMaster_AccountMasterId_idx` (`AccountMasterId`),
  CONSTRAINT `Tran_AccountMaster_AccountMasterId` FOREIGN KEY (`AccountMasterId`) REFERENCES `accountmaster` (`AccountMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tran`
--

LOCK TABLES `tran` WRITE;
/*!40000 ALTER TABLE `tran` DISABLE KEYS */;
INSERT INTO `tran` VALUES (167,NULL,NULL,11,NULL,NULL,NULL,NULL,NULL,NULL),(171,'4','2019-03-07',NULL,16,'0','44',NULL,NULL,NULL),(172,'1','2019-03-08',7,2,'40','333',NULL,NULL,NULL),(173,'3','2019-03-15',11,12,'44','44',NULL,NULL,NULL),(174,'2','2019-03-15',6,10,'42712.5',NULL,NULL,NULL,NULL);
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
  `Quantity` float DEFAULT NULL,
  `Nos` float DEFAULT NULL,
  `TotalQuantity` float DEFAULT NULL,
  `Rate` float DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `GstRate` float DEFAULT NULL,
  `GstAmount` float DEFAULT NULL,
  `ExpireDate` date DEFAULT NULL,
  `BatchNo` varchar(45) DEFAULT NULL,
  `Remark` varchar(45) DEFAULT NULL,
  `IsDeleted` int(11) NOT NULL DEFAULT '0',
  `QuantityUnitId` int(11) DEFAULT NULL,
  `RateUnitId` int(11) DEFAULT NULL,
  `ConversionRatio` float DEFAULT NULL,
  `GodownMasterId` int(11) DEFAULT NULL,
  `UnitMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`TranDetailsId`),
  KEY `Trandetails_ItemMaster_idx` (`ItemMasterId`),
  KEY `Trandetails_Tran_idx` (`TranId`),
  KEY `Trandetails_Godown_idx` (`GodownMasterId`),
  KEY `Trandetails_Unit_idx` (`UnitMasterId`),
  CONSTRAINT `Trandetails_Godown` FOREIGN KEY (`GodownMasterId`) REFERENCES `godownmaster` (`GodownMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Trandetails_ItemMaster` FOREIGN KEY (`ItemMasterId`) REFERENCES `itemmaster` (`ItemMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Trandetails_Tran` FOREIGN KEY (`TranId`) REFERENCES `tran` (`TranId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Trandetails_Unit` FOREIGN KEY (`UnitMasterId`) REFERENCES `unitmaster` (`UnitMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trandetails`
--

LOCK TABLES `trandetails` WRITE;
/*!40000 ALTER TABLE `trandetails` DISABLE KEYS */;
INSERT INTO `trandetails` VALUES (160,167,NULL,22,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,12),(173,172,1,26,12,12,NULL,1,2,2,20,40,NULL,NULL,NULL,NULL,'sddd',0,NULL,NULL,NULL,NULL,NULL),(174,174,1,26,20,10,NULL,142.375,30,4271.25,10,42712.5,2,NULL,'2019-03-26','33','333',0,NULL,NULL,NULL,2,1);
/*!40000 ALTER TABLE `trandetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tranfin`
--

DROP TABLE IF EXISTS `tranfin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tranfin` (
  `TranfinId` int(11) NOT NULL AUTO_INCREMENT,
  `TranId` int(11) NOT NULL,
  `Srno` int(11) DEFAULT NULL,
  `CrDrMasterId` int(11) DEFAULT NULL,
  `AccountMasterId` int(11) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `BankDate` datetime DEFAULT NULL,
  `Remark` varchar(45) DEFAULT NULL,
  `IsDeleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TranfinId`,`TranId`),
  KEY `TranFin_CrDrMaster_CrDrMasterId_idx` (`CrDrMasterId`),
  KEY `TranFin_AccountMaster_AccountMaterId_idx` (`AccountMasterId`),
  CONSTRAINT `TranFin_AccountMaster_AccountMaterId` FOREIGN KEY (`AccountMasterId`) REFERENCES `accountmaster` (`AccountMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `TranFin_CrDrMaster_CrDrMasterId` FOREIGN KEY (`CrDrMasterId`) REFERENCES `crdrmaster` (`CrDrMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tranfin`
--

LOCK TABLES `tranfin` WRITE;
/*!40000 ALTER TABLE `tranfin` DISABLE KEYS */;
INSERT INTO `tranfin` VALUES (8,0,2,1,7,111,NULL,'2',0),(14,171,1,1,6,4444,NULL,NULL,0);
/*!40000 ALTER TABLE `tranfin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unitmaster`
--

DROP TABLE IF EXISTS `unitmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unitmaster` (
  `UnitMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `FullName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`UnitMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unitmaster`
--

LOCK TABLES `unitmaster` WRITE;
/*!40000 ALTER TABLE `unitmaster` DISABLE KEYS */;
INSERT INTO `unitmaster` VALUES (1,'Kg','Kilo Grame'),(2,'Ltr','Liter'),(3,'Box','Box'),(8,'dz','dozen'),(12,'ppp','ppp4');
/*!40000 ALTER TABLE `unitmaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usermaster`
--

DROP TABLE IF EXISTS `usermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usermaster` (
  `UserMasterId` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(45) DEFAULT NULL,
  `Pass` varchar(45) DEFAULT NULL,
  `AccountMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`UserMasterId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usermaster`
--

LOCK TABLES `usermaster` WRITE;
/*!40000 ALTER TABLE `usermaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `usermaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vouchertype`
--

DROP TABLE IF EXISTS `vouchertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vouchertype` (
  `VoucherTypeId` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Color` varchar(45) DEFAULT NULL,
  `TemplateName` varchar(45) DEFAULT NULL,
  `Visible` int(11) DEFAULT '1',
  `CrDrValue` int(11) DEFAULT NULL,
  `InOutValue` int(11) DEFAULT NULL,
  `PrintTemplateName` varchar(45) DEFAULT NULL,
  `jsonFileName` varchar(45) DEFAULT NULL,
  `tablename` varchar(45) DEFAULT NULL,
  `Rate` varchar(45) DEFAULT NULL,
  `CrDrMasterId` int(11) DEFAULT NULL,
  PRIMARY KEY (`VoucherTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchertype`
--

LOCK TABLES `vouchertype` WRITE;
/*!40000 ALTER TABLE `vouchertype` DISABLE KEYS */;
INSERT INTO `vouchertype` VALUES (1,'Purchase Vouchse','Red','sales',0,1,1,'salesprint',NULL,NULL,NULL,NULL),(2,'Sales','green','sales',0,-1,-1,'salesprint',NULL,NULL,NULL,NULL),(3,'Purachase Return','skyblue','sales',0,-1,-1,'salesprint',NULL,NULL,NULL,NULL),(4,'Sales Return','purple','sales',0,1,1,'salesprint',NULL,NULL,NULL,NULL),(5,'Cash Receipt','Green','cash',0,1,0,'CashPrint',NULL,NULL,NULL,NULL),(6,'Cash Payment','Red','cash',0,-1,0,'CashPrint',NULL,NULL,NULL,NULL),(7,'Bank Receipt','Green','bank',0,0,0,NULL,NULL,NULL,NULL,NULL),(8,'Bank Payment','Red','bank',0,0,0,NULL,NULL,NULL,NULL,NULL),(9,'Journal Vourcher','Yellow','jv',0,0,0,NULL,NULL,NULL,NULL,NULL),(10,'Purchase','pink','Tran',1,1,1,'','inventory','TranDetails','PurRate',NULL),(11,'Sales','green','Tran',1,-1,-1,'salesprint','inventory','TranDetails','SaleRate',NULL),(12,'Cash Receipt','Green','Tran',1,NULL,NULL,NULL,'cash','',NULL,NULL),(13,'Cash payment','Red','Tran',1,NULL,NULL,NULL,'cash','',NULL,NULL),(14,'Bank Receipt','Green','Tran',1,NULL,NULL,NULL,'bank','Tranfin',NULL,1),(15,'Bank Payment','Red','Tran',1,NULL,NULL,NULL,'bank','Tranfin',NULL,2),(16,'JV','Yellow','Tran',1,NULL,NULL,NULL,'jv','Tranfin',NULL,NULL);
/*!40000 ALTER TABLE `vouchertype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vwaccountdetails`
--

DROP TABLE IF EXISTS `vwaccountdetails`;
/*!50001 DROP VIEW IF EXISTS `vwaccountdetails`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwaccountdetails` (
  `TranId` tinyint NOT NULL,
  `BillNo` tinyint NOT NULL,
  `BillDate` tinyint NOT NULL,
  `AccountMasterId` tinyint NOT NULL,
  `VoucherTypeId` tinyint NOT NULL,
  `Vourchase Name` tinyint NOT NULL,
  `Debite` tinyint NOT NULL,
  `Credit` tinyint NOT NULL,
  `Remarks` tinyint NOT NULL,
  `TemplateName` tinyint NOT NULL,
  `Bal` tinyint NOT NULL,
  `Color` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vwaccountmaster`
--

DROP TABLE IF EXISTS `vwaccountmaster`;
/*!50001 DROP VIEW IF EXISTS `vwaccountmaster`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwaccountmaster` (
  `AccountMasterId` tinyint NOT NULL,
  `AccountName` tinyint NOT NULL,
  `Address` tinyint NOT NULL,
  `City` tinyint NOT NULL,
  `Phone` tinyint NOT NULL,
  `StateName` tinyint NOT NULL,
  `GroupName` tinyint NOT NULL,
  `Balance` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vwgroupmaster`
--

DROP TABLE IF EXISTS `vwgroupmaster`;
/*!50001 DROP VIEW IF EXISTS `vwgroupmaster`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwgroupmaster` (
  `GroupMasterId` tinyint NOT NULL,
  `GroupName` tinyint NOT NULL,
  `AnnualName` tinyint NOT NULL,
  `CrDrName` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vwitemdetails`
--

DROP TABLE IF EXISTS `vwitemdetails`;
/*!50001 DROP VIEW IF EXISTS `vwitemdetails`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwitemdetails` (
  `BillNo` tinyint NOT NULL,
  `BillDate` tinyint NOT NULL,
  `Vouchase Name` tinyint NOT NULL,
  `accountName` tinyint NOT NULL,
  `Inward` tinyint NOT NULL,
  `OutWard` tinyint NOT NULL,
  `Stock` tinyint NOT NULL,
  `PurchaseAmount` tinyint NOT NULL,
  `Amount` tinyint NOT NULL,
  `Profit` tinyint NOT NULL,
  `ItemMasterId` tinyint NOT NULL,
  `TemplateName` tinyint NOT NULL,
  `VoucherTypeId` tinyint NOT NULL,
  `TranId` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vwitemmaster`
--

DROP TABLE IF EXISTS `vwitemmaster`;
/*!50001 DROP VIEW IF EXISTS `vwitemmaster`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwitemmaster` (
  `ItemMasterId` tinyint NOT NULL,
  `ItemName` tinyint NOT NULL,
  `PurRate` tinyint NOT NULL,
  `SaleRate` tinyint NOT NULL,
  `QuantityTypeId` tinyint NOT NULL,
  `QuantityTypeName` tinyint NOT NULL,
  `Stock` tinyint NOT NULL,
  `Profit` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vwtranscation`
--

DROP TABLE IF EXISTS `vwtranscation`;
/*!50001 DROP VIEW IF EXISTS `vwtranscation`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vwtranscation` (
  `TranId` tinyint NOT NULL,
  `BillDate` tinyint NOT NULL,
  `BillNo` tinyint NOT NULL,
  `Remarks` tinyint NOT NULL,
  `Total` tinyint NOT NULL,
  `VoucherTypeId` tinyint NOT NULL,
  `AccountName` tinyint NOT NULL,
  `Address` tinyint NOT NULL,
  `VoucherName` tinyint NOT NULL,
  `TemplateName` tinyint NOT NULL,
  `PrintTemplateName` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vwaccountdetails`
--

/*!50001 DROP TABLE IF EXISTS `vwaccountdetails`*/;
/*!50001 DROP VIEW IF EXISTS `vwaccountdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwaccountdetails` AS select `t`.`TranId` AS `TranId`,`t`.`BillNo` AS `BillNo`,`t`.`BillDate` AS `BillDate`,`t`.`AccountMasterId` AS `AccountMasterId`,`t`.`VoucherTypeId` AS `VoucherTypeId`,`v`.`Name` AS `Vourchase Name`,if((`v`.`CrDrValue` = -(1)),abs((`t`.`Total` * `v`.`CrDrValue`)),0) AS `Debite`,if((`v`.`CrDrValue` = 1),(`t`.`Total` * `v`.`CrDrValue`),0) AS `Credit`,`t`.`Remarks` AS `Remarks`,`v`.`TemplateName` AS `TemplateName`,(`t`.`Total` * `v`.`CrDrValue`) AS `Bal`,`v`.`Color` AS `Color` from (`tran` `t` join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vwaccountmaster`
--

/*!50001 DROP TABLE IF EXISTS `vwaccountmaster`*/;
/*!50001 DROP VIEW IF EXISTS `vwaccountmaster`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwaccountmaster` AS select `a`.`AccountMasterId` AS `AccountMasterId`,`a`.`AccountName` AS `AccountName`,`a`.`Address` AS `Address`,`a`.`City` AS `City`,`a`.`Phone` AS `Phone`,`s`.`StateName` AS `StateName`,`g`.`GroupName` AS `GroupName`,if((sum((`t`.`Total` * `v`.`CrDrValue`)) > 0),concat(round(sum((`t`.`Total` * `v`.`CrDrValue`)),2),' Cr'),concat((round(sum((`t`.`Total` * `v`.`CrDrValue`)),2) * -(1)),' Dr')) AS `Balance` from ((((`accountmaster` `a` left join `tran` `t` on((`a`.`AccountMasterId` = `t`.`AccountMasterId`))) left join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) left join `statemaster` `s` on((`a`.`StateMasterId` = `s`.`StateMasterId`))) left join `groupmaster` `g` on((`g`.`GroupMasterId` = `a`.`GroupMasterId`))) group by `a`.`AccountMasterId`,`a`.`AccountName`,`a`.`Address`,`a`.`City`,`a`.`Phone`,`s`.`StateName`,`g`.`GroupName` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vwgroupmaster`
--

/*!50001 DROP TABLE IF EXISTS `vwgroupmaster`*/;
/*!50001 DROP VIEW IF EXISTS `vwgroupmaster`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwgroupmaster` AS select `g`.`GroupMasterId` AS `GroupMasterId`,`g`.`GroupName` AS `GroupName`,`a`.`AnnualName` AS `AnnualName`,`cd`.`CrDrName` AS `CrDrName` from ((`groupmaster` `g` left join `annualmaster` `a` on((`a`.`AnnualMasterId` = `g`.`AnnualMasterId`))) left join `crdrmaster` `cd` on((`cd`.`CrDrMasterId` = `g`.`CrDrMasterId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vwitemdetails`
--

/*!50001 DROP TABLE IF EXISTS `vwitemdetails`*/;
/*!50001 DROP VIEW IF EXISTS `vwitemdetails`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwitemdetails` AS select `t`.`BillNo` AS `BillNo`,`t`.`BillDate` AS `BillDate`,`v`.`Name` AS `Vouchase Name`,`a`.`AccountName` AS `accountName`,if((`v`.`InOutValue` = 1),`td`.`TotalQuantity`,0) AS `Inward`,if((`v`.`InOutValue` = -(1)),`td`.`TotalQuantity`,0) AS `OutWard`,(`td`.`TotalQuantity` * `v`.`InOutValue`) AS `Stock`,if((`v`.`InOutValue` = 1),`td`.`Amount`,0) AS `PurchaseAmount`,`td`.`Amount` AS `Amount`,0 AS `Profit`,`td`.`ItemMasterId` AS `ItemMasterId`,`v`.`TemplateName` AS `TemplateName`,`v`.`VoucherTypeId` AS `VoucherTypeId`,`t`.`TranId` AS `TranId` from (((`trandetails` `td` join `tran` `t` on((`t`.`TranId` = `td`.`TranId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) join `accountmaster` `a` on((`a`.`AccountMasterId` = `t`.`AccountMasterId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vwitemmaster`
--

/*!50001 DROP TABLE IF EXISTS `vwitemmaster`*/;
/*!50001 DROP VIEW IF EXISTS `vwitemmaster`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwitemmaster` AS select `itemmaster`.`ItemMasterId` AS `ItemMasterId`,`itemmaster`.`ItemName` AS `ItemName`,`itemmaster`.`PurRate` AS `PurRate`,`itemmaster`.`SaleRate` AS `SaleRate`,`itemmaster`.`QuantityTypeId` AS `QuantityTypeId`,`qt`.`Name` AS `QuantityTypeName`,(select sum((`td`.`TotalQuantity` * `v`.`InOutValue`)) from ((`trandetails` `td` join `tran` `t` on((`t`.`TranId` = `td`.`TranId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) where ((`td`.`ItemMasterId` = `itemmaster`.`ItemMasterId`) and (`td`.`IsDeleted` = 0))) AS `Stock`,(select ((sum(if((`v`.`InOutValue` = -(1)),`td`.`Amount`,0)) - sum(if((`v`.`InOutValue` = 1),`td`.`Amount`,0))) + (sum((`v`.`InOutValue` * `td`.`TotalQuantity`)) * (sum(if((`v`.`InOutValue` = 1),`td`.`Amount`,0)) / sum(if((`v`.`InOutValue` = 1),`td`.`TotalQuantity`,0))))) from ((`trandetails` `td` join `tran` `t` on((`t`.`TranId` = `td`.`TranId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) where ((`td`.`ItemMasterId` = `itemmaster`.`ItemMasterId`) and (`td`.`IsDeleted` = 0))) AS `Profit` from (`itemmaster` join `quantitytype` `qt` on((`qt`.`QuantityTypeId` = `itemmaster`.`QuantityTypeId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vwtranscation`
--

/*!50001 DROP TABLE IF EXISTS `vwtranscation`*/;
/*!50001 DROP VIEW IF EXISTS `vwtranscation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vwtranscation` AS select `t`.`TranId` AS `TranId`,`t`.`BillDate` AS `BillDate`,`t`.`BillNo` AS `BillNo`,`t`.`Remarks` AS `Remarks`,`t`.`Total` AS `Total`,`t`.`VoucherTypeId` AS `VoucherTypeId`,ifnull(`a`.`AccountName`,'') AS `AccountName`,`a`.`Address` AS `Address`,`v`.`Name` AS `VoucherName`,`v`.`TemplateName` AS `TemplateName`,`v`.`PrintTemplateName` AS `PrintTemplateName` from ((`tran` `t` left join `accountmaster` `a` on((`t`.`AccountMasterId` = `a`.`AccountMasterId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-15  8:10:41
