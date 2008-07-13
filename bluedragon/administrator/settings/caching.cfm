<cfsilent>
	<cfparam name="cachingMessage" type="string" default="" />
	
	<cftry>
		<cfset cachingSettings = Application.caching.getCachingSettings() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset cachingMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateFileCacheForm(f) {
				if (f.maxfiles.value != parseInt(f.maxfiles.value)) {
					alert("Please enter a numeric value for file cache size. If no caching is desired, please enter 0.");
					return false;
				} else {
					return true;
				}
			}
			
			function validateQueryCacheForm(f) {
				if (f.cachecount.value != parseInt(f.cachecount.value)) {
					alert("Please enter a numeric value for query cache size. If no caching is desired, please enter 0.");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Caching</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif cachingMessage is not "">
			<p class="message">#cachingMessage#</p>
		</cfif>
		
		<!--- TODO: need to implement getting the file, query, and content cache count and let the user flush these --->
		
		<form name="fileCacheForm" action="_controller.cfm?action=processFileCacheForm" method="post" onsubmit="javascript:return validateFileCacheForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>File Cache</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">File Cache Size</td>
				<td bgcolor="##ffffff">
					<input type="text" name="maxfiles" size="5" maxlength="4" value="#cachingSettings.file.maxfiles#" /> files
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Trust Cache</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="trustcache" value="true"<cfif cachingSettings.file.trustcache> checked="true"</cfif> /> Yes&nbsp;
					<input type="radio" name="trustcache" value="false"<cfif not cachingSettings.file.trustcache> checked="true"</cfif> /> No&nbsp;
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		<form name="queryCacheForm" action="_controller.cfm?action=processQueryCacheForm" method="post" onsubmit="javascript:return validateQueryCacheForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Query Cache</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Query Cache Size</td>
				<td bgcolor="##ffffff">
					<input type="text" name="cachecount" size="5" maxlength="4" value="#cachingSettings.cfquery.cachecount#" /> queries
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>