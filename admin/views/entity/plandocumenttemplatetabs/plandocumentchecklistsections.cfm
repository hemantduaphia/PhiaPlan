<cfparam name="rc.planDocumentTemplate" default="any" >
<cfscript>
	rc.planDocumentChecklistSectionsSmartList = rc.planDocumentTemplate.getPlanDocumentChecklistSectionsSmartList();
	rc.planDocumentChecklistSectionsSmartList.setPageRecordsShow(50);	
</cfscript>

<cfoutput>
	<cf_HibachiListingDisplay smartList="#rc.planDocumentChecklistSectionsSmartList#"
								recordEditAction="admin:entity.editPlanDocumentChecklistSection"
								recordEditQueryString="planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#"
								recordDetailAction="admin:entity.detailPlanDocumentChecklistSection"
								recordDetailQueryString="planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#"
							  	sortProperty="sortOrder"
								sortContextIDColumn="planDocumentTemplateID"
								sortContextIDValue="#rc.planDocumentTemplate.getPlanDocumentTemplateID()#">

		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="checklistSectionName" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" filter=true />
		<cf_HibachiListingColumn propertyIdentifier="clientApprovedFlag" filter=true />
		<cf_HibachiListingColumn propertyIdentifier="phiaApprovedFlag" filter=true />
	</cf_HibachiListingDisplay>
	<cf_HibachiActionCaller action="admin:entity.createplandocumentchecklistsection" class="btn btn-inverse" icon="plus icon-white" querystring="planDocumentTemplateID=#rc.planDocumentTemplate.getPlanDocumentTemplateID()#" modal="true" />
</cfoutput>