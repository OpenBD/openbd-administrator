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
	
	<cfif not StructKeyExists(serverSettings, "legacyformvalidation")>
		<cfset serverSettings.legacyformvalidation = true />
	</cfif>
	
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
					var cfcfile = '#replace(serverSettings["component-cfc"], "\", "\\", "all")#';
					if (f.componentcfc.value != cfcfile) {
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
			
			function confirmReload() {
				if(confirm("Are you sure you want to reload the configuration settings?")) {
					location.replace("_controller.cfm?action=reloadSettings");
				}
			}
		</script>
		
		<h3>Server Settings</h3>
		
		<p>
			Settings last updated #serverSettings.lastupdated#<br />
		</p>
		
		<cfif structKeyExists(session, "message") and session.message.text is not "">
			<p class="#session.message.type#">#session.message.text#</p>
		</cfif>
		
		<cfif structKeyExists(session, "errorFields") and arrayLen(session.errorFields) gt 0>
			<p class="error">The following errors occurred:</p>
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
				<td colspan="2">
					<strong>Update Server Settings</strong>&nbsp;
					<a href="javascript:void(0);" onclick="javascript:confirmRevert();" alt="Revert to Previous Settings" 
						title="Revert to Previous Settings">
						<img src="../images/arrow_undo.png" height="16" width="16" border="0" />
					</a>&nbsp;
					<a href="javascript:void(0);" onclick="javascript:confirmReload();" alt="Reload Current Settings" 
						title="Reload Current Settings">
						<img src="../images/arrow_refresh.png" height="16" width="16" border="0" />
					</a>
				</td>
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
					<label for="scriptprotectFalse">No</label>&nbsp;
					<img src="../images/arrow_refresh_small.png" height="16" width="16" 
							alt="Requires Server Restart" title="Requires Server Restart" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Support Legacy Form Validation</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="legacyformvalidation" id="legacyformvalidationTrue" 
							value="true"<cfif serverSettings.legacyformvalidation> checked="true"</cfif> 
							tabindex="9" />&nbsp;
					<label for="legacyformvalidationTrue">Yes</label>&nbsp;
					<input type="radio" name="legacyformvalidation" id="legacyformvalidationFalse" 
							value="false"<cfif not serverSettings.legacyformvalidation> checked="true"</cfif> 
							tabindex="10" />
					<label for="legacyformvalidationFalse">No</label>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="scriptsrc">Default CFFORM Script Source Location</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="scriptsrc" id="scriptsrc" size="40" 
							value="#serverSettings.scriptsrc#" tabindex="11" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="tempdirectory">Temp Directory Location</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="tempdirectory" id="tempdirectory" size="40" value="#serverSettings.tempdirectory#" 
							tabindex="12" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="componentcfc">Base ColdFusion Component (CFC)</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="componentcfc" id="componentcfc" size="40" value="#serverSettings['component-cfc']#" 
							tabindex="13" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0"><label for="servercfc">Server CFC</label></td>
				<td bgcolor="##ffffff">
					<input type="text" name="servercfc" id="servercfc" size="40" value="#serverSettings.servercfc#" 
							tabindex="14" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Verify Path Settings?</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="verifypathsettings" id="verifypathsettingsTrue" value="true" checked="true" tabindex="15" />
					<label for="verifypathsettingsTrue">Yes</label>&nbsp;
					<input type="radio" name="verifypathsettings" id="verifypathsettingsFalse" value="false" tabindex="16" />
					<label for="verifypathsettingsFalse">No</label>
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" tabindex="17" />
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
			<li>
				A path beginning with "$../" is interpreted as relative to the servlet container's home JVM property. 
				For example, on Tomcat this would be relative to catalina.home, and on Jetty this would be relative to 
				jetty.home.
			</li>
			<li>
				If "Verify Path Settings" in the form above is set to "Yes," an attempt will be made to perform a read operation on 
				the directories (or in the case of the Base CFC, the file) provided when the form is submitted. If the read operation 
				is not successful, the settings will not be saved. If you are running OpenBD in an unusual environment for which read 
				operations on the directories provided are not successful, but you wish to save the settings regardless, you must set 
				"Verify Path Settings" to "No" in order for the settings to be saved.
			</li>
		</ul>

		<p><strong>Important Information Concerning Configuration Settings</strong></p>
		<ul>
			<li>
				Clicking "Revert to Previous Settings" will reload all OpenBD configuration settings using the XML 
				configuration file that is one revision older than the current file.
			</li>
			<li>
				Clicking "Reload Current Settings" will force a reload of all OpenBD configuration settings from 
				the current bluedragon.xml configuration file. One use for this function is if the bluedragon.xml 
				file is manually replaced with a different bluedragon.xml file, OpenBD will need to be forced 
				to reload the configuration settings. Using this function avoids having to restart OpenBD, other than 
				if a specific configuration setting requires a server restart.
			</li>
			<li>
				If the configuration settings are changed using either the "Revert to Previous" or "Reload Current" functions, 
				and one of the settings within the updated configuration file requires a server restart to take effect 
				(e.g. "Global Script Protection" and "ColdFusion 5-compatible client data" on the variables settings page), 
				using these functions will not eliminate the need for a server restart.
			</li>
		</ul>
		
		<p><strong>Important Information Concerning the Base ColdFusion Component (CFC)</strong></p>
		
		<ul>
			<li>
				If you change this value, PLEASE use caution and ensure that the CFC file being used is error free,
				and that the path to the CFC file is valid. Upon submitting the form the application will attempt to 
				read the physical CFC file (provided you have "Verify Path Settings" set to "Yes"), but this does not 
				ensure that an error in the CFC itself will not cause global problems on this instance of OpenBD. 
				If problems do occur, the value must be changed in the bluedragon.xml configuration file and the 
				OpenBD instance must be restarted.
			</li>
		</ul>
	</cfoutput>
</cfsavecontent>
