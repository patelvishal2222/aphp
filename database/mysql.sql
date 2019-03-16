

INSERT INTO `menumaster` VALUES (7,1,'AccountDetail',NULL,'deluxstate',NULL,NULL,'select *, if((@balance:=@balance%2Bbal)>0,concat(round(@balance,2),\' Cr\'),concat( round(@balance*-1,2),\' Dr\')) as Balance from vwaccountdetails join (Select @balance:=0) x where AccountMasterId={{UniqueId}}',NULL)
