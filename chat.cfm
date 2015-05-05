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

<cfparam name="url.skill" default="0" type="numeric">

<cfif url.skill EQ 0>
    <cfset skillList = session.wsSkillSet.GetAllWebSkillsets(session.sessionKey.getSessionKey())>
	<cfset chatWithName = "Us">
	<cfset sampleChatTopic = "Your Question">
<cfelse>
   <cfset skillInSvc = session.wsSkillSet.isSkillsetInService(JavaCast("int",url.skill),session.sessionKey.getSessionKey())>
   <cfset numQueuedInSkill = session.wsUtiltiy.GetTotalQueuedToSkillset(session.sessionKey.getSessionKey(),JavaCast("int",url.skill))>
   <cfset skillInfo = entityLoad("aaccSkills" ,{aaccSkillNum=url.skill}, true)>
   <cfset chatWithName = skillInfo.getchatWithName()>
   <cfset sampleChatTopic = skillInfo.getsampleChatTopic()> 
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Chat with <cfoutput>#chatWithName#</cfoutput></title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<link href="assets/css/bootstrap.css" rel="stylesheet">
	<link href="assets/css/bootstrap-responsive.css" rel="stylesheet">
	
	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	
	<script>
		function validateForm(valForm)
		{
			var validForm = true;
			if (valForm.name.value == '')
			{
				document.getElementById("errorAlert").className = "alert alert-error";
				document.getElementById("fldName").className += " error";
				validForm = false;				
			}
			if (valForm.phNumber.value == '')
			{
				document.getElementById("errorAlert").className = "alert alert-error";
				document.getElementById("fldPhNumber").className += " error";
				validForm = false;				
			}
			if (valForm.email.value == '')
			{
				document.getElementById("errorAlert").className = "alert alert-error";
				document.getElementById("fldEmail").className += " error";
				validForm = false;				
			}
			if (valForm.topic.value == '')
			{
				document.getElementById("errorAlert").className = "alert alert-error";
				document.getElementById("fldTopic").className += " error";
				validForm = false;				
			}
			return validForm;
		}
	</script>
</head>

<body>

<div class="container">
	
	<h1>Chat with <cfoutput>#chatWithName#</cfoutput></h1>
	
	<div class="hide" id="errorAlert">
		<strong>Error!</strong> Please make sure to fill out this entire form. You can not leave any fields blank.
	</div>

<cfif url.skill NEQ 0>	
    <cfif NOT skillInSvc>
    <br />
	<div class="alert alert-error">
		<h4><i class="icon-exclamation-sign"></i> No Representatives Available</h4> There are no representatives currently available in to help you at this time.  Your chat request may not be fulfilled in a timely manner.
	</div>
    </cfif>
    <cfif numQueuedInSkill GT 0>
    <br />
	<div class="alert alert-info">
		<h4><i class="icon-time"></i> Queue Time</h4> There are currently <cfoutput>#numQueuedInSkill#</cfoutput> customers currently in queue.
	</div>
    </cfif>
</cfif>	
	<form class="well form-horizontal" name="form1" method="post" action="doChat.cfm" onsubmit="return validateForm(this)" >
	  <fieldset>
	  	<div class="control-group" id="fldName">
	  		<label class="control-label" for="name">Your Name:</label>
			<div class="controls">
				<input type="text" name="name" id="name" placeholder="Sparty Smith" />
			</div>
	  	</div>
		
	  	<div class="control-group" id="fldPhNumber">
	  		<label class="control-label" for="phNumber">Your Phone Number:</label>
			<div class="controls">
				<input type="text" name="phNumber" id="phNumber" placeholder="517-355-1855"  />
			</div>
	  	</div>
		
		<div class="control-group" id="fldEmail">
	  		<label class="control-label" for="email">Your Email Address:</label>
			<div class="controls">
				<input type="text" name="email" id="email" placeholder="sparty@msu.edu" />
			</div>
	  	</div>
        <cfif url.skill NEQ 0>
	        <input type="hidden" name="skill" value="<cfoutput>#url.skill#</cfoutput>">
    	<cfelse>
            <div class="control-group">
                <label class="control-label" for="skill">Agent Requested:</label>
                <div class="controls">
                    <select name="skill" id="skill">
                    <cfloop array="#skillLIst.getSkillsetList()#" index="x">
                        <cfoutput><option value="#x.getID()#">#x.getName()#</option></cfoutput>				
                    </cfloop> 
                </select>
                </div>
            </div>        
        </cfif>
		<div class="control-group" id="fldTopic">
	  		<label class="control-label" for="topic">Chat Topic:</label>
			<div class="controls">
				<input type="text" name="topic" id="topic" placeholder="<cfoutput>#sampleChatTopic#</cfoutput>" />
			</div>
	  	</div>
			<input type="hidden" name="notes" value="">

		<div class="form-actions">
			<input class="btn btn-primary" type="submit" name="button" id="button" value="Start Chat" />
			<a class="btn" href="javascript:self.close()">Cancel</a>		
		</div>
		
	  </fieldset>
	</form>
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
