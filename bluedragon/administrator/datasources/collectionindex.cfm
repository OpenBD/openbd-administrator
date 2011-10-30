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
  
  <cfif !StructKeyExists(session, "searchCollection")>
    <cflocation url="collections.cfm" addtoken="false" />
  </cfif>
  
  <cfset fileExtensions = ArrayNew(1) />
  
  <cftry>
    <cfset fileExtensions = ArrayToList(Application.searchCollections.getIndexableFileExtensions()) />
    <cfcatch type="any">
      <cfset searchCollectionsMessage = CFCATCH.Message />
      <cfset searchCollectionsMessageType = "error" />
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

    <div class="row">
      <div class="pull-left">
	<h2>Create/Update Index for Search Collection "#session.searchCollection.name#"</h2>
      </div>
      <div class="pull-right">
	<button data-controls-modal="moreInfo" data-backdrop="true" data-keyboard="true" class="btn primary">More Info</button>
      </div>
    </div>
    
    <cfif StructKeyExists(session, "message") && session.message.text != "">
      <p class="#session.message.type#">#session.message.text#</p>
    </cfif>
    
    <cfif StructKeyExists(session, "errorFields") && ArrayLen(session.errorFields) gt 0>
      <p class="error">The following errors occurred:</p>
      <ul>
	<cfloop index="i" from="1" to="#ArrayLen(session.errorFields)#">
	  <li>#session.errorFields[i][2]#</li>
	</cfloop>
      </ul>
    </cfif>

    <cfif searchCollectionsMessage != ""><p class="#searchCollectionsMessageType#">#searchCollectionsMessage#</p></cfif>
    
    <form name="directoryIndexForm" action="_controller.cfm?action=indexSearchCollection" method="post" 
	  onSubmit="return validateDirectoryIndexForm(this);">
      <table border="0" width="700" cellpadding="2" cellspacing="1" bgcolor="##999999">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Directory Index</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="key">Directory Path</label></td>
	  <td bgcolor="##ffffff"><input type="text" name="key" id="key" size="50" tabindex="1" /></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="extensions">Extensions</label></td>
	  <td bgcolor="##ffffff">
	    <input type="text" name="extensions" id="extensions" size="50" value="#fileExtensions#" 
		   tabindex="2" />
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right">Recurse Subdirectories</td>
	  <td bgcolor="##ffffff">
	    <input type="radio" name="recurse" id="recurseTrue" value="true" checked="true" tabindex="3" />
	    <label for="recurseTrue">Yes</label>&nbsp;
	    <input type="radio" name="recurse" id="recurseFalse" value="false" tabindex="4" />
	    <label for="recurseFalse">No</label>
	  </td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right"><label for="urlpath">URL Path</label></td>
	  <td bgcolor="##ffffff"><input type="text" name="urlpath" id="urlpath" size="50" tabindex="5" /></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0" align="right">Language</td>
	  <td bgcolor="##ffffff">#session.searchCollection.language#</td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Create/Update Index" tabindex="6" /></td>
	</tr>
      </table>
      <input type="hidden" name="collection" value="#session.searchCollection.name#" />
      <input type="hidden" name="type" value="path" />
      <input type="hidden" name="language" value="#session.searchCollection.language#" />
      <input type="hidden" name="collectionAction" value="refresh" />
    </form>
    
    <br /><br />
    
    <form name="webSiteIndexForm" action="_controller.cfm?action=indexSearchCollection" method="post" 
	  onsubmit="javascript:return validateWebSiteIndexForm(this);">
      <table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
	<tr bgcolor="##dedede">
	  <td colspan="2"><strong>Web Site Index</strong></td>
	</tr>
	<tr>
	  <td bgcolor="##f0f0f0"><label for="urlKey">Starting URL</label></td>
	  <td bgcolor="##ffffff"><input type="text" name="key" id="urlKey" size="50" tabindex="7" /></td>
	</tr>
	<tr bgcolor="##dedede">
	  <td>&nbsp;</td>
	  <td><input type="submit" name="submit" value="Create/Update Index" tabindex="8" /></td>
	</tr>
      </table>
      <input type="hidden" name="collection" value="#session.searchCollection.name#" />
      <input type="hidden" name="type" value="website" />
      <input type="hidden" name="language" value="#session.searchCollection.language#" />
      <input type="hidden" name="collectionAction" value="refresh" />
    </form>
  </cfoutput>

  <div id="moreInfo" class="modal hide fade">
    <div class="modal-header">
      <a href="##" class="close">&times;</a>
      <h3>Information Concerning Indexing Search Collections</h3>
    </div>
    <div class="modal-body">
      <ul>
	<li>Search collections may be populated from either a directory path or a full URL.</li>
	<li>
	  Use the Directory Index form to populate the collection using a directory path. Use the 
	  Web Site Index form to populate the collection from a starting URL.
	</li>
	<li>
	  A full physical path starting with "/" (on Unix-based systems) or a full drive path including drive letter 
	  (on Windows systems) may be specified for the directory path in the top form.
	</li>
      </ul>
    </div>
  </div>
  
  <cfset StructDelete(session, "searchCollectionMessage", false) />
  <cfset StructDelete(session, "searchCollection", false) />
</cfsavecontent>
