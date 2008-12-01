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
	<cfparam name="fontsMessage" type="string" default="" />
	<cfparam name="fontDirs" type="array" default="#arrayNew(1)#" />
	<cfparam name="fontDirAction" type="string" default="create" />
	
	<cftry>
		<cfset fontDirs = Application.fonts.getFontDirectories() />
		<cfcatch type="bluedragon.adminapi.fonts">
			<cfset fontsMessage = CFCATCH.Message />
			<cfset fontsMessageType = "error" />
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
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif fontsMessage is not "">
			<p class="#fontsMessageType#">#fontsMessage#</p>
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
					<a href="javascript:void(0);" 
						onclick="javascript:editFontDir('#replace(fontDirs[i], '\', '\\', 'all')#');" 
						alt="Edit Font Directory" title="Edit Font Directory">
						<img src="../images/pencil.png" border="0" width="16" height="16" />
					</a>
					<a href="_controller.cfm?action=verifyFontDirectory&fontDir=#fontDirs[i]#" alt="Verify Font Directory" 
						title="Verify Font Directory">
						<img src="../images/accept.png" border="0" width="16" height="16" />
					</a>
					<a href="javascript:void(0);" 
						onclick="javascript:removeFontDir('#replace(fontDirs[i], '\', '\\', 'all')#');" 
						alt="Remove Font Directory" title="Remove Font Directory">
						<img src="../images/cancel.png" border="0" width="16" height="16" />
					</a>
				</td>
				<td>#fontDirs[i]#</td>
			</tr>
		</cfloop>
		</table>
		</cfif>
		
		<br />
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
			<ul>
			<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
				<li>#session.errorFields[i][2]#</li>
			</cfloop>
			</ul>
		</cfif>
		
		<form name="fontDirForm" action="_controller.cfm?action=processFontDirForm" method="post" 
				onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong><cfif fontDirAction is "create">Add a<cfelse>Edit</cfif> Font Directory</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="fontDir">Font Directory</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="fontDir" id="fontDir" size="40" value="" tabindex="1" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" tabindex="2" />
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
				(on Windows systems) may be specified.
			</li>
			<li>
				On Unix-based systems the common font folders include:<br />
				/usr/X/lib/X11/fonts/TrueType<br />
				/usr/openwin/lib/X11/fonts/TrueType<br />
				/usr/share/fonts/default/TrueType<br />
				/usr/X11R6/lib/X11/fonts/ttf<br />
				/usr/X11R6/lib/X11/fonts/truetype<br />
				/usr/X11R6/lib/X11/fonts/TTF
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "fontDir", false) />
</cfsavecontent>
