<cfparam name="rc.account" default="any" >
<cfset disclaimerAcceptanceSmartList = $.phiaplan.getService('planService').getclientgroupChecklistDisclaimerAcceptanceSmartList() />
<cfset disclaimerAcceptanceSmartList.addFilter("createdByAccount.accountID",rc.account.getAccountID()) />
<cfset disclaimerAcceptanceSmartList.applyData({"p:show"="20"}) />
<cfoutput>
	<cf_HibachiListingDisplay smartList="#disclaimerAcceptanceSmartList#">
		<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.clientGroupChecklistName" />
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
	</cf_HibachiListingDisplay>
</cfoutput>

