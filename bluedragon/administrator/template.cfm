<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <title>Open BlueDragon Administrator</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="StyleSheet" href="#getPageContext().getRequest().getContextPath()#/bluedragon/administrator/css/sinorcaish-screen.css" type="text/css" media="screen" />
  <link rel="StyleSheet" href="#getPageContext().getRequest().getContextPath()#/bluedragon/administrator/css/sinorcaish-print.css" type="text/css" media="print" />
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
    <a href="index.html">Contacts</a> |
    <a href="index.html">Feedback</a> |
    <a href="index.html">Search</a> |
    <a href="index.html">About</a>
  </div>

  <div class="subheader">
    <span class="hidden">Navigation:</span>
    <a href="index.html">Home</a> |
    <a href="index.html">Products</a> |
    <a href="index.html">Services</a> |
    <a href="index.html">Support</a> |
    <a href="index.html">About</a> |
    <a class="highlight" href="index.html">Other</a>
  </div>
</div>


<!-- ======== Left Sidebar ======== -->

<div id="sidebar">
  <div>
    <p class="title"><a href="index.html">Other</a></p>
    <ul>
      <li><a href="index.html">Overview</a></li>
      <li class="highlight"><a href="template.html">Template</a>
        <span class="hidden">(this page)</span></li>
      <li><a href="sample.html">Sample Page</a></li>
    </ul>
  </div>
</div>


<!-- ======== Main Content ======== -->

<div id="main">

<div id="navhead">
  <hr />
  <span class="hidden">Path to this page:</span>
  <a href="index.html">Home</a> &raquo;
  <a href="index.html">Other</a> &raquo;
</div>

#request.content#

<br id="endmain" />
</div>


<!-- ======== Footer ======== -->

<div id="footer">
  <hr />
  Copyright &copy; 2004, John Zaitseff.  All rights reserved.
  <span class="notprinted">
    <a href="index.html">Terms of Use</a>.
    <a href="index.html">Privacy Policy</a>.
  </span>
  <br />

  This web site is maintained by
  <a href="mailto:J.Zaitseff@zap.org.au">John Zaitseff</a>.
  Last modified: 18th November, 2004.
</div>

</body>
</html>
</cfoutput>