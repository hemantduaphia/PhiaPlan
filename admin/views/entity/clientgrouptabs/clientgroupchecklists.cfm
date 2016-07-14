<cfparam name="rc.clientGroup" default="any" >
<cfoutput>
	
	<cf_HibachiListingDisplay smartList="#rc.clientGroup.getClientGroupChecklistsSmartList()#"
							   recordEditAction="admin:entity.editClientGroupChecklist"
							   recordDetailAction="admin:entity.detailClientGroupChecklist">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="clientGroupChecklistName" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="checklistStatus.type" title="Status" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="approvedFlag" />
	</cf_HibachiListingDisplay>

</cfoutput>
