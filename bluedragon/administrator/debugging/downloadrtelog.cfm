<cfset fullPath = "#ExpandPath('/WEB-INF/bluedragon/work/temp/rtelogs')#/#url.rteLog#" />
<cfheader name="Content-disposition" value="attachment;filename=#url.rteLog#" />
<cfcontent type="text/plain" file="#fullPath#" />
