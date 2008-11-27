<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Administrator.

	The Open BlueDragon Administrator is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Administrator is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Administrator.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfsilent>
	<cfparam name="jvmMessage" type="string" default="" />
	
	<cfset jvmProps = structNew() />
	
	<cftry>
		<cfset jvmProps = Application.serverSettings.getJVMProperties() />
		<cfcatch type="any">
			<cfset jvmMessage = CFCATCH.Message />
			<cfset jvmMessageType = "error" />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>Java Virtual Machine (JVM) Properties</h3>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif jvmMessage is not "">
			<p class="#jvmMessageType#">#jvmMessage#</p>
		</cfif>
		
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td><strong>Property Name</strong></td>
				<td><strong>Property Value</strong></td>
			</tr>
		<cfloop collection="#jvmProps#" item="prop">
			<tr>
				<td bgcolor="##f0f0f0">#prop#</td>
				<td bgcolor="##ffffff">#jvmProps[prop]#</td>
			</tr>
		</cfloop>
		</table>
	</cfoutput>
</cfsavecontent>
