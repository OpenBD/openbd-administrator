<cfset junk = queryNew("name,value") />
<cfset queryAddRow(junk, 1) />
<cfset querySetCell(junk, "name", "test", 1) />
<cfset querySetCell(junk, "value", "100", 1) />

<cfchart format="jpg">
	<cfchartseries type="bar" query="junk" itemcolumn="name" valuecolumn="value"></cfchartseries>
</cfchart>