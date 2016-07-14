<cfparam name="rc.checklistSection" default="any" >
<cfset rc.checklistSection.getQuestionsSmartList().applyData({"p:show"="100"}) />

<cfoutput>
	<cf_HibachiListingDisplay smartList="#rc.checklistSection.getQuestionsSmartList()#"
								recordEditAction="admin:entity.editQuestion"
								recordEditQueryString="checklistSectionID=#rc.checklistSection.getChecklistSectionID()#"
								recordDetailAction="admin:entity.detailQuestion"
								recordDetailQueryString="checklistSectionID=#rc.checklistSection.getChecklistSectionID()#"
								sortProperty="sortOrder"
								sortContextIDColumn="checklistSectionID"
								sortContextIDValue="#rc.checklistSection.getChecklistSectionID()#">

		<cf_HibachiListingColumn propertyIdentifier="questionCode" sort="false" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="questionText" sort="false" />
		<cf_HibachiListingColumn propertyIdentifier="clientApprovedFlag" filter=true sort="false" />
		<cf_HibachiListingColumn propertyIdentifier="phiaApprovedFlag" filter=true sort="false" />
		<cf_HibachiListingColumn propertyIdentifier="activeFlag" filter=true sort="false" />
	</cf_HibachiListingDisplay>
	<cf_HibachiActionCaller action="admin:entity.createquestion" class="btn btn-inverse" icon="plus icon-white" querystring="checklistSectionID=#rc.checklistSection.getChecklistSectionID()#" />
</cfoutput>