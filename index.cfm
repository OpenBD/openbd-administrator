<cfoutput>getTickCount(): #getTickCount()#</cfoutput>

<cfset startTime = createObject("java", "com.naryx.tagfusion.cfm.engine.cfEngine").thisInstance.startTime />

<cfoutput>startTime: #startTime#</cfoutput>
