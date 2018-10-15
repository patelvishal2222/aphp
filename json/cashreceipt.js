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
	{
        name: 'Total',
        type: 'text',
		value:'Total'
    }
	 ]
	 
	 
	 
}
	 ;