<cfset backaction = "entity.listclientgroup" />
<cfset createaction = "entity.createdocument" />
<cfset documentSmartList = $.PhiaPlan.getService("planService").getdocumentSmartList() />
<cfif structKeyExists(rc,"clientGroupID")>
	<cfset documentSmartList.addFilter("clientGroup.clientGroupID",rc.clientGroupID) />
	<cfif !$.PhiaPlan.getAccount().getSuperUserFlag()>
		<cfset documentSmartList.addFilter("clientGroup.client.accounts.accountID",$.PhiaPlan.getAccount().getAccountID()) />
	</cfif>
	<cfset backaction = "entity.detailclientgroup&clientGroupID=#rc.clientGroupID#" />
	<cfset createaction = "entity.createdocument&clientGroupID=#rc.clientGroupID#" />
<cfelseif !$.PhiaPlan.getAccount().getSuperUserFlag()>
	<cfset documentSmartList.addWhereCondition("client.clientID = :clientID",{"clientID"=$.PhiaPlan.getAccount().getClient().getClientID()}) />
	<!---<cfset documentSmartList.addWhereCondition("clientGroup.client.clientID = :clientID",{"clientID"=$.PhiaPlan.getAccount().getClient().getClientID()},"OR") />--->
</cfif>
<cfset documentSmartList.addOrder("documentName") />
<cfset documentSmartList.applyData({"p:show"="30"}) />

<cfoutput>
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>Attachments</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<div class="span12 pull-right">
						<div class="btn-group pull-right">
							<a href="/?PPAction=#createaction#" class="btn btn-primary" />New Attachment</a>
						</div>
						
						<a class="btn-small pull-right" href="?PPAction=#backaction#"><i class="icon-chevron-left smallIcon"></i> Back to Client Groups</a>
					</div>
				</div>
			</div>	
		</div>
	</div>
</div>

<cf_HibachiListingDisplay smartList="#documentSmartList#">
	<cf_HibachiListingColumn propertyIdentifier="documentName" title="Document Name" valueLink="x" valueLinkIdentifier="documentPath" tdclass="primary" />
	<cf_HibachiListingColumn propertyIdentifier="CreatedDateTime" title="Created" />

</cf_HibachiListingDisplay>
</cfoutput>
