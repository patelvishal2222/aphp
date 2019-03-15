[{
        name: 'AccountMasterId',
        type: 'hideen',
		value:'AccountMasterId'
		
    },
    {
        name: 'Account Name',
        type: 'text',
		value:'AccountName',
		required:true
    },
    {
        name: 'Address',
        type: 'text',
		value:'Address'
    },
	{
        name: 'City',
        type: 'text',
		value:'City'
    },{
        name: 'Phone',
        type: 'text',
		value:'Phone'
    }
	,{
        name: 'State Name',
        type: 'ComboBox',
		value:'VirtualStateMaster',
		TableName:'StateMaster',
		Query:"select *  from StateMaster",
	   ComboQuery :"y.StateName for (x,y) in StateMaster track by y.StateMasterId",
	   ValidationMessage:"Select State Name",
	   visibility:true
		
    },
	
{
	name:"Group Name",
	type:"ComboBox",
	value:"VirtualGroupMaster",
	TableName:"GroupMaster",
	Query:"select *  from GroupMaster",
	ComboQuery :"y.GroupName for (x,y) in GroupMaster track by y.GroupMasterId",
	ValidationMessage:"Select Group Name",
	visibility:true
	
}
	
	 ];