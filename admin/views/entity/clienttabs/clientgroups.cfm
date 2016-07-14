<cfparam name="rc.client" default="any" >
<cfoutput>
	
	<cf_HibachiListingDisplay smartList="#rc.client.getClientGroupsSmartList()#"
							   recordEditAction="admin:entity.editClientGroup"
							   recordDetailAction="admin:entity.detailClientGroup">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="clientGroupName" />
	</cf_HibachiListingDisplay>

	<cf_HibachiActionCaller action="admin:entity.createclientgroup" class="btn btn-inverse" icon="plus icon-white" queryString="clientID=#rc.client.getclientID()#" modal=true />
</cfoutput>