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
	<cfset errorFieldList = "" />
	
	<cfif structKeyExists(session, "errorFields")>
		<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
			<cfset errorFieldList = listAppend(errorFieldList, session.errorFields[i][1], ",") />
		</cfloop>
	</cfif>
	
	<cfsetting showdebugoutput="false" />
</cfsilent>
<cfsavecontent variable="request.content">
	<cfoutput>
		<div align="center" valign="middle" style="margin-top:100px;">
			<form name="loginForm" action="_loginController.cfm?action=processLoginForm" method="post">
				<table border="0" bgcolor="##999999" cellpadding="2" cellspacing="1" width="500">
					<tr>
						<td>
							<table border="0" width="100%" bgcolor="##ffffff">
								<tr>
									<td colspan="2"><img src="images/openBD-500.jpg" width="500" height="98" /></td>
								</tr>
							<cfif structKeyExists(session, "errorFields")>
								<tr>
									<td colspan="2">
										<cfloop index="i" from="1" to="#arrayLen(session.errorFields)#">
											<span style="color:##ff0000;font-weight:bold;margin-left:20px;">&bull; #session.errorFields[1][2]#</span><cfif i lt arrayLen(session.errorFields)><br /></cfif>
										</cfloop>
									</td>
								</tr>
							</cfif>
							<cfif structKeyExists(session, "message")>
								<tr>
									<td colspan="2">
										<span style="color:##ff0000;font-weight:bold;margin-left:20px;">&bull; #session.message#</strong>
									</td>
								</tr>
							</cfif>
								<tr>
									<td><strong>Password</strong></td>
									<td><input name="password" type="password" size="30" maxlength="100"<cfif listFind(errorFieldList, "password", ",")> style="border:1px solid ##ff0000;"</cfif> /></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td><input type="submit" value="Login" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</form>
		</div>
		
		<script type="text/javascript">
			document.forms.loginForm.password.focus();
		</script>
	</cfoutput>
	
	<cfset structDelete(session, "message", false) />
	<cfset structDelete(session, "errorFields", false) />
</cfsavecontent>