<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">

<head>
	<title>Getfused CMS Lite</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<link rel="stylesheet" href="/assets/css/admin.css" type="text/css"/>
	<link rel="stylesheet" href="/assets/jquery-ui-1.8.4/css/custom-theme/jquery-ui-1.8.4.custom.css" type="text/css"/>

	<script src="http://ajax.microsoft.com/ajax/jquery/jquery-1.4.2.min.js"></script>
	<script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery.validate/1.7/jquery.validate.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.3/jquery-ui.min.js" type="text/javascript"></script>
	<link rel="stylesheet" media="screen" href="/assets/js/jquery.ptTimeSelect.css" type="text/css" />
	<script type="text/javascript" src="/assets/js/jquery.ptTimeSelect.js"></script>
</head>

<body>
	<div id="header"></div>
	<!--Begin Header items "background: url('/assets/images/admin/header_bg.png')-->
	<div class="wrapper" style=" repeat-x; height:100px;">
		<div id="logo"></div>
		<div id="user_actions">
			<cfif getSessionObject().getIsLoggedIn()>
				<cfoutput>
				Logged in as #getSessionObject().getUser().getFirstName()# #getSessionObject().getUser().getLastName()# &nbsp;&nbsp;
				<a href="#CGI.SCRIPT_NAME#">Home</a>&nbsp;|
				<a href="#CGI.SCRIPT_NAME#?ac=admin.logout">Logout</a>
				</cfoutput>
			</cfif>
		</div>
		
	</div>
	<!-- End Header -->

	<!--Begin Navigation Menu-->
	<div id="nav">
		<div class="wrapper">
			<ul>
				<li class="first">Content Management</li>
			</ul>
		</div>

	</div>
	<!--End Navigation Menu-->   
	
	    
	<!--Begin Content Section-->	
	<div class="wrapper">
		<table cellpadding="0" cellspacing="0" border="0" style="border:0px; width:100%">
			<tr>
				<td valign="top" style="border:0px; padding:3px; margin:0px; width:250px;">
					<div id="sidebar">
						<cfif getSessionObject().getIsLoggedIn()>
							<cfset renderView(viewName:'admin.vwNavigation', event:'page.navigation') />
						</cfif>
					</div>
				</td>
				
				<td style="width:100%; border:0px; padding:0px;" valign="top">
					<div id="content" style="margin:0 auto;"">
						<div style="margin:0 auto; width:980px; background-repeat:no-repeat; text-align:left; ">
							<cfset renderView(viewName:'admin.vwValidationError') />
							<cfset renderView() />
						</div>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<!--End Content Section-->

</body>
</html>