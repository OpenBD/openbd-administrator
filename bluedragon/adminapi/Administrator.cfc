<!---
	Copyright (C) 2008 - Open BlueDragon Project - http://www.openbluedragon.org
	
	Contributing Developers:
	David C. Epler - dcepler@dcepler.net
	Matt Woodward - matt@mattwoodward.com

	This file is part of of the Open BlueDragon Admin API.

	The Open BlueDragon Admin API is free software: you can redistribute 
	it and/or modify it under the terms of the GNU General Public License 
	as published by the Free Software Foundation, either version 3 of the 
	License, or (at your option) any later version.

	The Open BlueDragon Admin API is distributed in the hope that it will 
	be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
	of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
	General Public License for more details.
	
	You should have received a copy of the GNU General Public License 
	along with the Open BlueDragon Admin API.  If not, see 
	<http://www.gnu.org/licenses/>.
--->
<cfcomponent displayname="Administrator" 
		output="false" 
		extends="Base" 
		hint="Manages administrator security - OpenBD Admin API">

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