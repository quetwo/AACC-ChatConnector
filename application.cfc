<cfcomponent>
	
<cfset This.name = "aaccChatService"> 
<cfset This.Sessionmanagement=true> 
<cfset This.Sessiontimeout="#createtimespan(0,0,30,0)#"> 
<cfset This.applicationtimeout="#createtimespan(0,1,0,0)#"> 

<cfset this.ormenabled = "true"> 
<cfset this.ormsettings={datasource="sms", dbcreate="update", logSQL="false"}>


<cffunction name="onSessionStart" returntype="void" >
     <cfset session.wsUtilityLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CIUtilityWsLocator")>
	<cfset session.wsUtiltiy = session.wsUtilityLocator.getCIUtilityWsSoap()>
	<cfset session.sessionkey = session.wsUtiltiy.GetAnonymousSessionKey()>
	<cfset session.wsSkillSetLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CISkillsetWsLocator")>
	<cfset session.wsSkillSet = session.wsSkillSetLocator.getCISkillsetWsSoap()> 
	<cfset session.wsCustomerLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CICustomerWsLocator")>
	<cfset session.wsCustomer = session.wsCustomerLocator.getCICustomerWsSoap()>
	<cfset session.wsWebCommLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CIWebCommsWsLocator")>
	<cfset session.wsWebComm = session.wsWebCommLocator.getCIWebCommsWsSoap()>		

</cffunction> 

<cfif isDefined("url.resetSession")>
	<cfset onSessionStart()>
</cfif>


</cfcomponent>