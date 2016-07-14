<cfset planDocumentTemplateSmartList = $.PhiaPlan.getService("planService").getPlanDocumentTemplateSmartList() />
<cfif !$.PhiaPlan.getAccount().getSuperUserFlag()>
	<cfset planDocumentTemplateSmartList.addFilter("checklist_client_clientID",$.PhiaPlan.getAccount().getClient().getClientID()) />
</cfif>

<cfset checklistSmartList = $.PhiaPlan.getService("planService").getchecklistSmartList() />
<cfif !$.PhiaPlan.getAccount().getSuperUserFlag()>
	<cfset checklistSmartList.addFilter("client_clientID",$.PhiaPlan.getAccount().getClient().getClientID()) />
</cfif>
<cfset checklistSmartList.addOrder("checklistName") />

<div class="row">
	<div class="span12">
		<div class="row-fluid">
			<div class="span6">
				<h3>Master Plan Documents</h3>
			</div>			
			
			<!---<div class="span6">
				<div class="btn-group pull-right">
					<a class="btn" href="/?PPAction=entity.createplanDocumentTemplate"><i class="icon-plus-sign"></i> New Master Plan Document</a>	
				</div>
			</div>--->
		</div>		
	</div>
		
	<div class="span12">
		<cfoutput>
			<cf_HibachiListingDisplay smartList="#planDocumentTemplateSmartList#"
									   recordDetailAction="entity.detailplanDocumentTemplate">
				<cf_HibachiListingColumn propertyIdentifier="checklist.checklistName" title="Checklist" />
				<cf_HibachiListingColumn propertyIdentifier="planDocumentTemplateCode" search="true" />
				<cf_HibachiListingColumn propertyIdentifier="planDocumentTemplateName" search="true" tdclass="primary" />
				<cf_HibachiListingColumn propertyIdentifier="activeFlag" search="true" />
			</cf_HibachiListingDisplay>
		</cfoutput>
	</div>
</div>

<div class="row">
	<div class="span12">
	<hr>
	</div>
</div>

<cfoutput>
<div class="row">
	<div class="span12">
		<div class="row-fluid">
			<div class="span6">
				<h3>Master Checklists</h3>
			</div>			
			
			<!---<div class="span6">
				<div class="btn-group pull-right">
					<a class="btn" href="/?PPAction=entity.createchecklist"><i class="icon-plus-sign"></i> New Master Checklist</a>	
				</div>
			</div>--->
		</div>		
	</div>
	
	<div class="span12">
		<cfoutput>
			<cf_HibachiListingDisplay smartList="#checklistSmartList#"
									   recordDetailAction="entity.detailchecklist">
				<cf_HibachiListingColumn propertyIdentifier="client.clientName" search="true" title="Phia Client" />
				<cf_HibachiListingColumn propertyIdentifier="checklistCode" search="true" />
				<cf_HibachiListingColumn propertyIdentifier="checklistName" search="true" tdclass="primary" />
				<cf_HibachiListingColumn propertyIdentifier="activeFlag" search="true" />
				
				<cf_HibachiListingColumn propertyIdentifier="createdDateTime" search="true" />
				<cf_HibachiListingColumn propertyIdentifier="modifiedDateTime" search="true" />
			</cf_HibachiListingDisplay>
		</cfoutput>
		
	</div>
</div>
</cfoutput>