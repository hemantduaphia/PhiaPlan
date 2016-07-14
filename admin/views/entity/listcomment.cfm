<cfparam name="rc.commentSmartList" default="any" >
<cfset rc.commentSmartList = $.phiaplan.getService('planService').getCommentRelationshipSmartList() />
<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","comment") />
<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","clientGroupChecklist") />
<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanClientGroupChecklist","checklist") />
<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanChecklist","client") />
<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","question") />
<cfset rc.commentSmartList.addOrder("comment.createdDateTime|DESC") />
<cfset rc.commentSmartList.applyData({"p:show"="15"}) />
<cfoutput>
	<cf_HibachiListingDisplay smartList="#rc.commentSmartList#">
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.checklist.client.clientName" filter="false" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment.comment" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.clientGroupChecklistName" filter="false" actionCallerAttributes="#{action='admin:entity.detailClientGroupChecklist',queryString='clientGroupChecklistID=${clientGroupChecklist.clientGroupChecklistID}'}#" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment.primaryRelationshipSimpleRepresentation" />
		<cf_HibachiListingColumn propertyIdentifier="question.questionCode" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="comment.createdDateTime" />
		<cf_HibachiListingColumn propertyIdentifier="comment.createdByAccount.firstname" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="comment.createdByAccount.lastname" filter="false" />
	</cf_HibachiListingDisplay>
</cfoutput>

