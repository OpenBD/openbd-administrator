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
	<cfparam name="numQueriesInCache" type="numeric" default="-1" />
	<cfparam name="queryCacheMessage" type="string" default="" />
	
	<cfset fileCacheInfo = SystemFileCacheInfo() />
	
	<cftry>
		<cfset cachingSettings = Application.caching.getCachingSettings() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset cachingMessage = CFCATCH.Message />
			<cfset cachingMessageType = "error" />
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
		<cfset numQueriesInCache = Application.caching.getNumQueriesInCache() />
		<cfset numQueryCacheHits = Application.caching.getQueryCacheHits() />
		<cfset numQueryCacheMisses = Application.caching.getQueryCacheMisses() />
		<cfcatch type="bluedragon.adminapi.caching">
			<cfset queryCacheMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
	
	<cfif not StructKeyExists(cachingSettings, "cfcachecontent")>
		<cfset cachingSettings.cfcachecontent = StructNew() />
	</cfif>
	
	<cfif not StructKeyExists(cachingSettings.cfcachecontent, "datasource")>
		<cfset cachingSettings.cfcachecontent.datasource = "" />
	</cfif>
	
	<cfif not StructKeyExists(cachingSettings.cfcachecontent, "total")>
		<cfset cachingSettings.cfcachecontent.total = 1000 />
	</cfif>

	<cftry>
		<cfset datasources = Application.datasource.getDatasources() />
		<cfcatch type="bluedragon.adminapi.datasource">
			<cfset datasources = arrayNew(1) />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateCacheStatusForm(f) {
				var cbxCount = 0;
				
				for (var i = 0; i < f.cacheToFlush.length; i++) {
					if (f.cacheToFlush[i].checked) {
						cbxCount++;
					}
				}
				
				if (cbxCount == 0) {
					alert("Please select at least one cache to flush");
					return false;
				} else {
					if(confirm("Are you sure you want to flush the selected caches?")) {
						return true;
					} else {
						return false;
					}
				}
			}
			
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
			
			function validateCFCacheContentForm(f) {
				if (f.total.value.length == 0 || 
						f.total.value != parseInt(f.total.value) || 
						f.total.value <= 0) {
					alert("Item Cache Size must be a numeric value greater than 0.");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Caching</h3>

		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif cachingMessage is not "">
			<p class="#cachingMessageType#">#cachingMessage#</p>
		</cfif>

		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>

		<form name="cacheStatusForm" action="_controller.cfm?action=processFlushCacheForm" method="post" 
				onsubmit="javascript:return validateCacheStatusForm(this);">
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
				<td bgcolor="##f0f0f0" align="right" width="200"><label for="cacheToFlushFile">File</label> (<a href="filecachedetails.cfm">details</a>)</td>
				<td bgcolor="##ffffff" width="300">#fileCacheInfo.size#</td>
				<td bgcolor="##ffffff">#fileCacheInfo.hits#</td>
				<td bgcolor="##ffffff">#fileCacheInfo.misses#</td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" id="cacheToFlushFile" value="file" tabindex="1" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="cacheToFlushQuery">Query</label></td>
				<td bgcolor="##ffffff">#numQueriesInCache#</td>
				<td bgcolor="##ffffff">#numQueryCacheHits#</td>
				<td bgcolor="##ffffff">#numQueryCacheMisses#</td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" id="cacheToFlushQuery" value="query" tabindex="2" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="cacheToFlushContent">Content</label></td>
				<td bgcolor="##ffffff">#numContentInCache#</td>
				<td bgcolor="##ffffff">#numContentCacheHits#</td>
				<td bgcolor="##ffffff">#numContentCacheMisses#</td>
				<td bgcolor="##f0f0f0" align="center">
					<input type="checkbox" name="cacheToFlush" id="cacheToFlushContent" value="content" tabindex="3" />
				</td>
			</tr>
			<tr>
			</tr>
			<tr bgcolor="##dedede">
				<td colspan="5" align="right"><input type="submit" name="submit" value="Flush Checked Caches" tabindex="4" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		<form name="fileCacheForm" action="_controller.cfm?action=processFileCacheForm" method="post" 
				onsubmit="javascript:return validateFileCacheForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>File Cache Settings</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="maxfiles">File Cache Size</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="maxfiles" id="maxfiles" size="5" maxlength="4" 
							value="#cachingSettings.file.maxfiles#" tabindex="5" /> files
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Trust Cache</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="trustcache" id="trustcacheTrue" value="true"
						<cfif cachingSettings.file.trustcache> checked="true"</cfif> tabindex="6" />
					<label for="trustcacheTrue">Yes</label>&nbsp;
					<input type="radio" name="trustcache" id="trustcacheFalse" value="false"
							<cfif not cachingSettings.file.trustcache> checked="true"</cfif> tabindex="7" />
					<label for="trustcacheFalse">No</label>&nbsp;
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="8" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		<form name="queryCacheForm" action="_controller.cfm?action=processQueryCacheForm" method="post" 
				onsubmit="javascript:return validateQueryCacheForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Query Cache Settings</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right"><label for="cachecount">Query Cache Size</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="cachecount" id="cachecount" size="5" maxlength="4" 
							value="#cachingSettings.cfquery.cachecount#" tabindex="9" /> queries
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="10" /></td>
			</tr>
		</table>
		</form>
		
		<br /><br />
		
		<form name="cfcachecontentForm" action="_controller.cfm?action=processCFCacheContentForm" method="post" 
				onsubmit="javascript:return validateCFCacheContentForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>CFCACHECONTENT Settings</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">
					<label for="total">Item Cache Size</label>
				</td>
				<td bgcolor="##ffffff">
					<input type="text" name="total" id="total" size="6" maxlength="5" 
							value="#cachingSettings.cfcachecontent.total#" tabindex="11" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">
					<label for="datasource">Datasource</label>
				</td>
				<td bgcolor="##ffffff">
					<select name="datasource" id="datasource" tabindex="12">
						<option value=""<cfif cachingSettings.cfcachecontent.datasource is ""> selected="true"</cfif>>- select -</option>
					<cfif arrayLen(datasources) gt 0>
						<cfloop index="i" from="1" to="#arrayLen(datasources)#">
						<option value="#datasources[i].name#"<cfif cachingSettings.cfcachecontent.datasource is datasources[i].name> selected="true"</cfif>>#datasources[i].name#</option>
						</cfloop>
					</cfif>
					</select><br />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Submit" tabindex="13" /></td>
			</tr>
		</table>
		</form>
		
		<p><strong>Information Concerning Caching</strong></p>
		
		<ul>
			<li>
				The datasource setting for CFCACHECONTENT indicates the datasource in which items will be stored 
				after the value of Item Cache Size is exceeded. The value of Item Cache Size must be a 
				numeric value greater than 0.
			</li>
		</ul>
	</cfoutput>
</cfsavecontent>