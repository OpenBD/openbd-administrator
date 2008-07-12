<!---
	Copyright (C) 2008  David C. Epler - dcepler@dcepler.net

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--->
<cfcomponent name="administrator" extends="bluedragon.adminapi.base" displayname="administrator [BD AdminAPI]" hint="Basic Administrator functionality">

	<cffunction access="public" name="login" output="false" returntype="boolean">
		<cfargument name="adminPassword" type="string" required="true">
		
<!---
		<cflock scope="server" type="readonly" timeout="10">
			<cftry>
			<cfadmin password="#arguments.adminPassword#" action="read">
			<cfcatch type="any">
				<cfset setSessionPassword("") />
				<cfreturn FALSE />
			</cfcatch>
			</cftry>
		</cflock>
--->
		<cfset setSessionPassword(arguments.adminPassword) />
		
		<cfreturn TRUE>
	</cffunction>

	<cffunction access="public" name="logout" output="false" returntype="boolean">
		<cfset setSessionPassword("") />
		<cfreturn TRUE>
	</cffunction>

</cfcomponent>