<cfsilent>
	<cfparam name="url.rteLog" type="string" default="" />
	<cfparam name="logContents" type="string" default="" />
	
	<cfif url.rteLog is not "">
		<cfif fileExists(ExpandPath("/WEB-INF/bluedragon/work/temp/rtelogs/#url.rteLog#"))> --->
			<cffile action="read" file="#ExpandPath('/WEB-INF/bluedragon/work/temp/rtelogs/#url.rteLog#')#" variable="logContents" />
		</cfif>
	</cfif>
</cfsilent>
<cfsavecontent variable="request.content">
<cfoutput>
	<cfif logContents is not "">
		<h3>Viewing Contents of #url.rteLog#</h3>
		<cfoutput>#logContents#</cfoutput>
	<cfelse>
		<p><strong>No file contents to display</strong></p>
	</cfif>
</cfoutput>
</cfsavecontent>