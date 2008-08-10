<cfsilent>
	<cfparam name="fontsMessage" type="string" default="" />
	<cfparam name="fontDirs" type="array" default="#arrayNew(1)#" />
	<cfparam name="fontDirAction" type="string" default="create" />
	
	<cftry>
		<cfset fontDirs = Application.fonts.getFontDirectories() />
		<cfcatch type="bluedragon.adminapi.fonts">
			<cfset fontsMessage = CFCATCH.Message />
		</cfcatch>
	</cftry>
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function validate(f) {
				if (f.fontDir.value.length == 0) {
					alert("Please enter the font directory");
					return false;
				} else {
					return true;
				}
			}
			
			function editFontDir(fontDir) {
				var f = document.forms.fontDirForm;
				
				f.fontDir.value = fontDir;
				f.existingFontDir.value = fontDir;
				f.fontDirAction.value = "update";
			}
			
			function removeFontDir(fontDir) {
				if (confirm("Are you sure you want to remove this font directory?")) {
					location.replace("_controller.cfm?action=removeFontDirectory&fontDir=" + fontDir);
				}
			}
		</script>
		
		<h3>Font Directories</h3>
		
		<cfif structKeyExists(session, "message") and session.message is not "">
			<p class="message">#session.message#</p>
		</cfif>
		
		<cfif fontsMessage is not "">
			<p class="message">#fontsMessage#</p>
		</cfif>

		<cfif arrayLen(fontDirs) gt 0>
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##f0f0f0">
				<td><strong>Actions</strong></td>
				<td><strong>Font Directory</strong></td>
			</tr>
		<cfloop index="i" from="1" to="#arrayLen(fontDirs)#">
			<tr bgcolor="##ffffff">
				<td width="100">
					<a href="javascript:void(0);" onclick="javascript:editFontDir('#fontDirs[i]#')" alt="Edit Font Directory" title="Edit Font Directory"><img src="../images/pencil.png" border="0" width="16" height="16" /></a>
					<a href="_controller.cfm?action=verifyFontDirectory&fontDir=#fontDirs[i]#" alt="Verify Font Directory" title="Verify Font Directory"><img src="../images/accept.png" border="0" width="16" height="16" /></a>
					<a href="javascript:void(0);" onclick="javascript:removeFontDir('#fontDirs[i]#');" alt="Remove Font Directory" title="Remove Font Directory"><img src="../images/cancel.png" border="0" width="16" height="16" /></a>
				</td>
				<td>#fontDirs[i]#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<br />
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="message">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="fontDirForm" action="_controller.cfm?action=processFontDirForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong><cfif fontDirAction is "create">Add a<cfelse>Edit</cfif> Font Directory</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Font Directory</td>
				<td bgcolor="##ffffff">
					<input type="text" name="fontDir" size="40" value="" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
				</td>
			</tr>
		</table>
			<input type="hidden" name="fontDirAction" value="#fontDirAction#" />
			<input type="hidden" name="existingFontDir" value="">
		</form>
		
		<p><strong>Important Information Concerning Specifying Physical Paths</strong></p>
		
		<ul>
			<li>
				A full physical path starting with "/" (on Unix-based systems) or a full drive path including drive letter 
				(on Windows systems) may be specified. On Unix-based systems the common font folders include:<br />
				/usr/X/lib/X11/fonts/TrueType<br />
				/usr/openwin/lib/X11/fonts/TrueType<br />
				/usr/share/fonts/default/TrueType<br />
				/usr/X11R6/lib/X11/fonts/ttf<br />
				/usr/X11R6/lib/X11/fonts/truetype<br />
				/usr/X11R6/lib/X11/fonts/TTF
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "fontDir", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
