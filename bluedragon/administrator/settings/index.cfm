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
		
		<form name="serverSettings" action="_controller.cfm?action=processServerSettingsForm" method="post" onsubmit="javascript:return validate(this);">
		<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="700">
			<tr>
				<td align="right" bgcolor="##f0f0f0">Response Buffer Size</td>
				<td bgcolor="##ffffff">
					<input type="text" name="buffersize" size="3" value="#serverSettings.buffersize#"<cfif serverSettings.buffersize eq 0> readOnly="true"</cfif> /> KB&nbsp;
					<input type="checkbox" name="bufferentirepage" value="1" onclick="javascript:updateBufferSettings();"<cfif serverSettings.buffersize eq 0> checked="true"</cfif> />Buffer Entire Page
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Whitespace Compression</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="whitespacecomp" value="true"<cfif serverSettings.whitespacecomp> checked="true"</cfif> />Yes&nbsp;
					<input type="radio" name="whitespacecomp" value="false"<cfif not serverSettings.whitespacecomp> checked="true"</cfif> />No
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Default Error Handler</td>
				<td bgcolor="##ffffff">
					<input type="text" name="errorhandler" size="40" value="#serverSettings.errorhandler#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Missing Template Handler</td>
				<td bgcolor="##ffffff">
					<input type="text" name="missingtemplatehandler" size="40" value="#serverSettings.missingtemplatehandler#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Default Character Set</td>
				<td bgcolor="##ffffff">
					<select name="defaultcharset">
					<cfloop collection="#charsets#" item="charset">
						<option value="#charset#"<cfif serverSettings.defaultcharset is charset> selected="true"</cfif>>#charset#</option>
					</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Global Script Protection</td>
				<td bgcolor="##ffffff">
					<input type="radio" name="scriptprotect" value="true"<cfif serverSettings.scriptprotect> checked="true"</cfif> /> Yes&nbsp;
					<input type="radio" name="scriptprotect" value="false"<cfif not serverSettings.scriptprotect> checked="true"</cfif> /> No
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Default CFFORM Script Source Location</td>
				<td bgcolor="##ffffff">
					<input type="text" name="scriptsrc" size="40" value="#serverSettings.scriptsrc#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Temp Directory Location</td>
				<td bgcolor="##ffffff">
					<input type="text" name="tempdirectory" size="40" value="#serverSettings.tempdirectory#" />
				</td>
			</tr>
			<tr>
				<td align="right" bgcolor="##f0f0f0">Base ColdFusion Component (CFC)</td>
				<td bgcolor="##ffffff">
					<input type="text" name="componentcfc" size="40" value="#serverSettings['component-cfc']#" />
				</td>
			</tr>
			<tr bgcolor="##dedede">
				<td>&nbsp;</td>
				<td>
					<input type="submit" name="submit" value="Submit" />
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
				read and instantiate the CFC, but this does not ensure that an error in the CFC itself will not cause 
				global problems on this instance of OpenBD. If problems do occur, the value must be changed in 
				WEB-INF/bluedragon/bluedragon.xml (preferably back to its deafult value of /WEB-INF/bluedragon/component.cfc) 
				and the OpenBD instance must be restarted.
			</li>
		</ul>
	</cfoutput>
	<cfset structDelete(session, "message", false) />
</cfsavecontent>
