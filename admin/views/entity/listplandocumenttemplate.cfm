<cfparam name="rc.planDocumentTemplateSmartList" type="any" />
<cfscript>
	rc.planDocumentTemplateSmartList.addFilter("activeFlag",1);
</cfscript>


<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.planDocumentTemplateSmartList#" />
	
	<cf_HibachiListingDisplay smartList="#rc.planDocumentTemplateSmartList#"
							   recordEditAction="admin:entity.editplanDocumentTemplate"
							   recordDetailAction="admin:entity.detailplanDocumentTemplate">
		<cf_HibachiListingColumn propertyIdentifier="checklist.checklistName" title="Checklist" />
		<cf_HibachiListingColumn propertyIdentifier="planDocumentTemplateCode" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="planDocumentTemplateName" search="true" tdclass="primary" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" search="true" filter="true" />
	</cf_HibachiListingDisplay>
</cfoutput>