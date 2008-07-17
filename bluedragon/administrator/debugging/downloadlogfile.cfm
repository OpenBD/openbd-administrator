<cftry>
	<cfset fullPath = Application.debugging.getLogFilePath(url.logFile) />
	<cfset fullPath = "#fullPath#/#url.logFile#" />
	<cfcatch type="any">
		<cfset session.message = CFCATCH.Message />
	</cfcatch>
</cftry>
<cfheader name="Content-disposition" value="attachment;filename=#url.logFile#" />
<cfcontent type="text/plain" file="#fullPath#" />
