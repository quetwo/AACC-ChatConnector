<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Agent Console</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link href="assets/css/bootstrap.css" rel="stylesheet">
	<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
	
	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

</head>

<body>
<div class="container">
	<cfif session.connectedToAgent EQ false>
		<div class="alert alert-block alert-info">
			<h4 class="alert-heading">Please wait!</h4>
			We are currently routing your chat request to the next available representative.  You will see the chat transcript here when an agent is assigned to you.
		</div>
	<cfelse>
		<cfif session.needShowTopic EQ true>
			<cfset session.needShowTopic = false>
			<cfset myChatType = createObject("java","com.nortel.applications.ccmm.ci.datatypes.CIChatMessageType")>
			<cfset curChatLog = session.wsWebComm.WriteChatMessage(session.contactID, "Chat Session Topic : #session.topic#", "",myChatType.Chat_Message_from_Customer, session.sessionKey.getSessionKey())>
		</cfif>
	</cfif>
	<div class="well">
	<table class="table table-striped">
		<thead>
		  <tr>
		    <th>Date</td>
		    <th>Message</td>
		  </tr>
	  	</thead>
		<tbody>
		<cfloop query="session.chatHistory" ><cfoutput>
		  <tr>
		    <td width="20%">#TimeFormat(session.chatHistory.dt,"medium")#</td>
			<td>#session.chatHistory.message#</td>
		  </tr></cfoutput>
		</cfloop>
		</tbody>
	</table>
	</div>
</div>
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="assets/js/jquery.js"></script>
    <script src="assets/js/bootstrap-transition.js"></script>
    <script src="assets/js/bootstrap-alert.js"></script>
    <script src="assets/js/bootstrap-modal.js"></script>
    <script src="assets/js/bootstrap-dropdown.js"></script>
    <script src="assets/js/bootstrap-scrollspy.js"></script>
    <script src="assets/js/bootstrap-tab.js"></script>
    <script src="assets/js/bootstrap-tooltip.js"></script>
    <script src="assets/js/bootstrap-popover.js"></script>
    <script src="assets/js/bootstrap-button.js"></script>
    <script src="assets/js/bootstrap-collapse.js"></script>
    <script src="assets/js/bootstrap-carousel.js"></script>
    <script src="assets/js/bootstrap-typeahead.js"></script>

</body>
</html>
