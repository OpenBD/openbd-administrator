<!---
	Copyright (C) 2005  David C. Epler - dcepler@dcepler.net

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

<cfscript>
	variables.adminPwd = "password";

	// Has sam syntax as CFMX 7
	createObject("component", "bluedragon.adminapi.administrator").login(variables.adminPwd);

//	mailObj = createObject("component", "bluedragon.adminapi.mail");
//	mailObj.setMailServer("localhost", 25);
//	mailObj.setMailProperty("Charset", "US-ASCII");

	extObj_BD = createObject("component", "bluedragon.adminapi.extensions");
	//extObj_CFMX = createObject("component", "cfide.adminapi.extensions");

	JavaCFXs = extObj_BD.getJavaCFX();
	CPPCFXs = extObj_BD.getCPPCFX();
	
	// CFMX only has one function call to get CFXs
	//CFXs = extObj_CFMX.getCFX();

// Create and delete JavaCFX with BD
//	extObj_BD.setJavaCFX("cfx_zog", "com.zog", "this is just a test cfx");
//	extObj_BD.deleteJavaCFX("cfx_zog");

// Create and delete JavaCFX with CFMX
//	extObj_CFMX.setJavaCFX("cfx_zog", "com.zog", "this is just a test cfx");
//	extObj_CFMX.deleteCFX("cfx_zog");

//	Mappings = extObj_BD.getMappings();

// Create and delete Mapping with BD  (CFMX is identical)
//	extObj_BD.setMapping("/nowhere", "/tmp");
//	extObj_BD.deleteMapping("/nowhere");

	customTags_BD = extObj_BD.getCustomTagPaths();
	//customTags_CFMX = extObj_CFMX.getCustomTagPaths();
	
// Create and delete Mapping with BD (CFMX is identical)
//	extObj_BD.setCustomTagPath("/nowhere");
//	extObj_BD.deleteCustomTagPath("/nowhere");

</cfscript>

<h1>BD getJavaCFX()</h1>
<cfdump var="#JavaCFXs#">

<h1>BD getCPPCFX()</h1>
<cfdump var="#CPPCFXs#">

<!--- <h1>CFMX getCFX()</h1>
<cfdump var="#CFXs#"> --->

<!---
<h1>BD getMappings()</h1>
<cfdump var="#Mappings#">
--->

<h1>BD getCustomTagPaths()</h1>
<cfdump var="#customTags_BD#">

<!--- <h1>CFMX getCustomTagPaths()</h1>
<cfdump var="#customTags_CFMX#"> --->


<cfscript>
	
	dsnObj_BD = createObject("component", "bluedragon.adminapi.datasource");
	//dsnObj_CFMX = createObject("component", "cfide.adminapi.datasource");

// Create and delete MySQL datasource with BD
//	dsns = dsnObj_BD.setMySQL("test-mysql", "localhost", "test", "coldfusion", "coldfusion");
//	dsns = dsnObj_BD.deleteDatasource("test-mysql");

	dsn_BD = dsnObj_BD.getDatasources();
	//dsn_CFMX = dsnObj_CFMX.getDatasources();

</cfscript>

<h1>BD getDatasources()</h1>
<cfdump var="#dsn_BD#">

<!--- <h1>CFMX getDatasources()</h1>
<cfdump var="#dsn_CFMX#"> --->
