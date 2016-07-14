<cfparam name="rc.checklist" default="any" >
<cfset commentSmartList = $.phiaplan.getService('planService').getCommentSmartList() />
<cfset commentSmartList.joinRelatedProperty("PhiaPlanComment","commentRelationships") />
<cfset commentSmartList.addFilter("commentRelationships.question.checklistSection.checklist.checklistID",rc.checklist.getChecklistID()) />
<cfset commentSmartList.addWhereCondition("aphiaplancommentrelationship.clientGroupChecklist.clientGroupChecklistID IS NULL",{}) />
<cfset commentSmartList.applyData({"p:show"="20"}) />
<cfoutput>
	<cf_HibachiListingDisplay smartList="#commentSmartList#">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment" />
		<cf_HibachiListingColumn propertyIdentifier="PrimaryRelationshipSimpleRepresentation" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.fullname" />
	</cf_HibachiListingDisplay>
</cfoutput>

