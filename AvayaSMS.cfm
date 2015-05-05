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

<cfparam name="form.toPhoneNumber" default="" >
<cfparam name="form.phoneNumber" default="" >
<cfparam name="form.message" default="" >

<cfsetting requesttimeout="1800" />

<cfset smsAccountLookup = entityload("smsInfo",{phNumber=form.toPhoneNumber},true)>

<cfif isDefined("smsAccountLookup")>
	
	<cfset getSession = entityload("smsSessions",{smsFrom=form.phoneNumber, smsTo=form.toPhoneNumber}, true)>
	<cfif isDefined("getSession")>
		<!--- check to see if the session is expired... --->
		<cftry>
			<cfscript>
				chatInfo = session.wsWebComm.UpdateAliveTime(getSession.getContactID(), getSession.getSessionKey());
			</cfscript>
			<cfcatch>
				<!--- session was ended.  lets open a new one --->
				<cfset entityDelete(getSession)>
				<cfset getSession = entityload("smsSessions",{smsFrom=form.phoneNumber, smsTo=form.toPhoneNumber}, true)>
				<cfset ormFlush()>
			</cfcatch>
		</cftry>
	</cfif>
	<cfif NOT isDefined("getSession")>
		<!--- this is the first time we are opening a session --->

		<cfscript>
			getSession = entityNew("smsSessions");
			getSession.setSmsFrom(form.phoneNumber);
			getSession.setSmsTo(form.toPhoneNumber);
			getSession.setDt(now());
			getSession.setSessionKey(session.sessionKey.getSessionKey());
			
			writeContact = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIContactWriteType");
			priority = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIContactPriority");
			requestDT = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIDateTime");
			loginResult = createObject("java","com.nortel.applications.ccmm.ci.webservices.AnonymousLoginResult");
			
			writeContact.setSkillsetID(smsAccountLookup.getSkillNumber());
			writeContact.setPriority(priority.Priority_3_Medium_High);
			writeContact.setText("");	
			writeContact.setSubject("SMS Session From: #form.phoneNumber#");

			loginResult.SessionKey = session.sessionKey.getSessionKey();
			loginResult.AnonymousID = session.sessionKey.getAnonymousID();

			customerKey = session.wsUtiltiy.GetAnonymousCustomerID(loginResult, "#form.phoneNumber#@cellphone.com", form.phoneNumber);
			getSession.setLastRead(0);
			contactID = session.wsCustomer.RequestTextChat(customerKey,writeContact,false,getSession.getSessionKey());
			getSession.setContactID(contactID);

			WebChatID = session.wsWebComm.createWebCommsSession(contactID,getSession.getSessionKey());
		</cfscript>

		<cfset entitySave(getSession)>

	<cfthread action="run" name="processLoop" sessionID="#getSession.getSessionID()#">
        <cfsetting requesttimeout="1800" />

		<cfscript>
			session.wsUtilityLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CIUtilityWsLocator");
			session.wsUtiltiy = session.wsUtilityLocator.getCIUtilityWsSoap();
			session.wsWebCommLocator = createObject("java","com.nortel.applications.ccmm.ci.webservices.CIWebCommsWsLocator");
			session.wsWebComm = session.wsWebCommLocator.getCIWebCommsWsSoap();

            chatTypes = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIChatMessageType");
            thisSession = entityLoadByPK("smsSessions",sessionID);


            curRun = true;
			
			lastRead = session.wsUtiltiy.GetServerTime();
			
			while(curRun)
			{
				sleep(1000);
				entityReload(thisSession);
				try
				{
					aliveTimer = session.wsWebComm.UpdateAliveTime(thisSession.getContactID(), thisSession.getSessionKey());

                    if (aliveTimer.getMilliseconds() GTE 0)
					{
						// this means we are connected to an agent. 
						chatMessages = session.wsWebComm.ReadChatMessage(thisSession.getContactID(),lastRead, false, thisSession.getSessionKey());
						lastRead = session.wsUtiltiy.GetServerTime();
						
						incomingMessages = chatMessages.getListOfChatMessages();

                        if (NOT isNull(incomingMessages))
						{
							for(i=1; i LTE ArrayLen(incomingMessages); i=i+1)
							{
								if(incomingMessages[i].getChatMessageType().toString() EQ chatTypes.Chat_Message_from_Agent.toString())
								{
									stripName = find("]",incomingMessages[i].getChatMessage());
									curMessage = Mid(incomingMessages[i].getChatMessage(),stripName+2,len(incomingMessages[i].getChatMessage())-stripName);
									sendSMSMessage(thisSession.getSmsFrom(),thisSession.getSmsTo(),curMessage); // have to break this out because of a cf bug
								}
							}
						}

						if (thisSession.hasWaitingMessages())
						{
							messagesToAgent = thisSession.getWaitingMessages();
							numMessages = ArrayLen(messagesToAgent);
							for(i=numMessages; i GT 0; i=i-1)
							{
								// send queued messages
								session.wsWebComm.WriteChatMessage(thisSession.getContactID(),"[#thisSession.getSmsFrom()#] #messagesToAgent[i].getMessage()#","",chatTypes.Chat_Message_from_Customer, thisSession.getSessionKey());
								thisSession.removeWaitingMessages(messagesToAgent[i]);
							}
							ormFlush();
						}
						
					}
				}
				catch(any e)
				{
                    curRun = false;
                    WriteLog(type="Error", file="smsThread.log", text="ERROR = #e.Detail# #e.message# #e.StackTrace#");
				}
				thisSession.setLastRead(lastRead.getMilliseconds());
				entitySave(thisSession);
				
			}
			entityDelete(thisSession);
		</cfscript>
		
	</cfthread>	
		
	</cfif>
	
	<cfset outgoingMessage = entityNew("smsMessages")>
	<cfset outgoingMessage.setMessage(form.message)>
	<cfset entitySave(outgoingMessage)>
	
	<cfset getSession.addWaitingMessages(outgoingMessage)>

	<cfset skillInSvc = session.wsSkillSet.isSkillsetInService(JavaCast("int",smsAccountLookup.getSkillNumber()),getsession.getSessionKey())>

	<cfif skillInSvc>
		<cfcontent type="text/xml"><?xml version="1.0" encoding="UTF-8"?><Response></Response></cfcontent>
	<cfelse>
		<cfcontent type="text/xml"><?xml version="1.0" encoding="UTF-8"?><Response><sms>The call center <cfoutput>#smsAccountLookup.getAppName()#</cfoutput> is not open at the moment. Your message has been queued.</sms></Response></cfcontent>
		<cfset sendSMSMessage(form.phoneNumber, form.toPhoneNumber, "The call center #smsAccountLookup.getAppName()# is not open at the moment. Your message has been queued.")>
	</cfif>

<cfelse>

	<cfcontent type="text/xml"><?xml version="1.0" encoding="UTF-8"?><Response><sms>An agent is not available at this number. Sorry.</sms></Response></cfcontent>
	<cfset sendSMSMessage(form.phoneNumber, form.toPhoneNumber, "An agent is not available at this number. Sorry.")>

</cfif>


<cffunction name="sendSMSMessage" access="package" >
	<cfargument name="sendTo">
	<cfargument name="sendFrom">
	<cfargument name="Body">

	<cfquery datasource="sms" name="sendInfo">
    SELECT * FROM ams
		WHERE phoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sendFrom#">
	</cfquery>

	<cfset requestedNumber = mid(sendInfo.phoneNumber,2,len(sendInfo.phoneNumber - 1))>
	<cfhttp url="https://messaging.avaya.com/API/account/#requestedNumber#/message" method="POST" result="messageInfo">
		<cfhttpparam type="header" name="AuthToken" value="#sendInfo.AuthToken#">
		<cfhttpparam type="formfield" name="To" value="#arguments.sendTo#">
		<cfhttpparam type="formfield" name="Body" value="#arguments.Body#">
	</cfhttp>


</cffunction>

