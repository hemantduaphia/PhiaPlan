<cfset rc.trackedAnswerSmartList = $.phiaplan.getService('PlanService').getClientGroupChecklistAnswerSmartList() />
<cfset rc.trackedAnswerSmartList.addFilter("question.trackAnswerFlag", 1) />
<cfset rc.trackedAnswerSmartList.applyData({"p:show"="10"}) />

<cfoutput>
	
	<cf_HibachiEntityActionBar type="listing" object="#rc.trackedAnswerSmartList#" showCreate="false" showKeywordSearch="false" />
	
	<cf_HibachiListingDisplay smartList="#rc.trackedAnswerSmartList#" showKeywordSearch="false">
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.clientgroup.client.clientName" search="true" title="Phia Client" />
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.clientgroup.clientGroupName" search="true" title="Group" />
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.checklist.checklistName" search="true" filter="false" title="Checklist Name" />
		<cf_HibachiListingColumn propertyIdentifier="question.questionText" tdclass="primary" search="true" filter="false" actionCallerAttributes="#{action='admin:entity.detailquestion',queryString='questionID=${question.questionID}'}#" />
		<cf_HibachiListingColumn propertyIdentifier="question.questionCode" search="true" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="answerValue" search="true" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.firstname" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.lastname" filter="false" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" search="false" range="false" />
	</cf_HibachiListingDisplay>
</cfoutput>

