<cfif Not rc.planDocumentChecklistSection.isNew()>
	<cfset rc.planDocumentTemplate = rc.planDocumentChecklistSection.getPlanDocumentTemplate() /> 
</cfif>
<cfparam name="rc.planDocumentChecklistSection" type="any" />
<cfparam name="rc.planDocumentTemplate" type="any" default="#rc.planDocumentChecklistSection.getPlanDocumentTemplate()#">
<cfparam name="rc.edit" type="boolean" />

<cfset sectionSmartList = $.phiaplan.getService("planService").getChecklistSectionSmartList() />
<cfset sectionSmartList.addSelect(propertyIdentifier="checklistSectionName", alias="name") />
<cfset sectionSmartList.addSelect(propertyIdentifier="checklistSectionID", alias="value") />
<cfset sectionSmartList.addFilter(propertyIdentifier="checklist.checklistID", value="#rc.planDocumentTemplate.getChecklist().getChecklistID()#") />
<cfset sectionSmartList.addOrder("sortOrder|ASC") />
<cfset checklistSectionOptions = sectionSmartList.getRecords() />

<cfoutput>
<cf_HibachiEntityDetailForm object="#rc.planDocumentChecklistSection#" sRenderItem="detailPlanDocumentTemplate" edit="#rc.edit#">

	<cf_HibachiEntityActionBar type="detail" object="#rc.planDocumentChecklistSection#" edit="#rc.edit#"
							backAction="admin:entity.detailPlanDocumentTemplate" 
						    backQueryString="planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#" 
						    cancelAction="admin:entity.detailPlanDocumentTemplate"
							cancelQueryString="planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#"
							deleteQueryString="redirectAction=admin:entity.detailPlanDocumentTemplate&planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#" />

	
	<input type="hidden" name="planDocumentTemplateID" value="#rc.planDocumentTemplate.getPlanDocumentTemplateID()#" />
	<input type="hidden" name="planDocumentTemplate.planDocumentTemplateID" value="#rc.planDocumentTemplate.getPlanDocumentTemplateID()#" />
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="activeFlag" edit="#rc.edit#">
			<cfif rc.planDocumentChecklistSection.isNew()>
				<cf_HibachiFieldDisplay fieldname="checklistSectionID" title="Checklist Section" fieldType="select" value="" valueOptions="#checklistSectionOptions#" edit="#rc.edit#">
			<cfelse>
				<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="checklistSectionName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="checklistSectionCode" edit="#rc.edit#">
			</cfif>
			<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="clientApprovedFlag" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="phiaApprovedFlag" edit="#rc.edit#">
			<!---<cf_HibachiPropertyDisplay object="#rc.planDocumentChecklistSection#" property="planDocumentTemplate" edit="#rc.edit#">--->
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.planDocumentChecklistSection#">
		<cf_HibachiTab property="planDocumentChecklistSectionDescription" />
		<cf_AdminTabComments object="#rc.planDocumentChecklistSection#" />
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>
</cfoutput>
