<cfparam name="rc.checklist" default="any" >

<cfset questionSmartList = $.phiaplan.getService('planService').getQuestionSmartList() />
<cfset questionSmartList.addFilter("checklistSection.checklist.checklistID",rc.checklist.getChecklistID()) />
<cfset questionSmartList.applyData({"p:show"="20"}) />

<cfoutput>
	<cf_HibachiListingDisplay smartList="#questionSmartList#">
		<cf_HibachiListingColumn propertyIdentifier="checklistSection.checklistSectionName" />
		<cf_HibachiListingColumn propertyIdentifier="questionCode" sort="false" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="questionText" sort="false" />		
	</cf_HibachiListingDisplay>
</cfoutput>

