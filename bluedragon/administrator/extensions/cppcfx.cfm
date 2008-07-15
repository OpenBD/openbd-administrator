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
		<cfset cfxTag.module = "" />
		<cfset cfxTag.function = "" />
		<cfset cfxTag.keeploaded = true />
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
				} else if (f.module.value.length == 0) {
					alert("Please enter the class name");
					return false;
				} else if (f.function.value.length == 0) {
					alert("Please enter the function name");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>C++ CFX Tag</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif cfxTagMessage is not "">
			<p class="message">#cfxTagMessage#</p>
		</cfif>
		
		<form action="_controller.cfm?action=processCPPCFXForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="600">
			<tr>
				<td bgcolor="##f0f0f0"><strong>Tag Name</strong></td>
				<td bgcolor="##ffffff"><input type="text" name="name" size="40" value="#cfxTag.displayname#" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0"><strong>Module Name</strong></td>
				<td bgcolor="##ffffff"><input type="text" name="module" size="40" value="#cfxTag.module#" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0"><strong>Function Name</strong></td>
				<td bgcolor="##ffffff"><input type="text" name="function" size="40" value="#cfxTag.function#" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0"><strong>Keep Loaded</strong></td>
				<td bgcolor="##ffffff">
					<input type="radio" name="keeploaded" value="true"<cfif cfxTag.keeploaded> checked="true"</cfif> />Yes&nbsp;
					<input type="radio" name="keeploaded" value="false"<cfif not cfxTag.keeploaded> checked="true"</cfif> />No
				</td>
			</tr>
			<tr>
				<td valign="top" bgcolor="##f0f0f0"><strong>Description</strong></td>
				<td valign="top" bgcolor="##ffffff">
					<textarea name="description" cols="40" rows="6">#cfxTag.description#</textarea>
				</td>
			</tr>
			<tr bgcolor="##f0f0f0">
				<td align="right"><input type="button" name="cancel" value="Cancel" onclick="javascript:location.replace('cfxtags.cfm');"></td>
				<td><input type="submit" name="submit" value="#submitButtonAction# C++ CFX Tag" /></td>
			</tr>
		</table>
			<input type="hidden" name="existingCFXName" value="#cfxTag.name#" />
			<input type="hidden" name="cfxAction" value="#cfxAction#" />
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
