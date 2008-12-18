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
	<cfscript>
		contextPath = getPageContext().getRequest().getContextPath();
		
		if (contextPath is "/") {
			contextPath = "";
		}
		
		theSection = listGetAt(CGI.SCRIPT_NAME, listLen(CGI.SCRIPT_NAME, "/") - 1, "/");
		thePage = listLast(CGI.SCRIPT_NAME, "/");
	</cfscript>
</cfsilent>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>Open BlueDragon Administrator</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="#contextPath#/bluedragon/administrator/images/favicon.ico" />
  <link rel="stylesheet" href="#contextPath#/bluedragon/administrator/css/sinorcaish-screen.css" type="text/css" media="screen" />
  <link rel="stylesheet" href="#contextPath#/bluedragon/administrator/css/sinorcaish-print.css" type="text/css" media="print" />
</head>

<body>
#request.content#
</body>
</html>
</cfoutput>