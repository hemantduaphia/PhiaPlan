<cfparam name="rc.clientSmartList" type="any" />

<cfoutput>
	
<cf_HibachiEntityActionBar type="listing" object="#rc.clientSmartList#" createModal="true" />

<cf_HibachiListingDisplay smartList="#rc.clientSmartList#" recordDetailAction="admin:entity.detailClient" recordEditAction="admin:entity.editClient">
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="clientName" search="true" />
</cf_HibachiListingDisplay>

</cfoutput>