<cfparam name="rc.emailTemplate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.emailTemplate#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.emailTemplate#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTemplateCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailSubject" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailTo" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailFrom" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailCC" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="emailBCC" edit="#rc.edit#">
				<cfif !rc.emailTemplate.isNew()>
					<cf_HibachiPropertyDisplay object="#rc.emailTemplate#" property="isDefault" edit="false">
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>

		<cf_HibachiTabGroup object="#rc.emailTemplate#">
			<cf_HibachiTab property="emailBodyHTML">
			<cf_HibachiTab property="clients">
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>
</cfoutput>

