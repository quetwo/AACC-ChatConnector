<cfcomponent persistent="true" >

	<cfproperty name="id" fieldtype="id" generator="identity" >
	<cfproperty name="appName" fieldtype="column" type="string" >
	<cfproperty name="phNumber" fieldtype="column" type="string" >
	<cfproperty name="skillNumber" fieldtype="column" type="numeric" >
	<cfproperty name="fwdPhone" fieldtype="column" type="string" >
	<cfproperty name="fwdDescription" fieldtype="column" type="string" >     

</cfcomponent>