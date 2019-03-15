[{
        name: 'ItemMasterId',
        type: 'hideen',
		value:'ItemMasterId'
    },
    {
        name: 'Item Name',
        type: 'text',
		value:'ItemName'
    },
    {
        name: 'Purchase Rate',
        type: 'text',
		value:'PurRate'
    },
	{
        name: 'Sale Rate',
        type: 'text',
		value:'SaleRate'
    },
	{
	   name: 'Quantity Type',
        type: 'ComboBox',
		value:'VirtualQuantityType',
		TableName:'QuantityType',
		Query:"select *  from QuantityType",
	   ComboQuery :"y.Name for (x,y) in QuantityType track by y.QuantityTypeId",
	   ValidationMessage:"Select Quantity Type"
		
    },
	{
        name: 'Gst Rate',
        type: 'text',
		value:'GstRate',
		visibility:false
    }
	 ];