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
	<!--- TODO: enable "info" button to get status, or get document count to display in list of collections --->
	<!--- TODO: build simple query screen to allow users to run simple queries against collections from within the admin console --->
	<!--- TODO: investiage integration with Luke (http://www.getopt.org/luke/) to allow better insight into collections --->
	<cfparam name="searchCollectionsMessage" type="string" default="" />

	<cfset supportedLanguages = arrayNew(1) />
	<cfset searchCollections = arrayNew(1) />
	
	<cftry>
		<cfset supportedLanguages = Application.searchCollections.getSupportedLanguages() />
		<cfset searchCollections = Application.searchCollections.getSearchCollections() />
		<cfcatch type="any">
			<cfset searchCollectionsMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validateAddCollectionForm(f) {
				if (f.name.value.length == 0) {
					alert("Please enter the collection name");
					return false;
				} else if (f.path.value.length == 0) {
					alert("Please enter the collection path");
					return false;
				} else if (f.language.value == "") {
					alert("Please select the collection language");
				} else {
					return true;
				}
			}
			
			function deleteSearchCollection(collectionName) {
				if (confirm("Are you sure you want to delete this search collection?")) {
					location.replace("_controller.cfm?action=deleteSearchCollection&name=" + collectionName);
				}
			}
		</script>
		
		<h3>Search Collections</h3>
		
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
		
		<cfif arrayLen(searchCollections) eq 0>
			<p><strong><em>No search collections configured</em></strong></p>
		<cfelse>
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="80"><strong>Actions</strong></td>
				<td><strong>Name</strong></td>
				<td><strong>Path</strong></td>
				<td><strong>Language</strong></td>
				<td><strong>Store Body</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(searchCollections)#">
			<tr bgcolor="##ffffff">
				<td>
					<!--- <a href="_controller.cfm?action=getCollectionStatus&name=#searchCollections[i].name#">
						<img src="../images/information.png" width="16" height="16" alt="Collection Status" title="Collection Status" border="0" />
					</a> --->
					</a>
					<a href="_controller.cfm?action=showIndexForm&name=#searchCollections[i].name#">
						<img src="../images/lightning.png" width="16" height="16" alt="Index Collection" title="Index Collection" border="0" />
					</a>
					<a href="javascript:void(0);" onclick="javascript:deleteSearchCollection('#searchCollections[i].name#')">
						<img src="../images/cancel.png" width="16" heigth="16" alt="Delete Collection" title="Delete Collection" border="0" />
					</a>
				</td>
				<td>#searchCollections[i].name#</td>
				<td>#searchCollections[i].path#</td>
				<td>#searchCollections[i].language#</td>
				<td>#yesNoFormat(searchCollections[i].storebody)#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<br /><br />
		
		<form name="addCollection" action="_controller.cfm?action=createSearchCollection" method="post" onsubmit="javascript:return validateAddCollectionForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Add Search Collection</strong></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0">Collection Name</td>
				<td bgcolor="##ffffff"><input type="text" name="name" size="50" maxlength="50" /></td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0">Collection Path</td>
				<td bgcolor="##ffffff">
					<input type="text" name="path" size="50" value="#expandPath('/WEB-INF/bluedragon/work/cfcollection')#" />
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0">Language</td>
				<td bgcolor="##ffffff">
					<select name="language">
					<cfloop index="i" from="1" to="#arrayLen(supportedLanguages)#">
						<option value="#supportedLanguages[i]#"<cfif supportedLanguages[i] is "english"> selected="true"</cfif>>#supportedLanguages[i]#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td bgcolor="##f0f0f0">Store Document Body</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="storebody" value="true" />Yes&nbsp;
					<input type="radio" name="storebody" value="false" checked="true" />No
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td><input type="submit" name="submit" value="Create Collection" /></td>
			</tr>
		</table>
		</form>
	</cfoutput>
		
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "searchCollectionMessage", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>