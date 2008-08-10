<cfsilent>
	<cfparam name="logFilesMessage" type="string" default="" />
	<cfparam name="url.start" type="numeric" default="1" />
	
	<cfset logFiles = 0 />
	<cfset numPerPage = 50 />
	
	<cftry>
		<cfset logFiles = Application.debugging.getRuntimeErrorLogs() />
		<cfcatch type="any">
			<cfset logFilesMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cfif isQuery(logFiles)>
		<cfif url.start neq 1>
			<cfset showPrev = true />
			<cfset prevStart = url.start - numPerPage />
		<cfelse>
			<cfset showPrev = false />
		</cfif>

		<cfif url.start + numPerPage - 1 lt logFiles.RecordCount>
			<cfset showNext = true />
			<cfset nextStart = url.start + numPerPage />
			<cfset endLog = nextStart - 1 />
		<cfelse>
			<cfset showNext = false />
			<cfset endLog = logFiles.RecordCount />
		</cfif>
		
		<cfif logFiles.RecordCount mod numPerPage eq 0>
			<cfset finalStart = ((logFiles.RecordCount / numPerPage) - 1) * numPerPage + 1 />
		<cfelse>
			<cfset numOnLastPage = logFiles.RecordCount mod numPerPage />
			<cfset finalStart = logFiles.RecordCount - numOnLastPage + 1 />
		</cfif>

		<cfif endLog eq logFiles.RecordCount>
			<cfset showFinal = false />
		<cfelse>
			<cfset showFinal = true />
		</cfif>
	</cfif>
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
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif logFilesMessage is not ""><p class="message">#logFilesMessage#</p></cfif>
		
		<cfif not IsQuery(logFiles) or logFiles.RecordCount eq 0>
			<p><strong><em>No runtime error logs available</em></strong></p>
		<cfelse>
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td colspan="4">
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td><strong>Runtime Errors #url.start# - #endLog# of #logFiles.RecordCount#</strong></td>
							<td align="right">
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="16">
											<cfif showPrev>
												<a href="runtimeerrors.cfm?start=1"><img src="../images/resultset_first.png" border="0" width="16" height="16" alt="Go To Beginning" title="Go To Beginning" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showPrev>
												<a href="runtimeerrors.cfm?start=#prevStart#"><img src="../images/resultset_previous.png" border="0" width="16" height="16" alt="Previous #numPerPage#" title="Previous #numPerPage#" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showNext>
												<a href="runtimeerrors.cfm?start=#nextStart#"><img src="../images/resultset_next.png" border="0" width="16" height="16" alt="Next #numPerPage#" title="Next #numPerPage#" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showFinal>
												<a href="runtimeerrors.cfm?start=#finalStart#"><img src="../images/resultset_last.png" border="0" width="16" height="16" alt="Go To End" title="Go To End" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td width="100"><strong>Actions</strong></td>
				<td><strong>Runtime Error Log</strong></td>
				<td><strong>Size</strong></td>
				<td><strong>Created</strong></td>
			</tr>
		<cfloop query="logFiles" startrow="#url.start#" endrow="#endLog#">
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
