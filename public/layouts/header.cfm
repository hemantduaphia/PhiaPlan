<cfoutput>
	<div class="container">
		<!--- Header --->
		<div class="header">
			<div class="navbar navbar_ clearfix">
				<div class="row">
					<!--- Logo --->
					<div class="span4">
						<div class="logo">
							<a href="/"><img src="#rc.fw.getHibachiScope().getBaseURL()#/assets/images/phialogo.png" border="0" alt="Phia" height="85" width="214"></a>
						</div>
						<!--- Client Logo --->
						<cfif $.PhiaPlan.hasSessionValue("accountQuestionnaireID")>
							<cfif len($.PhiaPlan.getAccount().getClient().getLogo())>
								<div class="clientLogo">
									#$.PhiaPlan.getAccount().getClient().getLogoUploadDirectory()#/#$.PhiaPlan.getAccount().getClient().getLogo()#
								</div>	
							</cfif>
						</cfif>
					</div>
					<div class="span8">
						<cfif len($.PhiaPlan.getAccount().getAccountID())>
							<a href="/?PPAction=main.logout" class="logout pull-right">logout</a>
							<a href="/?PPAction=entity.accountoverview" class="logout pull-right">My Account</a>
						</cfif>
						<div class="navBlock" id="main_menu">
							<div class="menu_wrap">
								<ul class="nav sf-menu sf-js-enabled">
									<cfif $.PhiaPlan.getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.listclientgroup',$.PhiaPlan.getAccount())>
										<li><a href="/?PPAction=entity.listclientgroup">Client Management</a></li>
									</cfif>
									<cfif $.PhiaPlan.getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.listchecklist',$.PhiaPlan.getAccount())>
										<li><a href="/?PPAction=entity.listchecklist">Master Documents</a></li>
									</cfif>
									<li><a href="/?PPAction=entity.memberresources" target="_blank">Member Resources</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>