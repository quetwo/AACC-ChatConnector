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

	<cfset myChatType = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIChatMessageType")>
	
	<cfset curChatLog = session.wsWebComm.WriteChatMessage(session.contactID, "Session ended by #session.usersName#", "",myChatType.Session_Disconnected_by_Customer, session.sessionKey.getSessionKey())>
		
	<cflocation url="doChat-client.cfm" addtoken="false" >
	