<cfparam name="rc.clientGroupChecklist" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.client" default="#rc.clientGroupChecklist.getClientGroup().getClient()#" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.clientGroupChecklist#" edit="#rc.edit#"
						sRedirectAction="admin:entity.detailClientGroup" 
						sRedirectQS="clientGroupID=#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.clientGroupChecklist#" edit="#rc.edit#" 
							backAction="admin:entity.detailClientGroup" 
							backQueryString="clientGroupID=#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#"
							cancelAction="admin:entity.detailClientGroup" 
							cancelQueryString="clientGroupID=#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#"
						    showdelete="true"
							deleteQueryString="redirectAction=admin:entity.detailClientGroup&clientGroupID=#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#">

				<cf_HibachiActionCaller action="entity.detailClientGroupChecklist&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#&showDoc=1" text="Show Plan Doc" type="list">
			
		</cf_HibachiEntityActionBar>
		
		<cfif rc.edit>
			<input type="hidden" name="clientGroupID" value="#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#" />
			<input type="hidden" name="clientGroupChecklist.clientGroupID" value="#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#" />
		</cfif>
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="clientGroupChecklistName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="checklist" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="planDocumentTemplate" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="checklistStatus" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="approvedFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.clientGroupChecklist#">
			<cfif structKeyExists(rc,"showDoc") AND rc.showDoc>
				<cf_HibachiTab view="public:entity/printclientGroupChecklist" />
			</cfif>
			<cf_HibachiTab view="admin:entity/clientgroupchecklisttabs/allcomments" />
			<cf_HibachiTab view="admin:entity/clientgroupchecklisttabs/flaggedquestions" />
			<cf_HibachiTab view="admin:entity/clientgroupchecklisttabs/disclaimeracceptance" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
