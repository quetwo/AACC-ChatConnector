<!--- 

    Copyright 2015 Michigan State University, Board of Trustees

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

--->

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