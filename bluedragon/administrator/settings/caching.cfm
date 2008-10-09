<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Administrator.

	The Open BlueDragon Administrator is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Administrator is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Administrator.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfsilent>
	<cfparam name="cachingMessage" type="string" default="" />
	<cfparam name="numFilesInCache" type="numeric" default="-1" />
	<cfparam name="fileCacheMessage" type="string" default="" />
	<cfparam name="numQueriesInCache" type="numeric" default="-1" />
	<cfparam name="queryCacheMessage" type="string" default="" />
	
	<cftry>
		<cfset cachingSettings = Application.caching.getCachingSettings() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset cachingMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfset numContentInCache = Application.caching.getNumContentInCache() />
		<cfset numContentCacheHits = Application.caching.getContentCacheHits() />
		<cfset numContentCacheMisses = Application.caching.getContentCacheMisses() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset contentCacheMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfset numFilesInCache = Application.caching.getNumFilesInCache() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset fileCacheMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cftry>
		<cfset numQueriesInCache = Application.caching.getNumQueriesInCache() />
		<cfset numQueryCacheHits = Application.caching.getQueryCacheHits() />
		<cfset numQueryCacheMisses = Application.caching.getQueryCacheMisses() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset queryCacheMessage = CFCATCH.Message />
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

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<!--- TODO: need to implement getting the content cache count and let the user flush all caches --->
		<form name="cacheStatusForm" action="_controller.cfm?action=processFlushCacheForm" method="post" onsubmit="">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="5"><strong>Cache Status</strong></td>
			</tr>
			<tr bgcolor="##dedede">
				<td><strong>Cache</strong></td>
				<td><strong>Size</strong></td>
				<td><strong>Hits</strong></td>
				<td><strong>Misses</strong></td>
				<td><strong>Flush</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right" width="200">File</td>
				<td bgcolor="##ffffff" width="300">#numFilesInCache#</td>
				<td bgcolor="##ffffff"></td>
				<td bgcolor="##ffffff"></td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" value="file" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Query</td>
				<td bgcolor="##ffffff">#numQueriesInCache#</td>
				<td bgcolor="##ffffff">#numQueryCacheHits#</td>
				<td bgcolor="##ffffff">#numQueryCacheMisses#</td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" value="query" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Content</td>
				<td bgcolor="##ffffff">#numContentInCache#</td>
				<td bgcolor="##ffffff">#numContentCacheHits#</td>
				<td bgcolor="##ffffff">#numContentCacheMisses#</td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" value="content" />
				</td>
			</tr>
			<tr>
			</tr>
			<tr bgcolor="##dedede">
				<td colspan="5" align="right"><input type="submit" name="submit" value="Flush Checked Caches" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		
		<form name="fileCacheForm" action="_controller.cfm?action=processFileCacheForm" method="post" onsubmit="javascript:return validateFileCacheForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>File Cache Settings</strong></td>
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
				<td colspan="2"><strong>Query Cache Settings</strong></td>
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
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>