<cfsilent>
	<cfparam name="mappingMessage" type="string" default="" />
	<cfparam name="mappings" type="array" default="#arrayNew(1)#" />
	
	<cfif structKeyExists(session, "mapping")>
		<cfset mapping = session.mapping[1] />
		<cfset mappingAction = "update" />
	<cfelse>
		<cfset mapping = structNew() />
		<cfset mapping.name = "" />
		<cfset mapping.directory = "" />
		<cfset mappingAction = "create" />
	</cfif>
	
	<cftry>
		<cfset mappings = Application.mapping.getMappings() />
		<cfcatch type="bluedragon.adminapi.mapping">
			<cfset mappingMessage = CFCATCH.Message />
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
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif mappingMessage is not "">
			<p class="message">#mappingMessage#</p>
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
					<a href="_controller.cfm?action=editMapping&name=#mappings[i].name#" alt="Edit Mapping" title="Edit Mapping"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyMapping&name=#mappings[i].name#" alt="Verify Mapping" title="Verify Mapping"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteMapping('#mappings[i].name#');" alt="Delete Mapping" title="Delete Mapping"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#mappings[i].name#</td>
				<td>#mappings[i].directory#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="mappingForm" action="_controller.cfm?action=processMappingForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong><cfif mappingAction is "create">Add a<cfelse>Edit</cfif> Mapping</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Logical Path</td>
				<td bgcolor="##ffffff">
					<input type="text" name="name" size="40" value="#mapping.name#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Directory Path</td>
				<td bgcolor="##ffffff">
					<input type="text" name="directory" size="40" value="#mapping.directory#" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
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
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "mapping", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
