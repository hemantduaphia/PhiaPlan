<cfparam name="rc.clientgroupchecklist" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfset rc.pagetitle = "Duplicate Checklist: #rc.clientgroupchecklist.getClientgroupChecklistName()#" />

<cf_HibachiEntityProcessForm entity="#rc.clientgroupchecklist#" edit="#rc.edit#">
	
	<cf_HibachiEntityActionBar type="preprocess" object="#rc.clientgroupchecklist#">
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="clientgroupchecklistName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="checklistID" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="planDocumentTemplateID" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
</cf_HibachiEntityProcessForm>
