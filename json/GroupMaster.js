[{
        name: 'GroupMasterId',
        type: 'hideen',
		value:'GroupMasterId'
		
    },
    {
        name: 'Group Name',
        type: 'text',
		value:'GroupName',
		required:true
    },
	{
        name: 'Annual Name',
        type: 'ComboBox',
		value:'VirtualAnnualMaster',
		TableName:'AnnualMaster',
		Query:"select *  from AnnualMaster",
	   ComboQuery :"y.AnnualName for (x,y) in AnnualMaster track by y.AnnualMasterId",
	   ValidationMessage:"Select Annual Name"
		
    },
	{
        name: 'CrDr Name',
        type: 'ComboBox',
		value:'VirtualCrDrMaster',
		TableName:'CrDrMaster',
		Query:"select *  from CrDrMaster",
	   ComboQuery :"y.CrDrName for (x,y) in CrDrMaster track by y.CrDrMasterId",
	   ValidationMessage:"Select CrDr Name"
		
    }
];