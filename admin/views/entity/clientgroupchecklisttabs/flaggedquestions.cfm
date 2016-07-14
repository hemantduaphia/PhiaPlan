<cfparam name="rc.clientgroupchecklist" default="any" >
<cfset flaggedQuestionSmartList = $.phiaPlan.getService('planService').getViewClientGroupChecklistFlaggedQuestionSmartList() />
<cfset flaggedQuestionSmartList.addFilter("clientgroupchecklistID",rc.clientgroupchecklist.getClientGroupChecklistID()) />

<cf_HibachiListingDisplay smartList="#flaggedQuestionSmartList#">
	<cf_HibachiListingColumn propertyIdentifier="clientName" title="Client" search="false" filter="false" sort="false"  />
	<cf_HibachiListingColumn propertyIdentifier="clientGroupName" title="Group" search="false" filter="false" sort="false"  />
	<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" search="false" filter="false" sort="false"  />
	<cf_HibachiListingColumn propertyIdentifier="questionCode" title="Question Code" search="false" filter="false" sort="false"  />
	<cf_HibachiListingColumn propertyIdentifier="questionText" title="Question" tdclass="primary" search="false" filter="false" sort="false"  />
</cf_HibachiListingDisplay>