<cfcomponent persistent="true" >

	<cfproperty name="sessionID" fieldtype="id" generator="identity" >
	<cfproperty name="smsFrom" fieldtype="column" type="string" >
	<cfproperty name="smsTo" fieldtype="column" type="string" >
	<cfproperty name="lastRead" fieldtype="column" type="numeric" ormtype="long" >
	<cfproperty name="contactID" fieldtype="column" type="numeric" ormtype="long" >
	<cfproperty name="sessionKey" fieldtype="column" type="string" ormtype="string" >
	<cfproperty name="dt" fieldtype="column" type="date" ormtype="timestamp" >     
	
	<cfproperty name="waitingMessages" fieldtype="one-to-many" type="array" fkcolumn="sessionID" cfc="smsMessages" cascade="all-delete-orphan"> 

</cfcomponent>