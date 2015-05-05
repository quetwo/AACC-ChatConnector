<cfparam name="url.email" default="false">
<cfif url.email>

	<cfset chatInfo = session.wsWebComm.RequestChatHistory(session.contactID, session.emailAddress, session.sessionKey.getSessionKey())>
	
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Chat Finished</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link href="assets/css/bootstrap.css" rel="stylesheet">
	<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
	
	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
</head>

<body onload="parent.bottomFrame.location='doChat-client-finished.cfm'">

<div class="container">

	<div class="alert alert-block <cfif url.email>alert-success</cfif>">
		<h4 class="alert-heading">Chat Ended</h4>
		This chat session has concluded. <cfif url.email> A copy of the transcript has been emailed to <cfoutput>#session.emailAddress#</cfoutput><cfelse>If you wish to get an email transcript, please click on the link below.</cfif>
	</div>
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

<a class="btn btn-primary" href="javascript:top.close()">Close Window</a>

<cfif NOT url.email><a class="btn" href="doChat-agent-finished.cfm?email=true">Email me a copy of this transcript</a></cfif>

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