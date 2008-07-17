<cfset fullPath = Application.debugging.getLogFilePath(url.logFile) />
<cfset fullPath = "#fullPath#/#url.logFile#" />
<cfheader name="Content-disposition" value="attachment;filename=#url.logFile#" />
<cfcontent type="text/plain" file="#fullPath#" />
