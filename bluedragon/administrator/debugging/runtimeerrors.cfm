<cfsilent>
	<cfparam name="logFilesMessage" type="string" default="" />

	<cfset logFiles = 0 />

	<cftry>
		<cfset logFiles = Application.debugging.getRuntimeErrorLogs() />
		<cfcatch type="any">
			<cfset logFilesMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function deleteLogFile(rteLog) {
				if(confirm("Are you sure you want to delete this runtime error log?")) {
					location.replace("_controller.cfm?action=deleteRuntimeErrorLog&rteLog=" + rteLog);
				}
			}
			
			function downloadLogFile(rteLog) {
				window.open("downloadrtelog.cfm?rteLog=" + rteLog);
			}
		</script>
		
		<h3>Runtime Error Logs</h3>
		<!--- TODO: add paging of RTE logs --->
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif logFilesMessage is not ""><p class="message">#logFilesMessage#</p></cfif>
		
		<cfif not IsQuery(logFiles) or logFiles.RecordCount eq 0>
			<p><strong><em>No runtime error logs available</em></strong></p>
		<cfelse>
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Runtime Error Log</strong></td>
				<td><strong>Size</strong></td>
				<td><strong>Created</strong></td>
			</tr>
		<cfloop query="logFiles">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="viewrtelog.cfm?rteLog=#logFiles.name#" alt="View Runtime Error Log" title="View Runtime Error Log"><img src="../images/page_find.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:downloadLogFile('#logFiles.name#');" alt="Download Runtime Error Log" title="Download Runtime Error Log"><img src="../images/disk.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:deleteLogFile('#logFiles.name#');" alt="Delete Runtime Error Log" title="Delete Runtime Error Log"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td><a href="viewrtelog.cfm?rteLog=#logFiles.name#" alt="View Runtime Error Log" title="View Runtime Error Log">#logFiles.name#</a></td>
				<td>#logFiles.size#</td>
				<td>#LSDateFormat(logFiles.datelastmodified, "dd mmm yyyy")# #LSTimeFormat(logFiles.datelastmodified, "HH:mm:ss")#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
