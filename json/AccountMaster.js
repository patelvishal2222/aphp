[
{
	name:"AccountMasterId",
	type:"hideen",
	value:"AccountMasterId"
	
},
{
	name:"AccountName",
	type:"text",
	value:"AccountName"
},{
	name:"Address",
	type:"text",
	value:"Address"
}
,{
	name:"City",
	type:"text",
	value:"City"
}
,{
	name:"Phone",
	type:"text",
	value:"Phone"
},
{
	name:"Group Name",
	type:"ComboBox",
	value:"GroupMasterId",
	TableName:"GroupMaster",
	Query:"select *  from GroupMaster",
	ComboQuery :"y.GroupName for (x,y) in GroupMaster track by y.GroupMasterId",
	ValidationMessage:"Select Group Name"
	
}
];
