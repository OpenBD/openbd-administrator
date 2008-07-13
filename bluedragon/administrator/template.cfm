<cfsilent>
	<cfscript>
		contextPath = getPageContext().getRequest().getContextPath();
		
		if (contextPath is "/") {
			contextPath = "";
		}
	</cfscript>
</cfsilent>
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>Open BlueDragon Administrator</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="StyleSheet" href="#contextPath#/bluedragon/administrator/css/sinorcaish-screen.css" type="text/css" media="screen" />
  <link rel="StyleSheet" href="#contextPath#/bluedragon/administrator/css/sinorcaish-print.css" type="text/css" media="print" />
</head>

<body>

<!-- For non-visual or non-stylesheet-capable user agents -->
<div id="mainlink"><a href="##main">Skip to main content.</a></div>


<!-- ======== Header ======== -->

<div id="header">
  <div class="left">
    <p><a href="http://www.openbluedragon.org/">OpenBD<span class="alt">Admin</span></a></p>
  </div>

  <div class="right">
    <span class="hidden">Useful links:</span>
    <a href="http://www.openbluedragon.org" target="new">Open BlueDragon Web Site</a> | 
    <a href="http://groups.google.com/group/openbd">Open BlueDragon Google Group</a> | 
	<a href="http://code.google.com/p/openbluedragon-admin-app/">Open BlueDragon Admin Console Project</a>
  </div>

  <div class="subheader">
    <span class="hidden">Navigation:</span>
    <a href="#contextPath#/bluedragon/administrator/index.cfm">Home</a> |
    <a href="#contextPath#/bluedragon/administrator/logout.cfm">Logout</a>
    <!--- <a class="highlight" href="index.html">Other</a> --->
  </div>
</div>


<!-- ======== Left Sidebar ======== -->

<div id="sidebar">
  <!--- <div>	
    <p class="title"><a href="index.html">Other</a></p>
    <ul>
      <li><a href="index.html">Overview</a></li>
      <li class="highlight"><a href="template.html">Template</a>
        <span class="hidden">(this page)</span></li>
      <li><a href="sample.html">Sample Page</a></li>
    </ul>
  </div> --->
  <div>	
    <p class="title">Server</p>
	<ul>
		<li><a href="#contextPath#/bluedragon/administrator/settings/security.cfm">Security</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/systeminfo.cfm">System Information</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/index.cfm">Settings</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/caching.cfm">Caching</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/variables.cfm">Variables</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/mappings.cfm">Mappings</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/mail.cfm">Mail</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/fonts.cfm">Fonts</a></li>
		<li><a href="#contextPath#/bluedragon/administrator/settings/threads.cfm">Threads</a></li>
	</ul>
    <!--- <ul>
      <li><a href="index.html">Overview</a></li>
      <li class="highlight"><a href="template.html">Template</a>
        <span class="hidden">(this page)</span></li>
      <li><a href="sample.html">Sample Page</a></li>
    </ul> --->
  </div>
  <div>
	<p class="title">Data &amp; Services</p>
	<ul>
		<li><a href="#contextPath#/bluedragon/administrator/datasources/index.cfm">Datasources</a></li>
	</ul>
  </div>
  <div>
	<p class="title">Debugging &amp; Logging</p>
	<!--- <ul>
		<li><a href="#contextPath#/bluedragon/administrator/debugging/index.cfm">Datasources</a></li>
	</ul> --->
  </div>
  <div>
	<p class="title">Extensions</p>
	<!--- <ul>
		<li><a href="#contextPath#/bluedragon/administrator/extensions/index.cfm">Datasources</a></li>
	</ul> --->
  </div>
</div>


<!-- ======== Main Content ======== -->

<div id="main">

<!--- <div id="navhead">
  <hr />
  <span class="hidden">Path to this page:</span>
  <a href="index.html">Home</a> &raquo;
  <a href="index.html">Other</a> &raquo;
</div> --->

#request.content#

<br id="endmain" />
</div>


<!-- ======== Footer ======== -->

<div id="footer">
  <hr />
  Copyright &copy; 2008<cfif DatePart("yyyy", now()) gt 2008> - #DatePart("yyyy", now())#</cfif> <a href="http://www.openbluedragon.org">Open BlueDragon Project</a>
  <br />
</div>

</body>
</html>
</cfoutput>