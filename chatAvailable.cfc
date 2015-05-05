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