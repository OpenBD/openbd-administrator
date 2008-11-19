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
	<cfset serverSettings = Application.serverSettings.getServerSettings() />
	<cfset charsets = Application.serverSettings.getAvailableCharsets() />
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<script type="text/javascript">
			function updateBufferSettings() {
				var f = document.forms.serverSettings;
				
				if (f.bufferentirepage.checked) {
					f.buffersize.readOnly = true;
					f.buffersize.value = "0";
				} else {
					f.buffersize.readOnly = false;
					f.buffersize.value = "4";
				}
			}
			
			function validate(f) {
				if (f.buffersize.value != parseInt(f.buffersize.value)) {
					alert("Buffer size must be numeric");
					return false;
				} else {
					if (f.componentcfc.value != '/WEB-INF/bluedragon/component.cfc') {
						if(confirm("Are you SURE you want to change the value of Base ColdFusion Component (CFC)?")) {
							return true;
						} else {
							return false;
						}
					}
				}
			}
			
			function confirmRevert() {
				if (confirm("Are you sure you want to revert to the previous version of the server settings?")) {
					location.replace("_controller.cfm?action=revertToPreviousSettings");
				}
			}
		</script>
		
		<h3>Server Settings</h3>
		
		<p>
			Settings last updated #serverSettings.lastupdated#<br />
			<a href="javascript:void(0);" onclick="javascript:confirmRevert();">Revert to previous settings</a>
		</p>
		
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
				
		<form name="serverSettings" action="_controller.cfm?action=processServerSettingsForm" method="post" 
				onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr bgcolor="##dedede">
				<td colspan="2"><strong>Update Server Settings</strong></td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="buffersize">Response Buffer Size</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="buffersize" id="buffersize" size="3" value="#serverSettings.buffersize#"
							<cfif serverSettings.buffersize eq 0> readOnly="true"</cfif> tabindex="1" /> KB&nbsp;
					<input type="checkbox" name="bufferentirepage" id="bufferentirepage" value="1" 
							onclick="javascript:updateBufferSettings();"<cfif serverSettings.buffersize eq 0> checked="true"</cfif> 
							tabindex="2" /><label for="bufferentirepage">Buffer Entire Page</label>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Whitespace Compression</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="whitespacecomp" id="whitespacecompTrue" value="true"
							<cfif serverSettings.whitespacecomp> checked="true"</cfif> tabindex="3" />
					<label for="whitespacecompTrue">Yes</label>&nbsp;
					<input type="radio" name="whitespacecomp" id="whitespacecompFalse" value="false"
							<cfif not serverSettings.whitespacecomp> checked="true"</cfif> tabindex="4" />
					<label for="whitespacecompFalse">No</label>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="errorhandler">Default Error Handler</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="errorhandler" id="errorhandler" size="40" value="#serverSettings.errorhandler#" 
							tabindex="5" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="missingtemplatehandler">Missing Template Handler</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="missingtemplatehandler" id="missingtemplatehandler" size="40" 
							value="#serverSettings.missingtemplatehandler#" tabindex="6" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="defaultcharset">Default Character Set</label></td>
				<td bgcolor="##ffffff">
					<select name="defaultcharset" id="defaultcharset" tabindex="6">
					<cfloop collection="#charsets#" item="charset">
						<option value="#charset#"<cfif serverSettings.defaultcharset is charset> selected="true"</cfif>>#charset#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Global Script Protection</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="scriptprotect" id="scriptprotectTrue" value="true"
							<cfif serverSettings.scriptprotect> checked="true"</cfif> tabindex="7" />
					<label for="scriptprotectTrue">Yes</label>&nbsp;
					<input type="radio" name="scriptprotect" id="scriptprotectFalse" value="false"
							<cfif not serverSettings.scriptprotect> checked="true"</cfif> tabindex="8" />
					<label for="scriptprotectFalse">No</label>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="scriptsrc">Default CFFORM Script Source Location</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="scriptsrc" id="scriptsrc" size="40" value="#serverSettings.scriptsrc#" tabindex="9" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="tempdirectory">Temp Directory Location</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="tempdirectory" id="tempdirectory" size="40" value="#serverSettings.tempdirectory#" 
							tabindex="10" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="componentcfc">Base ColdFusion Component (CFC)</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="componentcfc" id="componentcfc" size="40" value="#serverSettings['component-cfc']#" 
							tabindex="11" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" tabindex="12" />
				</td>
			</tr>
		</table>
		</form>
		
		<p><strong>Important Information Concerning Physical Paths</strong></p>
		
		<ul>
			<li>
				When specifying a full physical path on UNIX-based systems (including GNU/Linux and Mac OS X), you must place 
				a "$" at the beginning of the path. For example:<br />
				$/usr/local/myPath/myErrorHandler.cfm
			</li>
			<li>
				A path beginning with "/" is interpreted as a relative path from the web application root directory, which 
				may be a subdirectory of the WEB-INF directory.
			</li>
		</ul>
		
		<p><strong>Important Information Concerning the Base ColdFusion Component (CFC)</strong></p>
		
		<ul>
			<li>
				If you change this value, PLEASE use caution and ensure that the CFC file being used is error free,
				and that the path to the CFC file is valid. Upon submitting the form the application will attempt to 
				read the physical CFC file, but this does not ensure that an error in the CFC itself will not cause 
				global problems on this instance of OpenBD. If problems do occur, the value must be changed in 
				/WEB-INF/bluedragon/bluedragon.xml (preferably back to its deafult value of /WEB-INF/bluedragon/component.cfc) 
				and the OpenBD instance must be restarted.
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>
