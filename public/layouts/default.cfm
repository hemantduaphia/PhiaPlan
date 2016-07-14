<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" /> 
<cfheader name="cache-control" value="post-check=0, pre-check=0" /> 
<cfheader name="last-modified" value="#now()#" /> 
<cfheader name="pragma"  value="no-cache" />

<cfparam name="rc.pageTitle" default="" />
<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv=Content-Type content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
		
		<meta charset="utf-8">
		<title>#rc.pageTitle#</title>
		
		<link rel="icon" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<link href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,400italic,600,700" rel="stylesheet" type="text/css">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/bootstrap.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/theme.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/style.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/font-awesome.min.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/jquery.qtip.min.css" rel="stylesheet">
			
		<!--[if lt IE 8]><link rel="stylesheet" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/bootstrap-ie7buttonfix.css"><![endif]-->
		<!--[if IE 8]><link rel="stylesheet" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/bootstrap-ie8buttonfix.css"><![endif]-->
		
		<!--- <link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.min.css" rel="stylesheet"> --->
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.8.16.custom.css" rel="stylesheet">
		<!--- <link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/global.css" rel="stylesheet"> --->
		
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/assets/js/jquery.blockUI.js"></script>
		
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/assets/js/jquery.fancybox.js?v=2.1.4"></script>
		<link rel="stylesheet" type="text/css" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/jquery.fancybox.css?v=2.1.4" media="screen" />
		
		<script type="text/javascript">
			var hibachi = {
				dateFormat : 'mm/dd/yyyy'
				,timeFormat : 'hh:mm'
				,rootURL : '#rc.fw.getHibachiScope().getBaseURL()#'
			};
		</script>
		
		<script>
		  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		
		  ga('create', 'UA-53815934-1', 'auto');
		  ga('send', 'pageview');
		
		</script>		
		
		<script src="http://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
		<script src="http://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	</head>
	<body>

	<cfparam name="modalView" default="false" />
	<cfparam name="previewOnly" default="false" />
	<cfif modalView EQ "false" AND previewonly EQ "false">
		<cfinclude template = "header.cfm">
	</cfif>
	
	<div class="container">
		#body#
	</div>
	
	<cfif modalView EQ "false">
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.8.20.custom.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-0.9.9.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-hashchange-1.3.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="/assets/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/assets/js/jquery.qtip.min.js"></script>
		#rc.fw.getHibachiScope().renderJSObject()#
		<script type="text/javascript">
			var hibachiConfig = $.phiaplan.getConfig();
		</script>
		<cfif previewonly EQ "false">
			<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/assets/js/global.js"></script>
			<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/assets/js/app.js"></script>
		</cfif>
	</cfif>
	</body>
</html>
</cfoutput>
