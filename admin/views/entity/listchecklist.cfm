<cfparam name="rc.checklistSmartList" type="any" />
<cfscript>
	rc.checklistSmartList.addFilter("activeFlag",1);
</cfscript>

<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.checklistSmartList#" />
	
	<cf_HibachiListingDisplay smartList="#rc.checklistSmartList#"
							   recordEditAction="admin:entity.editchecklist"
							   recordDetailAction="admin:entity.detailchecklist">
		<cf_HibachiListingColumn propertyIdentifier="client.clientName" search="true" title="Phia Client" actionCallerAttributes="#{action='admin:entity.detailclient',queryString='clientID=${client.clientID}'}#" />
		<cf_HibachiListingColumn propertyIdentifier="checklistCode" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="checklistName" search="true" tdclass="primary" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" search="true" />
	</cf_HibachiListingDisplay>
</cfoutput>