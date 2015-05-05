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

	<cfproperty name="sessionID" fieldtype="id" generator="identity" >
	<cfproperty name="smsFrom" fieldtype="column" type="string" >
	<cfproperty name="smsTo" fieldtype="column" type="string" >
	<cfproperty name="lastRead" fieldtype="column" type="numeric" ormtype="long" >
	<cfproperty name="contactID" fieldtype="column" type="numeric" ormtype="long" >
	<cfproperty name="sessionKey" fieldtype="column" type="string" ormtype="string" >
	<cfproperty name="dt" fieldtype="column" type="date" ormtype="timestamp" >     
	
	<cfproperty name="waitingMessages" fieldtype="one-to-many" type="array" fkcolumn="sessionID" cfc="smsMessages" cascade="all-delete-orphan"> 

</cfcomponent>