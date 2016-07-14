<cfparam name="rc.checklist" default="any" >
<cfset rc.checklistSectionsSmartList = rc.checklist.getChecklistSectionsSmartList() />
<cfset rc.checklistSectionsSmartList.setPageRecordsShow(50) />
<cfset rc.checklistSectionsSmartList.addFilter("activeFlag",1) />

<cfoutput>
	<cf_HibachiListingDisplay smartList="#rc.checklistSectionsSmartList#"
								recordEditAction="admin:entity.editChecklistSection"
								recordEditQueryString="checklistID=#rc.checklist.getChecklistID()#"
								recordDetailAction="admin:entity.detailChecklistsection"
								recordDetailQueryString="checklistID=#rc.checklist.getChecklistID()#"
							  	sortProperty="sortOrder"
								sortContextIDColumn="checklistID"
								sortContextIDValue="#rc.checklist.getChecklistID()#">

		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="checklistSectionName" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" filter=true />
	</cf_HibachiListingDisplay>
	<cf_HibachiActionCaller action="admin:entity.createchecklistSection" class="btn btn-inverse" icon="plus icon-white" querystring="checklistID=#rc.checklist.getChecklistID()#" />
</cfoutput>