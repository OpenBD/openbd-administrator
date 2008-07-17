<cfsilent>
	<cfparam name="logFileMessage" type="string" default="" />
	<cfparam name="url.logFile" type="string" default="" />
	<cfparam name="url.numLinesToShow" type="numeric" default="25" />
	<cfparam name="url.startLine" type="numeric" default="1" />
	
	<cfset logFileData = structNew() />
	<cfset logFileData.totalLineCount = 0 />
	<cfset logFileData.logFileLines = arrayNew(1) />
	
	<cftry>
		<cfset logFileData = Application.debugging.getLogFileLines(url.logFile, url.startLine, url.numLinesToShow) />
		
		<cfif url.startLine + url.numLinesToShow - 1 gte logFileData.totalLineCount>
			<cfset endLine = logFileData.totalLineCount />
			<cfset showNext = false />
			<cfset showFinal = false />
		<cfelse>
			<cfset nextStart = url.startLine + url.numLinesToShow />
			
			<cfif logFileData.totalLineCount mod url.numLinesToShow eq 0>
				<cfset finalStart = ((logFileData.totalLineCount / url.numLinesToShow) - 1) * url.numLinesToShow + 1 />
			<cfelse>
				<cfset numOnLastPage = logFileData.totalLineCount mod url.numLinesToShow />
				<cfset finalStart = logFileData.totalLineCount - numOnLastPage + 1 />
			</cfif>
			
			<cfif finalStart gte logFileData.totalLineCount>
				<cfset showFinal = false />
			<cfelse>
				<cfset showFinal = true />
			</cfif>
			
			<cfset endLine = url.startLine + url.numLinesToShow - 1 />
			<cfset showNext = true />
		</cfif>
		
		<cfif url.startLine neq 1>
			<cfset prevStart = url.startLine - url.numLinesToShow />
			<cfset showPrev = true />
		<cfelse>
			<cfset showPrev = false />
		</cfif>
		
		<cfcatch type="bluedragon.adminapi.debugging">
			<cfset logFileMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>View Log File - #url.logFile#</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif logFileMessage is not "">
			<p class="message">#logFileMessage#</p>
		</cfif>
		
		<cfif arrayLen(logFileData.logFileLines) eq 0>
			<p><strong><em>Log file not available or contains no entries</em></strong></p>
		<cfelse>
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td>
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td>Entries #url.startLine# - #endLine# of #logFileData.totalLineCount#</td>
							<td align="right">
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td width="16">
											<cfif showPrev>
												<a href="viewlogfile.cfm?logFile=#url.logFile#&startLine=1&numLinesToShow=#url.numLinesToShow#"><img src="../images/resultset_first.png" border="0" width="16" height="16" alt="Go To Beginning" title="Go To Beginning" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showPrev>
												<a href="viewlogfile.cfm?logFile=#url.logFile#&startLine=#prevStart#&numLinesToShow=#url.numLinesToShow#"><img src="../images/resultset_previous.png" border="0" width="16" height="16" alt="Previous #url.numLinesToShow#" title="Previous #url.numLinesToShow#" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showNext>
												<a href="viewlogfile.cfm?logFile=#url.logFile#&startLine=#nextStart#&numLinesToShow=#url.numLinesToShow#"><img src="../images/resultset_next.png" border="0" width="16" height="16" alt="Next #url.numLinesToShow#" title="Next #url.numLinesToShow#" /></a>
											<cfelse>
												&nbsp;
											</cfif>
										</td>
										<td width="16">
											<cfif showFinal>
												<a href="viewlogfile.cfm?logFile=#url.logFile#&startLine=#finalStart#&numLinesToShow=#url.numLinesToShow#"><img src="../images/resultset_last.png" border="0" width="16" height="16" alt="Go To End" title="Go To End" /></a>
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
		<cfloop index="i" from="1" to="#arrayLen(logFileData.logFileLines)#">
			<cfset rowBG = IIf(i mod 2 eq 0, de("f0f0f0"), de("ffffff")) />
			<tr bgcolor="###rowBG#">
				<td colspan="2">
					<cfif logFileData.logFileLines[i] is not "">
						#logFileData.logFileLines[i]#
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
