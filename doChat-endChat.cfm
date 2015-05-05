	<cfset myChatType = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIChatMessageType")>
	
	<cfset curChatLog = session.wsWebComm.WriteChatMessage(session.contactID, "Session ended by #session.usersName#", "",myChatType.Session_Disconnected_by_Customer, session.sessionKey.getSessionKey())>
		
	<cflocation url="doChat-client.cfm" addtoken="false" >
	