<cfsilent>
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
		<form name="collectionsForm" action="_controller.cfm?action=deleteSearchCollections" method="post" onsubmit="return validateCollectionsForm(this);">
		<table border="0" width="100%" cellpadding="2" cellspacing="1" bgcolor="##999999">
			<tr bgcolor="##dedede">
				<td width="80"><strong>Actions</strong></td>
				<td><strong>Name</strong></td>
				<td><strong>Path</strong></td>
				<td><strong>Language</strong></td>
				<td><strong>Store Body</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(searchCollections)#">
			<!--- TODO: need to sort alphabetically --->
			<tr bgcolor="##ffffff">
				<td>
					<a href="_controller.cfm?action=getCollectionStatus&collection=#searchCollections[i].name#">
						<img src="../images/information.png" width="16" height="16" alt="Collection Status" title="Collection Status" border="0" />
					</a>
					</a>
					<a href="_controller.cfm?action=">
						<img src="../images/lightning.png" width="16" height="16" alt="Index Collection" title="Index Collection" border="0" />
					</a>
					<a href="javascript:void(0);" onclick="javascript:deleteSearchCollection('searchCollections[i].name')">
						<img src="../images/cancel.png" width="16" heigth="16" alt="Delete Collection" title="Delete Collection" border="0" />
					</a>
				</td>
				<td>#searchCollections[i].name#</td>
				<td>#searchCollections[i].path#</td>
				<td>#searchCollections[i].language#</td>
				<td>#yesNoFormat(searchCollections[i].storebody)#</td>
			</tr>
		</cfloop>
			<tr bgcolor="##dedede">
				<td colspan="5" align="right">
					<input type="button" name="submit" value="Delete Collections" />
				</td>
			</tr>
		</table>
		</form>
		</cfif>
		
		<h3>Add New Collection</h3>
		
		<form name="addCollection" action="_controller.cfm?action=createSearchCollection" method="post" onsubmit="javascript:return validateAddCollectionForm(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
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