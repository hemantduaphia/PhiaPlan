<cfparam name="rc.emailTemplateSmartList" type="any" />

<cfoutput>
	
<cf_HibachiEntityActionBar type="listing" object="#rc.emailTemplateSmartList#" createModal="true" />

<cf_HibachiListingDisplay smartList="#rc.emailTemplateSmartList#"
						   recordDetailAction="admin:entity.detailemailTemplate"
						   recordEditAction="admin:entity.editemailTemplate">
	<cf_HibachiListingColumn propertyIdentifier="emailTemplateName" />
	<cf_HibachiListingColumn propertyIdentifier="emailTemplateCode" />
	<cf_HibachiListingColumn propertyIdentifier="emailFrom" />
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="emailSubject" />
	<cf_HibachiListingColumn propertyIdentifier="isDefault" />
</cf_HibachiListingDisplay>

</cfoutput>

