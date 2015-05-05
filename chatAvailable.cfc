<cfcomponent>

	<cffunction name="getChatAvail" access="remote" description="Returns the availability of a multimedia agent" output="no" returntype="boolean">
    	<cfargument name="skillNumber" default="0" required="yes" type="numeric" hint="AACC Skillset Number">
        
        <cftry>   
	        <cfset skillInSvc = session.wsSkillSet.isSkillsetInService(arguments.skillNumber, session.sessionKey.getSessionKey())>
            <cfcatch type="any">
            	<cfreturn false>   <!--- fail closed --->
            </cfcatch>
        </cftry>
        <cfreturn skillInSvc>
    </cffunction>


</cfcomponent>