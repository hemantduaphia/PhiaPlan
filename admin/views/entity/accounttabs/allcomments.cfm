<cfparam name="rc.account" default="any" >
<cfset commentSmartList = $.phiaplan.getService('planService').getCommentSmartList() />
<cfset commentSmartList.addFilter("createdByAccount.accountID",rc.account.getAccountID()) />
<cfset commentSmartList.applyData({"p:show"="20"}) />

<cfoutput>
	<cf_HibachiListingDisplay smartList="#commentSmartList#"
							  recordDeleteAction="admin:entity.deletecomment"
							  recordDeleteQueryString="accountID=#rc.account.getAccountID()#&sRenderItem=detailAccount">
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment" />
		<!---<cf_HibachiListingColumn propertyIdentifier="PrimaryRelationshipSimpleRepresentation" />--->
		<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
		<cf_HibachiListingColumn propertyIdentifier="createdByAccount.fullname" />
	</cf_HibachiListingDisplay>
</cfoutput>

