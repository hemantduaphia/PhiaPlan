<cfparam name="rc.clientgroupchecklist" default="any" >
<cfset disclaimerAcceptanceSmartList = $.phiaplan.getService('planService').getclientgroupChecklistDisclaimerAcceptanceSmartList() />
<cfset disclaimerAcceptanceSmartList.addFilter("clientGroupChecklist.clientGroupChecklistID",rc.clientgroupchecklist.getClientGroupChecklistID()) />
<cfset disclaimerAcceptanceSmartList.applyData({"p:show"="20"}) />
<cfoutput>
	<cf_HibachiListingDisplay smartList="#disclaimerAcceptanceSmartList#">
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.fullname" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
	</cf_HibachiListingDisplay>
</cfoutput>

