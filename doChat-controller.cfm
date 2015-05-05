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

<cfscript>
	myChatType = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIChatMessageType");
	isConnected = true;
	onLoadJS = 'parent.mainFrame.location.reload()';
	
	try
	{
		chatInfo = session.wsWebComm.UpdateAliveTime(session.contactID, session.sessionKey.getSessionKey());
	}
	catch (any e)
	{
		isConnected = false;
		onLoadJS = "parent.mainFrame.location='doChat-agent-finished.cfm'";
	}
	
    ServerTime = session.wsUtiltiy.GetServerTime();      
		
</cfscript>


<cfif isConnected>

	<cfif (chatInfo.getMilliseconds() LT 0)>
		<cfset session.connectedToAgent = false>
	<cfelse>
		<cfset session.connectedToAgent = true>
	</cfif>
	
	<cfset session.chatLog = session.wsWebComm.ReadChatMessage(session.contactID, session.lastReadTime, false, session.sessionKey.getSessionKey())>
	
	<cfset session.lastReadTime = ServerTime>
	
	<cfset incomingMessages = session.chatLog.getListOfChatMessages()>
	
	<cfif NOT isNull(incomingMessages)>
		
		<cfloop array="#incomingMessages#" index="message">
			<cfif message.getChatMessageType().toString() EQ myChatType.Chat_Message_from_Agent.toString()>
				<cfset queryAddRow(session.chatHistory,1)>
				<cfset querySetCell(session.chatHistory,"dt",now())>
				<cfset querySetCell(session.chatHistory,"message",message.getChatMessage())>
			</cfif>
			<cfif message.getChatMessageType().toString() EQ myChatType.Chat_Message_from_Customer.toString()>
				<cfset queryAddRow(session.chatHistory,1)>
				<cfset querySetCell(session.chatHistory,"dt",now())>
				<cfset querySetCell(session.chatHistory,"message",message.getChatMessage())>
			</cfif>
			<cfif message.getChatMessageType().toString() EQ myChatType.Page_Pushed_by_Agent.toString()>
                <cfset queryAddRow(session.chatHistory,1)>
                <cfset querySetCell(session.chatHistory,"dt",now())>
                <cfset querySetCell(session.chatHistory,"message","<a target='_blank' href='#message.getHiddenMessage()#'>#message.getChatMessage()#</a>")>
            </cfif>
		</cfloop> 
		
		<cfset onLoadJS = "parent.mainFrame.location.reload()">
		
	<cfelse>
		
		<cfset onLoadJS = "">
				
	</cfif>
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<cfif isConnected><meta http-equiv="refresh" content="3"></cfif>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Agent Console</title>
</head>

<cfoutput><body onload="#onLoadJS#">

</body></cfoutput>
</html>