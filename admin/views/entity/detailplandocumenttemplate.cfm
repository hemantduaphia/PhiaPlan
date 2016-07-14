<cfparam name="rc.planDocumentTemplate" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityDetailForm object="#rc.planDocumentTemplate#" edit="#rc.edit#">
	<cf_HibachiEntityActionBar type="detail" object="#rc.planDocumentTemplate#" edit="#rc.edit#">
		<cf_HibachiProcessCaller entity="#rc.planDocumentTemplate#" action="admin:entity.preprocessplandocumenttemplate" processContext="duplicate" type="list" modal="true" />
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<div class="span6">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="client" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="checklist" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="planDocumentTemplateName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="planDocumentTemplateCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="checklistLimit" edit="#rc.edit#">
			</div>
			<div class="span6">
				<h5>Font, Layout &amp; Style Options</h5>
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="defaultFont" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="defaultFontSize" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="orientation" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="paragraphSpacing" edit="#rc.edit#">
			
				<h5>Document Margins</h5>
			
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="marginTop" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="marginBottom" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="marginRight" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="marginLeft" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentTemplate#" property="listMarginAlignment" edit="#rc.edit#">
			</div>
		
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.planDocumentTemplate#">
		<cf_HibachiTab property="planDocumentChecklistSections" />
		<cf_HibachiTab property="planDocumentTemplateDescription" />
		<cf_HibachiTab property="planDocumentHeaderText" />
		<cf_HibachiTab property="planDocumentFooterText" />
		<cf_AdminTabComments object="#rc.planDocumentTemplate#" />
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>