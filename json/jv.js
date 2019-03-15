{
	TranscationEntry:[{
        name: 'TranId',
        type: 'hideen',
		value:'TranId'
    },
    {
        name1: 'Bill No',
        type: 'BillNoBillDate',
		value1:'BillNo',
		name2: 'BillDate',
		value2:'BillDate'
    },
    
	
	
    {
        name: 'Refernce',
        type: 'text',
		value:'Remarks'
    },
	
	 ],
	 
	 TransctionModel:[
	 {
        name: 'CrDr Name',
        type: 'ComboBox',
		value:'VirtualCrDrMaster',
		TableName:'CrDrMaster',
		Query:"select *  from CrDrMaster",
	   ComboQuery :"y.CrDrName for (x,y) in CrDrMaster track by y.CrDrMasterId",
	   ValidationMessage:"Select CrDr Type"
	   
		
    }
	,
	{
        name: 'Account Name',
        type: 'ComboBox',
		value:'VirtualAccountMaster',
		TableName:'AccountMaster',
		Query:"select *  from AccountMaster",
	   ComboQuery :"y.AccountName for (x,y) in AccountMaster track by y.AccountMasterId",
	   ValidationMessage:"Select Account Name"
	   
		
    }
	,
	{
        name: 'Amount',
        type: 'text',
		value:'Amount',
		operation:'TotalQuantity*Rate'
		
    }
	],
	TransctionTable:[
{ColumnName:'Srno',Caption: 'SrNo'},
{ColumnName:'VirtualCrDrMaster',Caption: 'CrDr Type',SubName:'CrDrName' ,type:'subtype'},
{ColumnName:'VirtualAccountMaster',Caption: 'Account Name',SubName:'AccountName' ,type:'subtype'},

{ColumnName:'Amount',Caption: 'Debite',type:'number2',Aggregate:"sum",Condition:"VirtualCrDrMaster.CrDrMasterId==2"}	,
{ColumnName:'Amount',Caption: 'Credit',type:'number2',Aggregate:"sum",Condition:"VirtualCrDrMaster.CrDrMasterId==1"}	

]
	 
}
	 ;