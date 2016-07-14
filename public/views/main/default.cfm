
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>Active Documents</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<div class="span12">
						<div class="btn-group pull-right">
							<cf_phiaActionCaller action="public:entity.createclientgroup" icon="plus-sign" class="btn" text=" New Client Group" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="span12 activeDocumentsList">
		<cfset checklistSmartList = $.PhiaPlan.getService("planService").getclientGroupChecklistSmartList() />
		<cfset checklistSmartList.addFilter("checklistStatus.systemCode","cgcsOpen") />
		<cfif !$.PhiaPlan.getAccount().getSuperUserFlag()>
			<cfset allowedChecklistIDs = $.PhiaPlan.getAccount().getallowedClientGroupChecklistIDs() />
			<cfif len(allowedChecklistIDs)>
				<cfset checklistSmartList.addFilter("clientgroupchecklistID",allowedChecklistIDs) />
			<cfelse>
				<cfset checklistSmartList.addFilter("clientgroup_client_clientID",$.PhiaPlan.getAccount().getClient().getClientID()) />
			</cfif>
		</cfif>
		<cfset checklistSmartList.addOrder("clientgroup_clientgroupName") />
		<cf_HibachiListingDisplay smartList="#checklistSmartList#"
								   recordDetailAction="entity.detailclientgroupchecklist">
			<cfif $.PhiaPlan.getAccount().getSuperUserFlag()>
				<cf_HibachiListingColumn propertyIdentifier="clientGroup.client.clientName" title="Client" filter="false"/>
			</cfif>
			<cf_HibachiListingColumn propertyIdentifier="clientGroup.clientGroupName" title="Company" filter="false" tdclass="wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" filter="false" tdclass="wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="checklist.checklistName" title="Master Checklist" filter="false" tdclass="wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="modifiedDateTime" search="false" />
		</cf_HibachiListingDisplay>
	</div>
</div>