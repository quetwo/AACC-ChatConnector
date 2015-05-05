<cfcomponent persistent="true" >

	<cfproperty name="aaccID" fieldtype="id" generator="identity" >
	<cfproperty name="aaccSkillNum" fieldtype="column" type="numeric" >
	<cfproperty name="aaccSkillName" fieldtype="column" type="string" >
	<cfproperty name="chatWithName" fieldtype="column" type="string" >
	<cfproperty name="sampleChatTopic" fieldtype="column" type="string" >

</cfcomponent>