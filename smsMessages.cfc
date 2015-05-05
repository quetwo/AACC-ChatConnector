<cfcomponent persistent="true" >
	
	<cfproperty name="messageid" fieldtype="id" generator="identity" >
	<cfproperty name="sessionID" fieldtype="many-to-one" fkcolumn="sessionID" cfc="smsSessions" >
	
	<cfproperty name="message" fieldtype="column" type="string" >  

</cfcomponent>