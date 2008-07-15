<cfsilent>
	<cfparam name="cppTagsMessage" type="string" default="" />
	<cfparam name="javaTagsMessage" type="string" default="" />
	<cfparam name="cppTags" type="array" default="#arrayNew(1)#" />
	<cfparam name="javaTags" type="array" default="#arrayNew(1)#" />
	
	<cftry>
		<cfset cppTags = Application.extensions.getCPPCFX() />
		<cfcatch type="bluedragon.adminapi.extensions">
			<cfset cppTagsMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfset javaTags = Application.extensions.getJavaCFX() />
		<cfcatch type="bluedragon.adminapi.extensions">
			<cfset javaTagsMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function deleteCFXTag(tag, type) {
				if(confirm("Are you sure you want to delete this CFX tag?")) {
					if (type == 'java') {
						location.replace("_controller.cfm?action=deleteJavaCFXTag&name=" + tag);
					} else if (type == 'cpp') {
						location.replace("_controller.cfm?action=deleteCPPCFXTag&name=" + tag);
					}
				}
			}
		</script>
		
		<h3>CFX Tags</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif cppTagsMessage is not "">
			<p class="message">#cppTagsMessage#</p>
		</cfif>
		
		<cfif javaTagsMessage is not "">
			<p class="message">#javaTagsMessage#</p>
		</cfif>
		
		<cfif arrayLen(cppTags) gt 0 or arrayLen(javaTags) gt 0>
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="100%">
			<tr bgcolor="##f0f0f0">
				<td><strong>Actions</strong></td>
				<td><strong>Tag Name</strong></td>
				<td><strong>Type</strong></td>
				<td><strong>Module/Class</strong></td>
				<td><strong>Description</strong></td>
			</tr>
	<cfif arrayLen(cppTags) gt 0>
		<cfloop index="i" from="1" to="#arrayLen(cppTags)#">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="_controller.cfm?action=editCPPCFXTag&cfxTag=#cppTags[i].name#" alt="Edit CFX Tag" title="Edit CFX Tag"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyCFXTag&name=#cppTags[i].name#&type=cpp" alt="Verify CFX Tag" title="Verify CFX Tag"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteCFXTag('#cppTags[i].name#','cpp');" alt="Delete CFX Tag" title="Delete CFX Tag"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#cppTags[i].displayname#</td>
				<td>C++</td>
				<td>#cppTags[i].module#</td>
				<td>#cppTags[i].description#</td>
			</tr>
		</cfloop>
	</cfif>
	<cfif arrayLen(javaTags) gt 0>
		<cfloop index="i" from="1" to="#arrayLen(javaTags)#">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="_controller.cfm?action=editJavaCFXTag&cfxTag=#javaTags[i].name#" alt="Edit CFX Tag" title="Edit CFX Tag"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyCFXTag&name=#javaTags[i].name#&type=java" alt="Verify CFX Tag" title="Verify CFX Tag"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteCFXTag('#javaTags[i].name#','java');" alt="Delete CFX Tag" title="Delete CFX Tag"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#javaTags[i].displayname#</td>
				<td>Java</td>
				<td>#javaTags[i].class#</td>
				<td>#javaTags[i].description#</td>
			</tr>
		</cfloop>
	</cfif>
		</table>
		</cfif>
		<ul>
			<li><a href="javacfx.cfm">Register Java CFX Tag</a></li>
			<li><a href="cppcfx.cfm">Register C++ CFX Tag</a></li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "cfxTag", false) />
</cfsavecontent>
