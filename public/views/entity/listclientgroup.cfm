<cfset clientGroupSmartList = $.PhiaPlan.getService("planService").getclientGroupSmartList() />
<cfif !$.PhiaPlan.getAccount().getSuperUserFlag()>
	<cfset clientGroupSmartList.addFilter("client_accounts_accountID",$.PhiaPlan.getAccount().getAccountID()) />
</cfif>
<cfset clientGroupSmartList.addOrder("clientGroupName") />

<cfoutput>
<div class="row">
	<cfif !isNull($.PhiaPlan.getAccount().getClient())>
		<div class="span12">
			#$.PhiaPlan.getAccount().getClient().getDashboardCopy()#
		</div>
	</cfif>
	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>Client Management</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<div class="span12 pull-right">
						<div class="btn-group pull-right">
							<cf_phiaActionCaller action="public:entity.createclientgroup" icon="plus-sign" class="btn" text=" New Client Group" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<cf_HibachiListingDisplay smartList="#clientGroupSmartList#"
						   recordEditAction="public:entity.editclientgroup"
						   recordDetailAction="public:entity.detailclientgroup">
	<cfif $.PhiaPlan.getAccount().getSuperUserFlag()>
		<cf_HibachiListingColumn propertyIdentifier="client.clientName" title="Client" filter="false" tdclass="primary" />
	</cfif>
	<cf_HibachiListingColumn propertyIdentifier="clientGroupName" title="Company Name" tdclass="primary" />
	<cf_HibachiListingColumn propertyIdentifier="CreatedDateTime" title="Created" />

</cf_HibachiListingDisplay>
</cfoutput>
