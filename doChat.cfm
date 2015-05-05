<cfscript>
	writeContact = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIContactWriteType");
	priority = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIContactPriority");
	requestDT = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIDateTime");
	loginResult = createObject("java","com.nortel.applications.ccmm.ci.webservices.AnonymousLoginResult");
	
	writeContact.setSkillsetID(form.skill);
	writeContact.setPriority(priority.fromValue("Priority_3_Medium_High"));
	writeContact.setText(form.notes);
	writeContact.setSubject(form.topic);
	
	session.chatHistory = queryNew("dt,message");
	session.usersName = form.name;
	session.emailAddress = form.email; 
	session.connectedToAgent = false;

	loginResult.SessionKey = session.sessionKey.getSessionKey();
	loginResult.AnonymousID = session.sessionKey.getAnonymousID();	
	
	session.customerKey = session.wsUtiltiy.GetAnonymousCustomerID(loginResult,form.email,form.phNumber);
	session.lastReadTime = session.wsUtiltiy.GetServerTime();

    session.contactID = session.wsCustomer.RequestTextChat(session.customerKey,writeContact,false,session.sessionKey.getSessionKey());
    session.WebChatID = session.wsWebComm.createWebCommsSession(session.contactID,session.sessionKey.getSessionKey());
	
	session.topic = form.topic;
	session.needShowTopic = true;
</cfscript>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Chat with us</title>
</head>
<frameset rows="100,*,80" frameborder="no" border="0" framespacing="0">
  <frame src="doChat-controller.cfm" name="controller" id="controller" />
  <frame src="doChat-agent.cfm" name="mainFrame" id="mainFrame" title="mainFrame" />
  <frame src="doChat-client.cfm" name="bottomFrame"  noresize="noresize" id="bottomFrame" title="Your Message" scrolling="No"/>
</frameset>
<noframes><body>
</body></noframes>
</html>
