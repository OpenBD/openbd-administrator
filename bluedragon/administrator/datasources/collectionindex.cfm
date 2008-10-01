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
	<cfparam name="searchCollectionsMessage" type="string" default="" />
	
	<cfif not structKeyExists(session, "searchCollection")>
		<cflocation url="collections.cfm" addtoken="false" />
	</cfif>
	
	<cfset fileExtensions = arrayNew(1) />
	
	<cftry>
		<cfset fileExtensions = arrayToList(Application.searchCollections.getIndexableFileExtensions()) />
		<cfcatch type="any">
			<cfset searchCollectionsMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateDirectoryIndexForm(f) {
				if (f.key.value.length == 0) {
					alert("Please enter the directory path");
					return false;
				} else {
					return true;
				}
			}
		</script>
		
		<h3>Create/Update Index for Search Collection "#session.searchCollection.name#"</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>

		<cfif searchCollectionsMessage is not ""><p class="message">#searchCollectionsMessage#</p></cfif>
		
		<form name="directoryIndexForm" action="_controller.cfm?action=indexSearchCollection" method="post" onSubmit="return validateDirectoryIndexForm(this);">
		<table border="0" width="700" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Directory Index</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Directory Path</td>
				<td bgcolor="##ffffff"><input type="text" name="key" size="50" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Extensions</td>
				<td bgcolor="##ffffff"><input type="text" name="extensions" size="50" value="#fileExtensions#" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Recuse Subdirectories</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="recurse" value="true" checked="true" />Yes&nbsp;
					<input type="radio" name="recurse" value="false" />No
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">URL Path</td>
				<td bgcolor="##ffffff"><input type="text" name="urlpath" size="50" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0" align="right">Language</td>
				<td bgcolor="##ffffff">#session.searchCollection.language#</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Create/Update Index" /></td>
			</tr>
		</table>
			<input type="hidden" name="collection" value="#session.searchCollection.name#" />
			<input type="hidden" name="type" value="path" />
			<input type="hidden" name="language" value="#session.searchCollection.language#" />
			<input type="hidden" name="collectionAction" value="refresh" />
		</form>
		
		<br /><br />
		
		<form name="webSiteIndexForm" action="_controller.cfm?action=indexSearchCollection" method="post" onsubmit="javascript:return validateWebSiteIndexForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Web Site Index</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0">Starting URL</td>
				<td bgcolor="##ffffff"><input type="text" name="key" size="50" /></td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Create/Update Index" /></td>
			</tr>
		</table>
			<input type="hidden" name="collection" value="#session.searchCollection.name#" />
			<input type="hidden" name="type" value="website" />
			<input type="hidden" name="language" value="#session.searchCollection.language#" />
			<input type="hidden" name="collectionAction" value="refresh" />
		</form>
	</cfoutput>
		
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "searchCollectionMessage", false) />
	<cfset structDelete(session, "searchCollection", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>