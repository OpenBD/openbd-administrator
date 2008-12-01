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
	<cfparam name="cfxTagMessage" type="string" default="" />
	<cfparam name="cfxTagMessageType" type="string" default="" />
	<cfparam name="cfxTag" type="struct" default="#structNew()#" />
	<cfparam name="cfxTagAction" type="string" default="create" />
	
	<cfif structKeyExists(session, "cfxTag")>
		<cfset cfxTag = session.cfxTag />
		<cfset cfxAction = "update" />
		<cfset submitButtonAction = "Update" />
	<cfelse>
		<cfset cfxTag = structNew() />
		<cfset cfxTag.name = "" />
		<cfset cfxTag.displayname = "cfx_" />
		<cfset cfxTag.description = "" />
		<cfset cfxTag.class = "" />
		<cfset cfxAction = "create" />
		<cfset submitButtonAction = "Register" />
	</cfif>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validate(f) {
				var tagNameTest = /^([a-zA-Z0-9_-]+)$/;
				
				if (f.name.value.length == 0) {
					alert("Please enter the tag name");
					return false;
				} else if (f.name.value.substring(0,4).toLowerCase() != 'cfx_') {
					alert("Custom tag names must start with cfx_");
					return false;
				} else if (!tagNameTest.test(f.name.value)) {
					alert("Custom tag names may only include alphanumeric characters, hypens, and underscores");
					return false;
				} else if (f.class.value.length == 0) {
					alert("Please enter the class name");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Java CFX Tag</h3>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif cfxTagMessage is not "">
			<p class="#cfxTagMessageType#">#cfxTagMessage#</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form action="_controller.cfm?action=processJavaCFXForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="600">
			<tr>
				<td bgcolor="##f0f0f0"><strong><label for="name">Tag Name</label></strong></td>
				<td bgcolor="##ffffff">
					<input type="text" name="name" id="name" size="40" value="#cfxTag.displayname#" tabindex="1" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0"><strong><label for="class">Class Name</label></strong></td>
				<td bgcolor="##ffffff">
					<input type="text" name="class" id="class" size="40" value="#cfxTag.class#" tabindex="2" />
				</td>
			</tr>
			<tr>
				<td valign="top" bgcolor="##f0f0f0"><strong><label for="description">Description</label></strong></td>
				<td valign="top" bgcolor="##ffffff">
					<textarea name="description" id="description" cols="40" rows="6" tabindex="3">#cfxTag.description#</textarea>
				</td>
			</tr>
			<tr bgcolor="##f0f0f0">
				<td align="right">
					<input type="button" name="cancel" id="cancel" value="Cancel" 
							onclick="javascript:location.replace('cfxtags.cfm');" tabindex="4" />
				</td>
				<td>
					<input type="submit" name="submit" id="submit" value="#submitButtonAction# Java CFX Tag" tabindex="5" />
				</td>
			</tr>
		</table>
			<input type="hidden" name="existingCFXName" value="#cfxTag.name#" />
			<input type="hidden" name="cfxAction" value="#cfxAction#" />
		</form>
		
		<p><strong>Important Information Concerning Java Custom Tags</strong></p>
		
		<ul>
			<li>The Java class to be used as a custom tag must be in OpenBD's classpath prior to creating the custom tag.</li>
		</ul>
	</cfoutput>
</cfsavecontent>
