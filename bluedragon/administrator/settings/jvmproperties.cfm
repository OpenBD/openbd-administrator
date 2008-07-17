<cfsilent>
	<cfparam name="jvmMessage" type="string" default="" />
	
	<cfset jvmProps = structNew() />
	
	<cftry>
		<cfset jvmProps = Application.serverSettings.getJVMProperties() />
		<cfcatch type="any">
			<cfset jvmMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<h3>Java Virtual Machine (JVM) Properties</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif jvmMessage is not "">
			<p class="message">#jvmMessage#</p>
		</cfif>
		
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td><strong>Property Name</strong></td>
				<td><strong>Property Value</strong></td>
			</tr>
		<cfloop collection="#jvmProps#" item="prop">
			<tr>
				<td bgcolor="##f0f0f0">#prop#</td>
				<td bgcolor="##ffffff">#jvmProps[prop]#</td>
			</tr>
		</cfloop>
		</table>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
