<cfsilent>
	<cfparam name="customTagMessage" type="string" default="" />
	<cfparam name="customTagPaths" type="array" default="#arrayNew(1)#" />
	<cfparam name="customTagPath" type="string" default="" />
	<cfparam name="customTagPathAction" type="string" default="create" />
	
	<cftry>
		<cfset customTagPaths = Application.extensions.getCustomTagPaths() />
		<cfcatch type="bluedragon.adminapi.extensions">
			<cfset customTagPaths = arrayNew(1) />
			<cfset customTagMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function editCustomTagPath(path) {
				var f = document.forms.customTagPathForm;
				
				document.getElementById('actionHeader').innerHTML = 'Edit';
				f.directory.value = path;
				f.customTagPathAction = "update";
				f.existingCustomTagPath = path;
			}
			
			function resetCustomTagPathForm() {
				var f = document.forms.customTagPathForm;
				
				document.getElementById('actionHeader').innerHTML = 'Add a';
				f.directory.value = "";
				f.customTagPathAction = "create";
				f.existingCustomTagPath = "";
			}
			
			function deleteCustomTagPath(path) {
				if(confirm("Are you sure you want to delete this custom tag path?")) {
					location.replace("_controller.cfm?action=deleteCustomTagPath&directory=" + path);
				}
			}
			
			function validate(f) {
				if (f.directory.value.length == 0) {
					alert("Please enter a valid directory path");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Custom Tag Paths</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif customTagMessage is not "">
			<p class="message">#customTagMessage#</p>
		</cfif>
		
		<cfif arrayLen(customTagPaths) gt 0>
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##f0f0f0">
				<td><strong>Actions</strong></td>
				<td><strong>Custom Tag Path</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(customTagPaths)#">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="javascript:void(0);" onclick="javascript:editCustomTagPath('#customTagPaths[i]#')" alt="Edit Custom Tag Path" title="Edit Custom Tag Path"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyCustomTagPath&directory=#customTagPaths[i]#" alt="Verify Custom Tag Path" title="Verify Custom Tag Path"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteCustomTagPath('#customTagPaths[i]#');" alt="Delete Custom Tag Path" title="Delete Custom Tag Path"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#customTagPaths[i]#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<h3><span id="actionHeader">Add a</span> Custom Tag Path</h3>
		
		<form name="customTagPathForm" action="_controller.cfm?action=processCustomTagPathForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td align="right" bgcolor="##f0f0f0">Custom Tag Path</td>
				<td bgcolor="##ffffff">
					<input type="text" name="directory" size="40" value="#customTagPath#" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="button" name="reset" value="Reset" onclick="javascript:resetCustomTagPathForm();" />
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
			<input type="hidden" name="customTagPathAction" value="#customTagPathAction#" />
			<input type="hidden" name="existingCustomTagPath" value="#customTagPath#">
		</form>
		
		<p><strong>Important Information Concerning Custom Tag Paths</strong></p>
		
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
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "mapping", false) />
</cfsavecontent>
