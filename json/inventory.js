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
	   
	   onchange:'Amount=Rate*TotalQuantity',
	   selectvalue:'{Rate:"PurRate",GstRate:"GstRate"}'
		
    }
	,
	{
        name: 'Length',
        type: 'text',
		value:'Length',
		Condition:'VirtualItemMaster.QuantityTypeId>=2',
		onchange:'Quantity=QuantityCountFormula(Length,Height,Width,VirtualItemMaster.QuantityTypeId )|TotalQuantity=Quantity*Nos |Amount=Rate*TotalQuantity'
    },
	{
        name: 'Height',
        type: 'text',
		value:'Height',
		Condition:'VirtualItemMaster.QuantityTypeId>=2',
		onchange:'Quantity=QuantityCountFormula(Length,Height,Width,VirtualItemMaster.QuantityTypeId )|TotalQuantity=Quantity*Nos |Amount=Rate*TotalQuantity'
    }
	,
	
	{
        name: 'Width',
        type: 'text',
		value:'Width',
		Condition:'VirtualItemMaster.QuantityTypeId==3',
		onchange:'Quantity=QuantityCountFormula(Length,Height,Width,VirtualItemMaster.QuantityTypeId )|TotalQuantity=Quantity*Nos |Amount=Rate*TotalQuantity'
    }
	,
	{
        name: 'Quantity',
        type: 'label',
		Condition:'VirtualItemMaster.QuantityTypeId>=2',
		value:'Quantity',
		
	
    }
	,
	
	{
        name: 'Nos',
        type: 'text',
		value:'Nos',
		Condition:'VirtualItemMaster.QuantityTypeId>=2',
		onchange:'TotalQuantity=Quantity*Nos|Amount=Rate*TotalQuantity'
		
    }
	,
	{
        name: 'TotalQuantity',
        type: 'label',
		value:'TotalQuantity',
		Condition:'VirtualItemMaster.QuantityTypeId>=2',
		onchange:'Amount=Rate*TotalQuantity'
		
    }
	,
	{
        name: 'TotalQuantity',
        type: 'text',
		value:'TotalQuantity',
		Condition:'VirtualItemMaster.QuantityTypeId<=1',
		onchange:'Amount=Rate*TotalQuantity'
		
    }
	,
	{
        name: 'Unit Name',
        type: 'ComboBox',
		value:'VirtualUnitMaster',
		TableName:'UnitMaster',
		Query:"select *  from UnitMaster",
	   ComboQuery :"y.Name for (x,y) in UnitMaster track by y.UnitMasterId",
	   ValidationMessage:"Select Unit Name",

		
    },
	{
        name: 'GstRate',
        type: 'text',
		value:'GstRate'
		
    }
	,
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
	,
	{
        name: 'Godown Name',
        type: 'ComboBox',
		value:'VirtualGodownMaster',
		TableName:'GodownMaster',
		Query:"select *  from GodownMaster",
	   ComboQuery :"y.GodownName for (x,y) in GodownMaster track by y.GodownMasterId",
	   ValidationMessage:"Select Godown Name",

		
    }
	
	,
	{
        name: 'ExpireDate',
        type: 'date',
		value:'ExpireDate'
	
		
    }
	,
	{
        name: 'BatchNo',
        type: 'text',
		value:'BatchNo'
		
		
    },
	{
        name: 'Remark',
        type: 'text',
		value:'Remark'
		
		
    }
	],
	TransctionTable:[
{ColumnName:'Srno',Caption: 'SrNo'},
{ColumnName:'VirtualItemMaster',Caption: 'ItemName',SubName:'ItemName' ,type:'subtype'},
{ColumnName:'Length',Caption: 'Length',type:'number2'},
{ColumnName:'Height',Caption: 'Height',type:'number2'},
{ColumnName:'Width',Caption: 'Width',type:'number2'},
{ColumnName:'Nos',Caption: 'Nos',type:'number2'},
{ColumnName:'Quantity',Caption: 'Quantity',type:'number2'},
{ColumnName:'TotalQuantity',Caption: 'TotalQuantity',type:'number2'},
{ColumnName:'VirtualUnitMaster',Caption: 'UnitName',SubName:'Name' ,type:'subtype'},
{ColumnName:'GstRate',Caption: 'GstRate',type:'number2'},
{ColumnName:'Rate',Caption: 'Rate',type:'number2'},
{ColumnName:'Amount',Caption: 'Amount',type:'number2',Aggregate:"sum"},	
{ColumnName:'VirtualGodownMaster',Caption: 'GodownName',SubName:'GodownName' ,type:'subtype'},
{ColumnName:'ExpireDate',Caption: 'ExpireDate',type:'date'},
{ColumnName:'BatchNo',Caption: 'BatchNo'},
{ColumnName:'Remark',Caption: 'Remark'}
]
	 
}
	 ;