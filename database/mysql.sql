

INSERT INTO `menumaster` VALUES (7,1,'AccountDetail',NULL,'deluxstate',NULL,NULL,'select *, if((@balance:=@balance%2Bbal)>0,concat(round(@balance,2),\' Cr\'),concat( round(@balance*-1,2),\' Dr\')) as Balance from vwaccountdetails join (Select @balance:=0) x where AccountMasterId={{UniqueId}}',NULL)
INSERT INTO `menumaster` VALUES (8,1,'ItemDetail',NULL,'deluxstate',NULL,NULL,'select * ,@balance:=@balance%2BStock  as StockQty from vwitemdetails join (Select @balance:=0) x  where ItemMasterId=={{UniqueId}}',NULL)
