<cfparam name="rc.client" default="any" >
<cfoutput>
	
	<cf_HibachiListingDisplay smartList="#rc.client.getAccountsSmartList()#"
							   recordEditAction="admin:entity.editAccount"
							   recordDetailAction="admin:entity.detailAccount">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="fullName" />
	</cf_HibachiListingDisplay>
</cfoutput>