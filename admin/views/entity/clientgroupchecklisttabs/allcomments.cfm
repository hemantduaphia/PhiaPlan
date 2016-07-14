<cfparam name="rc.clientgroupchecklist" default="any" >
<cfset commentSmartList = $.phiaplan.getService('planService').getCommentSmartList() />
<cfset commentSmartList.joinRelatedProperty("PhiaPlanComment","commentRelationships") />
<!---<cfset commentSmartList.addWhereCondition("aphiaplancommentrelationship.checklist.checklistID = '#rc.checklist.getChecklistID()#'",{},"OR") />
<cfset commentSmartList.addWhereCondition("aphiaplancommentrelationship.checklistSection.checklist.checklistID = '#rc.checklist.getChecklistID()#'",{},"OR") />--->
<cfset commentSmartList.addFilter("commentRelationships.question.checklistSection.checklist.checklistID",rc.clientgroupchecklist.getchecklist().getChecklistID()) />
<cfset commentSmartList.addFilter("commentRelationships.clientGroupChecklist.clientGroupChecklistID",rc.clientgroupchecklist.getClientGroupChecklistID()) />
<cfset commentSmartList.applyData({"p:show"="20"}) />
<!---http://phiaplan.ten24web.com/?PPAction=admin:entity.deletecomment&commentID=5124bffa476334190147690b42d3040e&clientID=5124bffa4255b6f501427125abdb04a0&sRenderItem=detailClient--->
<cfoutput>
	<cf_HibachiListingDisplay smartList="#commentSmartList#"
							  recordDeleteAction="admin:entity.deletecomment"
							  recordDeleteQueryString="clientGroupChecklistID=#rc.clientgroupchecklist.getClientGroupChecklistID()#&sRenderItem=detailClientGroupChecklist">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment" />
		<cf_HibachiListingColumn propertyIdentifier="PrimaryRelationshipSimpleRepresentation" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.fullname" />
	</cf_HibachiListingDisplay>
</cfoutput>

