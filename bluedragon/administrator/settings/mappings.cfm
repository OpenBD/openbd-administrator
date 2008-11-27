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
	<cfparam name="mappingMessage" type="string" default="" />
	<cfparam name="mappings" type="array" default="#arrayNew(1)#" />
	
	<cfif structKeyExists(session, "mapping")>
		<cfset mapping = session.mapping[1] />
		<cfset mappingAction = "update" />
	<cfelse>
		<cfset mapping = structNew() />
		<cfset mapping.name = "" />
		<cfset mapping.displayname = "" />
		<cfset mapping.directory = "" />
		<cfset mappingAction = "create" />
	</cfif>
	
	<cftry>
		<cfset mappings = Application.mapping.getMappings() />
		<cfcatch type="bluedragon.adminapi.mapping">
			<cfset mappingMessage = CFCATCH.Message />
			<cfset mappingMessageType = "error" />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validate(f) {
				if (f.name.value.length == 0) {
					alert("Please enter the logical path");
					return false;
				} else if (f.directory.value.length == 0) {
					alert("Please enter the directory path");
					return false;
				} else {
					return true;
				}
			}
			
			function deleteMapping(mappingName) {
				if (confirm("Are you sure you want to delete this mapping?")) {
					location.replace("_controller.cfm?action=deleteMapping&name=" + mappingName);
				}
			}
		</script>
		
		<h3>Directory Mappings</h3>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif mappingMessage is not "">
			<p class="#mappingMessageType#">#mappingMessage#</p>
		</cfif>

		<cfif arrayLen(mappings) gt 0>
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##f0f0f0">
				<td><strong>Actions</strong></td>
				<td><strong>Logical Path</strong></td>
				<td><strong>Directory Path</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(mappings)#">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="_controller.cfm?action=editMapping&name=#mappings[i].name#" alt="Edit Mapping" title="Edit Mapping">
						<img src="../images/pencil.png" border="0" width="16" height="16" />
					</a>
					<a href="_controller.cfm?action=verifyMapping&name=#mappings[i].name#" alt="Verify Mapping" title="Verify Mapping">
						<img src="../images/accept.png" border="0" width="16" height="16" />
					</a>
					<a href="javascript:void(0);" onclick="javascript:deleteMapping('#mappings[i].name#');" alt="Delete Mapping" title="Delete Mapping">
						<img src="../images/cancel.png" border="0" width="16" height="16" />
					</a>
				</td>
				<td><cfif structKeyExists(mappings[i], "displayname")>#mappings[i].displayname#<cfelse>#mappings[i].name#</cfif></td>
				<td>#mappings[i].directory#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<br />
		
		<form name="mappingForm" action="_controller.cfm?action=processMappingForm" method="post" 
				onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong><cfif mappingAction is "create">Add a<cfelse>Edit</cfif> Mapping</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="name">Logical Path</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="name" id="name" size="40" 
							value="<cfif structKeyExists(mapping, 'displayname')>#mapping.displayname#<cfelse>#mapping.name#</cfif>" 
							tabindex="1" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="directory">Directory Path</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="directory" id="directory" size="40" value="#mapping.directory#" tabindex="2" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" tabindex="3" />
				</td>
			</tr>
		</table>
			<input type="hidden" name="mappingAction" value="#mappingAction#" />
			<input type="hidden" name="existingMappingName" value="#mapping.name#">
		</form>
		
		<p><strong>Important Information Concerning Directory Paths for Mappings</strong></p>
		
		<ul>
			<li>
				When specifying a full physical path on UNIX-based systems (including GNU/Linux and Mac OS X), you must place 
				a "$" at the beginning of the path. For example:<br />
				$/usr/local/myPath
			</li>
			<li>
				A path beginning with "/" is interpreted as a relative path from the web application root directory, which 
				may be a subdirectory of the WEB-INF directory.
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "mapping", false) />
</cfsavecontent>
