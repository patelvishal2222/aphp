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
        name: 'Address',
        type: 'subLabel',
		value:'VirtualAccountMaster',
		subvalue:'Address'
    }
	,
    {
        name: 'City',
        type: 'subLabel',
		value:'VirtualAccountMaster',
		subvalue:'City'
    }
	,
    {
        name: 'Phone',
        type: 'subLabel',
		value:'VirtualAccountMaster',
		subvalue:'Phone'
    },
	
    {
        name: 'Refernce',
        type: 'text',
		value:'Remarks'
    },
	
	 ],
	 
	 TransctionModel:[
	{
        name: 'Item Name',
        type: 'ComboBox',
		value:'VirtualItemMaster',
		TableName:'ItemMaster',
		Query:"select *  from ItemMaster",
	   ComboQuery :"y.ItemName for (x,y) in ItemMaster track by y.ItemMasterId",
	   ValidationMessage:"Select Item Name",
	   selectvalue:"Rate,PurRate"
		
    }
	,
	{
        name: 'TotalQuantity',
        type: 'text',
		value:'TotalQuantity',
		
		operation:'Nos*Quantity'
		
    },
	
	{
        name: 'Rate',
        type: 'text',
		value:'Rate',
		onchange:'Amount=Rate*TotalQuantity'
    }
	,
	{
        name: 'Amount',
        type: 'label',
		value:'Amount',
		operation:'TotalQuantity*Rate'
		
    }
	],
	TransctionTable:[
{ColumnName:'Srno',Caption: 'SrNo'},
{ColumnName:'VirtualItemMaster',Caption: 'ItemName',SubName:'ItemName' ,type:'subtype'},

{ColumnName:'TotalQuantity',Caption: 'TotalQuantity',type:'number2'},
{ColumnName:'Rate',Caption: 'Rate',type:'number2'},
{ColumnName:'Amount',Caption: 'Amount',type:'number2'}	

]
	 
}
	 ;
