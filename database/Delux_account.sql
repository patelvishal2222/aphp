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
INSERT INTO `accountmaster` VALUES (6,'vishal patel','aa','ss','ssss'),(7,'ravi','aaa','555','55'),(9,'amit','asda','123','555');
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
  `QuantityTypeId` int(11) DEFAULT NULL,
  PRIMARY KEY (`ItemMasterId`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itemmaster`
--

LOCK TABLES `itemmaster` WRITE;
/*!40000 ALTER TABLE `itemmaster` DISABLE KEYS */;
INSERT INTO `itemmaster` VALUES (6,'potato',1,20,2),(7,'began',20,31,2),(8,'onion',1,2,2),(9,'Tiltes',50,60,1);
/*!40000 ALTER TABLE `itemmaster` ENABLE KEYS */;
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
INSERT INTO `quantitytype` VALUES (1,'TotalQuntity'),(2,'Lenth and Heigth');
/*!40000 ALTER TABLE `quantitytype` ENABLE KEYS */;
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
  `AccountMasterId` int(11) NOT NULL,
  `VoucherTypeId` int(11) DEFAULT NULL,
  `Total` varchar(45) DEFAULT NULL,
  `Remarks` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TranId`),
  KEY `Tran_AccountMaster_AccountMasterId_idx` (`AccountMasterId`),
  CONSTRAINT `Tran_AccountMaster_AccountMasterId` FOREIGN KEY (`AccountMasterId`) REFERENCES `accountmaster` (`AccountMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tran`
--

LOCK TABLES `tran` WRITE;
/*!40000 ALTER TABLE `tran` DISABLE KEYS */;
INSERT INTO `tran` VALUES (48,'1','2018-08-31',6,2,'700',''),(49,'10','2018-08-31',6,2,'480',''),(50,'2','2018-09-01',9,2,'1500',''),(51,'17','2018-09-01',6,1,'120',''),(52,'1','2018-09-01',6,5,'100','');
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
  `details` varchar(45) DEFAULT NULL,
  `IsDeleted` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TranDetailsId`),
  KEY `Trandetails_ItemMaster_idx` (`ItemMasterId`),
  KEY `Trandetails_Tran_idx` (`TranId`),
  CONSTRAINT `Trandetails_ItemMaster` FOREIGN KEY (`ItemMasterId`) REFERENCES `itemmaster` (`ItemMasterId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `Trandetails_Tran` FOREIGN KEY (`TranId`) REFERENCES `tran` (`TranId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trandetails`
--

LOCK TABLES `trandetails` WRITE;
/*!40000 ALTER TABLE `trandetails` DISABLE KEYS */;
INSERT INTO `trandetails` VALUES (73,48,1,6,12,12,NULL,1,2,2,20,40,NULL,0),(74,48,2,9,0,0,NULL,0,0,10,60,600,NULL,0),(75,48,3,9,0,0,NULL,0,0,1,60,60,NULL,0),(76,49,1,9,0,0,NULL,0,0,2,60,120,NULL,0),(77,49,2,9,0,0,NULL,0,0,6,60,360,NULL,0),(78,50,1,9,0,0,NULL,0,0,20,60,1200,NULL,0),(79,50,2,9,0,0,NULL,0,0,5,60,300,NULL,0),(80,51,1,9,0,0,NULL,0,0,2,60,120,NULL,0);
/*!40000 ALTER TABLE `trandetails` ENABLE KEYS */;
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
  PRIMARY KEY (`VoucherTypeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vouchertype`
--

LOCK TABLES `vouchertype` WRITE;
/*!40000 ALTER TABLE `vouchertype` DISABLE KEYS */;
INSERT INTO `vouchertype` VALUES (1,'Purchase Vouchse','Red','sales',1,1,1,'SalesPrint'),(2,'Sales','green','sales',1,-1,-1,'SalesPrint'),(3,'Purachase Return','skyblue','sales',0,-1,-1,'SalesPrint'),(4,'Sales Return','purple','sales',0,1,1,'SalesPrint'),(5,'Cash Receipt','Green','cash',1,1,0,'CashPrint'),(6,'Cash Payment','Red','cash',1,-1,0,'CashPrint'),(7,'Bank Receipt','Green','bank',0,0,0,NULL),(8,'Bank Payment','Red','bank',0,0,0,NULL),(9,'Journal Vourcher','Yellow','jv',0,0,0,NULL);
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
  `Debite` tinyint NOT NULL,
  `Credit` tinyint NOT NULL,
  `Bal` tinyint NOT NULL,
  `TemplateName` tinyint NOT NULL,
  `Remarks` tinyint NOT NULL,
  `Color` tinyint NOT NULL,
  `name` tinyint NOT NULL
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
  `Balance` tinyint NOT NULL
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
  `accountName` tinyint NOT NULL,
  `Inward` tinyint NOT NULL,
  `OutWard` tinyint NOT NULL,
  `Stock` tinyint NOT NULL,
  `Amount` tinyint NOT NULL,
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
  `Stock` tinyint NOT NULL
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
  `TemplateName` tinyint NOT NULL
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
/*!50001 VIEW `vwaccountdetails` AS select `t`.`TranId` AS `TranId`,`t`.`BillNo` AS `BillNo`,`t`.`BillDate` AS `BillDate`,`t`.`AccountMasterId` AS `AccountMasterId`,`t`.`VoucherTypeId` AS `VoucherTypeId`,if((`v`.`CrDrValue` = -(1)),abs((`t`.`Total` * `v`.`CrDrValue`)),0) AS `Debite`,if((`v`.`CrDrValue` = 1),(`t`.`Total` * `v`.`CrDrValue`),0) AS `Credit`,(`t`.`Total` * `v`.`CrDrValue`) AS `Bal`,`v`.`TemplateName` AS `TemplateName`,`t`.`Remarks` AS `Remarks`,`v`.`Color` AS `Color`,`v`.`Name` AS `name` from (`tran` `t` join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) */;
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
/*!50001 VIEW `vwaccountmaster` AS select `a`.`AccountMasterId` AS `AccountMasterId`,`a`.`AccountName` AS `AccountName`,`a`.`Address` AS `Address`,`a`.`City` AS `City`,`a`.`Phone` AS `Phone`,sum((`t`.`Total` * `v`.`CrDrValue`)) AS `Balance` from ((`accountmaster` `a` join `tran` `t` on((`a`.`AccountMasterId` = `t`.`AccountMasterId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) group by `a`.`AccountMasterId`,`a`.`AccountName`,`a`.`Address`,`a`.`City`,`a`.`Phone` */;
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
/*!50001 VIEW `vwitemdetails` AS select `t`.`BillNo` AS `BillNo`,`t`.`BillDate` AS `BillDate`,`a`.`AccountName` AS `accountName`,if((`v`.`InOutValue` = 1),`td`.`TotalQuantity`,0) AS `Inward`,if((`v`.`InOutValue` = -(1)),`td`.`TotalQuantity`,0) AS `OutWard`,(`td`.`TotalQuantity` * `v`.`InOutValue`) AS `Stock`,`td`.`Amount` AS `Amount`,`td`.`ItemMasterId` AS `ItemMasterId`,`v`.`TemplateName` AS `TemplateName`,`v`.`VoucherTypeId` AS `VoucherTypeId`,`t`.`TranId` AS `TranId` from (((`trandetails` `td` join `tran` `t` on((`t`.`TranId` = `td`.`TranId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) join `accountmaster` `a` on((`a`.`AccountMasterId` = `t`.`AccountMasterId`))) */;
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
/*!50001 VIEW `vwitemmaster` AS select `itemmaster`.`ItemMasterId` AS `ItemMasterId`,`itemmaster`.`ItemName` AS `ItemName`,`itemmaster`.`PurRate` AS `PurRate`,`itemmaster`.`SaleRate` AS `SaleRate`,`itemmaster`.`QuantityTypeId` AS `QuantityTypeId`,(select sum((`td`.`TotalQuantity` * `v`.`InOutValue`)) from ((`trandetails` `td` join `tran` `t` on((`t`.`TranId` = `td`.`TranId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) where (`td`.`ItemMasterId` = `itemmaster`.`ItemMasterId`)) AS `Stock` from `itemmaster` */;
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
/*!50001 VIEW `vwtranscation` AS select `t`.`TranId` AS `TranId`,`t`.`BillDate` AS `BillDate`,`t`.`BillNo` AS `BillNo`,`t`.`Remarks` AS `Remarks`,`t`.`Total` AS `Total`,`t`.`VoucherTypeId` AS `VoucherTypeId`,`a`.`AccountName` AS `AccountName`,`a`.`Address` AS `Address`,`v`.`Name` AS `VoucherName`,`v`.`TemplateName` AS `TemplateName` from ((`tran` `t` join `accountmaster` `a` on((`t`.`AccountMasterId` = `a`.`AccountMasterId`))) join `vouchertype` `v` on((`v`.`VoucherTypeId` = `t`.`VoucherTypeId`))) */;
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

-- Dump completed on 2018-09-01 15:17:18
