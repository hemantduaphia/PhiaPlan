<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>#rc.pageTitle# &##124; Hibachi</title>
		
		<link rel="icon" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<link rel="shortcut icon" href="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/favicon.png" type="image/png" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/bootstrap.2.3.2.min.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui-1.8.16.custom.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/css/global.css" rel="stylesheet">
		<link href="#rc.fw.getHibachiScope().getBaseURL()#/assets/css/admin.css" rel="stylesheet">
		
		<script type="text/javascript">
			var hibachi = {
				dateFormat : 'mm/dd/yyyy'
				,timeFormat : 'hh:mm'
				,rootURL : '#rc.fw.getHibachiScope().getBaseURL()#'
			};
		</script>
	</head>
	<body>
		<div class="navbar navbar-fixed-top navbar-inverse">
			<div class="navbar-inner">
				<div class="container-fluid">
					<ul class="nav">
						<cfset homeLink = rc.fw.getHibachiScope().getBaseURL() />
						<cfif not len(homeLink)>
							<cfset homeLink = "/?PPAction=admin:main" />
						</cfif>
						<a href="#homeLink#" class="brand brand-two"><img src="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/admin-logo.png" style="width:100px;heigh:16px;" title="Hibachi" /></a>
						<li class="divider-vertical"></li>
						<cf_HibachiActionCallerDropdown title="#rc.fw.getHibachiScope().rbKey('admin.default.PlanManagement_nav')#" icon="inbox icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listclient" type="list">
							<cf_HibachiActionCaller action="admin:entity.listchecklist" type="list">
							<cf_HibachiActionCaller action="admin:entity.listplandocumenttemplate" type="list">
							<cf_HibachiActionCaller action="admin:entity.listalltrackedanswer" type="list">
							<cf_HibachiActionCaller action="admin:entity.listcomment" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#rc.fw.getHibachiScope().rbKey('admin.default.accounts_nav')#" icon="user icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listaccount" type="list">
							<cf_HibachiActionCaller action="admin:entity.listpermissiongroup" type="list">
							<cf_HibachiActionCaller action="admin:entity.listsession" type="list">
						</cf_HibachiActionCallerDropdown>
						<cf_HibachiActionCallerDropdown title="#rc.fw.getHibachiScope().rbKey('define.system')#" icon="cog icon-white" type="nav">
							<cf_HibachiActionCaller action="admin:entity.listtype" type="list">
							<cf_HibachiActionCaller action="admin:entity.listemailtemplate" type="list">
						</cf_HibachiActionCallerDropdown>
					</ul>
					<cfif rc.fw.getHibachiScope().getLoggedInAsAdminFlag()>
						<div class="pull-right">
							<ul class="nav">
								<cf_HibachiActionCallerDropdown title="" icon="user icon-white" dropdownclass="pull-right" type="nav">
									<cf_HibachiActionCaller action="admin:entity.detailaccount" querystring="accountID=#rc.fw.getHibachiScope().getAccount().getAccountID()#" type="list">
									<cf_HibachiActionCaller action="admin:main.logout" type="list">
								</cf_HibachiActionCallerDropdown>
								<li class="divider-vertical"></li>
							</ul>
							<form name="search" class="navbar-search" action="/" onSubmit="return false;">
								<input id="global-search" type="text" name="serach" class="search-query span2" placeholder="Search">
							</form>
						</div>
					</cfif>
				</div>
			</div>
		</div>
		<div id="search-results" class="search-results">
			<div class="container-fluid">
				<div class="row-fluid">
					<div class="span3 result-bucket">
						<h4>Object One</h4>
						<ul class="nav" id="golbalsr-product">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>Object Two</h4>
						<ul class="nav" id="golbalsr-productType">
						</ul>
					</div>
					<div class="span3  result-bucket">
						<h4>Object Three</h4>
						<ul class="nav" id="golbalsr-brand">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>Object Four</h4>
						<ul class="nav" id="golbalsr-promotion">
						</ul>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span3 result-bucket">
						<h4>Object Five</h4>
						<ul class="nav" id="golbalsr-order">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>Object Six</h4>
						<ul class="nav" id="golbalsr-account">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>Object Seven</h4>
						<ul class="nav" id="golbalsr-vendorOrder">
						</ul>
					</div>
					<div class="span3 result-bucket">
						<h4>Object Eight</h4>
						<ul class="nav" id="golbalsr-vendor">
						</ul>
					</div>
				</div>
				<div class="row-fluid">
					<div class="span12">
						<a class="close search-close"><span class="text">Close</span> &times;</a>
					</div>
				</div>
			</div>
		</div>
		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span12">
					#body#
				</div>
			</div>
		</div>
		<div id="adminModal" class="modal fade"></div>
		<div id="adminDisabled" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#rc.fw.getHibachiScope().rbKey('define.disabled')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-ok icon-white"></i> #rc.fw.getHibachiScope().rbKey('define.ok')#</a>
			</div>
		</div>
		<div id="adminConfirm" class="modal">
			<div class="modal-header"><a class="close" data-dismiss="modal">&times;</a><h3>#rc.fw.getHibachiScope().rbKey('define.confirm')#</h3></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<a href="##" class="btn btn-inverse" data-dismiss="modal"><i class="icon-remove icon-white"></i> #rc.fw.getHibachiScope().rbKey('define.no')#</a>
				<a href="##" class="btn btn-primary"><i class="icon-ok icon-white"></i> #rc.fw.getHibachiScope().rbKey('define.yes')#</a>
			</div>
		</div>
		
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-1.8.20.custom.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui-timepicker-addon-0.9.9.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-validate-1.9.0.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-hashchange-1.3.min.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-typewatch-2.0.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/bootstrap.2.3.2.min.js"></script>
		#rc.fw.getHibachiScope().renderJSObject()#
		<script type="text/javascript">
			var hibachiConfig = $.phiaplan.getConfig();
		</script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/HibachiAssets/js/global.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#rc.fw.getHibachiScope().getBaseURL()#/org/Hibachi/ckfinder/ckfinder.js"></script>
	</body>
</html>
</cfoutput>
