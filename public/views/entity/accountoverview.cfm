<cfparam name="rc.account" type="any" />
	
<cfoutput>
<div class="row">

	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>My Account</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				
			</div>
		</div>
	</div>
</div>

<div class="row" id="myAccountRow">
	<div class="span3">
		<span>Name:</span>
		#rc.account.getFirstName()# #rc.account.getLastName()#
	</div>
	
	<div class="span3">
		<span>Company:</span>
		#rc.account.getCompany()#
	</div>
	
	<div class="span3">
		<span>E-Mail Address:</span>
		#rc.account.getPrimaryEmailAddress().getEmailAddress()#
	</div>
	
	<div class="span3">
		<a href="/?PPAction=public:entity.preprocessaccount&processContext=changePassword" class="btn btn-small">Change Password</a>
	</div>
</div>		
</cfoutput>

<cfif $.PhiaPlan.getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.listAccount',$.PhiaPlan.getAccount())>
	
	<cfset accountSmartList = $.PhiaPlan.getService("planService").getAccountSmartList() />
	<cfset accountSmartList.addFilter("client_clientID",$.PhiaPlan.getAccount().getClient().getClientID()) />
	<cfset accountSmartList.addOrder("lastName") />
	
	<hr>
		
	<div class="row">
		<div class="span12">
			<div class="row">
				<div class="span4">
					<h3>Account Management</h3>
				</div>
				<div class="span7 pull-right offset1 pageIconsBar">
					<a class="btn pull-right" href="/?PPAction=public:entity.preprocessaccount&processContext=create">New Account</a>
				</div>
			</div>
		</div>
	</div>	
		
	<div class="row">
		<div class="span12">

			<cf_HibachiListingDisplay smartList="#accountSmartList#"
									   recordEditAction="entity.editaccount">
				<cf_HibachiListingColumn propertyIdentifier="firstName" search="true" />
				<cf_HibachiListingColumn propertyIdentifier="lastName" search="true" />
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="company" />
				<cf_HibachiListingColumn propertyIdentifier="primaryEmailAddress.emailAddress" search="true" />
			</cf_HibachiListingDisplay>
		</div>
	</div>
</cfif>