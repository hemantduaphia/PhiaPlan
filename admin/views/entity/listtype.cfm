<cfparam name="rc.typeSmartList" type="any" />

<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.typeSmartList#" showCreate="false" />
	
	<cf_HibachiListingDisplay smartList="#rc.typeSmartList#"
							   recordDetailModal=true
							   recordDetailAction="admin:entity.detailtype"
							   recordEditModal=true
							   recordEditAction="admin:entity.edittype"
							   parentPropertyName="parentType">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="type" />
	</cf_HibachiListingDisplay>

</cfoutput>