<cfsilent>
	<cfparam name="cfxTagMessage" type="string" default="" />
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
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif cfxTagMessage is not "">
			<p class="message">#cfxTagMessage#</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(errorFields)#">
				<li>#errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form action="_controller.cfm?action=processJavaCFXForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="600">
			<tr>
				<td bgcolor="##f0f0f0"><strong>Tag Name</strong></td>
				<td bgcolor="##ffffff"><input type="text" name="name" size="40" value="#cfxTag.displayname#" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0"><strong>Class Name</strong></td>
				<td bgcolor="##ffffff"><input type="text" name="class" size="40" value="#cfxTag.class#" /></td>
			</tr>
			<tr>
				<td valign="top" bgcolor="##f0f0f0"><strong>Description</strong></td>
				<td valign="top" bgcolor="##ffffff">
					<textarea name="description" cols="40" rows="6">#cfxTag.description#</textarea>
				</td>
			</tr>
			<tr bgcolor="##f0f0f0">
				<td align="right"><input type="button" name="cancel" value="Cancel" onclick="javascript:location.replace('cfxtags.cfm');"></td>
				<td><input type="submit" name="submit" value="#submitButtonAction# Java CFX Tag" /></td>
			</tr>
		</table>
			<input type="hidden" name="existingCFXName" value="#cfxTag.name#" />
			<input type="hidden" name="cfxAction" value="#cfxAction#" />
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
