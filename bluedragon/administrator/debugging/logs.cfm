<cfsilent>
	<cfparam name="logFilesMessage" type="string" default="" />

	<cfset logFiles = arrayNew(1) />

	<cftry>
		<cfset logFiles = Application.debugging.getLogFiles() />
		<cfcatch type="any">
			<cfset logFilesMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function deleteLogFile(logFile) {
				if(confirm("Are you sure you want to delete this log file?")) {
					location.replace("_controller.cfm?action=deleteLogFile&logFile=" + logFile);
				}
			}
			
			function archiveLogFile(logFile) {
				if(confirm("Are you sure you want to archive this log file?\nThis will delete your oldest log file of this type\nand rotate all other log files back one position.")) {
					location.replace("_controller.cfm?action=archiveLogFile&logFile=" + logFile);
				}
			}
			
			function downloadLogFile(logFile) {
				window.open("downloadlogfile.cfm?logFile=" + logFile);
			}
		</script>
		
		<h3>Log Files</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif logFilesMessage is not ""><p class="message">#logFilesMessage#</p></cfif>
		
		<cfif arrayLen(logFiles) eq 0>
			<p><strong><em>No log files available</em></strong></p>
		<cfelse>
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Log File</strong></td>
				<td><strong>Size</strong></td>
				<td><strong>Last Updated</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(logFiles)#">
			<!--- TODO: need to sort alphabetically --->
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="_controller.cfm?action=viewLogFile" alt="View Log File" title="View Log File"><img src="../images/page_find.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:downloadLogFile('#logFiles[i].name#');" alt="Download Log File" title="Download Log File"><img src="../images/disk.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:archiveLogFile('#logFiles[i].name#');" alt="Archive Log File" title="Archive Log File"><img src="../images/folder_page.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteLogFile('#logFiles[i].name#');" alt="Delete Log File" title="Delete Log File"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td><a href="" alt="View Log File" title="View Log File">#logFiles[i].name#</a></td>
				<td>#logFiles[i].size#</td>
				<td>#logFiles[i].datelastmodified#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
