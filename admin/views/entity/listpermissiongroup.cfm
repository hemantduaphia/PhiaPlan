<cfparam name="rc.permissionGroupSmartList" type="any" />

<cfoutput>
	
<cf_HibachiEntityActionBar type="listing" object="#rc.permissionGroupSmartList#" />

<cf_HibachiListingDisplay smartList="#rc.permissionGroupSmartList#" recordDetailAction="admin:entity.detailpermissiongroup" recordEditAction="admin:entity.editpermissiongroup">
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="permissionGroupName" search="true" />
</cf_HibachiListingDisplay>

</cfoutput>