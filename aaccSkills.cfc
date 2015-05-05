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
<cfcomponent persistent="true" >

	<cfproperty name="aaccID" fieldtype="id" generator="identity" >
	<cfproperty name="aaccSkillNum" fieldtype="column" type="numeric" >
	<cfproperty name="aaccSkillName" fieldtype="column" type="string" >
	<cfproperty name="chatWithName" fieldtype="column" type="string" >
	<cfproperty name="sampleChatTopic" fieldtype="column" type="string" >

</cfcomponent>