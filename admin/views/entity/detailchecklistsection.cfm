<cfparam name="rc.checklistSection" type="any" />
<cfparam name="rc.checklist" type="any" default="#rc.checklistSection.getChecklist()#" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.checklistSection#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.checklistSection#" edit="#rc.edit#" 
							backAction="admin:entity.detailChecklist" 
							backQueryString="checklistID=#rc.checklist.getChecklistID()#"
							cancelAction="admin:entity.detailChecklist" 
							cancelQueryString="checklistID=#rc.checklist.getChecklistID()#"
							deleteQueryString="redirectAction=admin:entity.detailChecklist&checklistID=#rc.checklist.getChecklistID()#" />
		
		<cfif rc.edit>
			<input type="hidden" name="checklistID" value="#rc.checklist.getChecklistID()#" />
			<input type="hidden" name="checklist.checklistID" value="#rc.checklist.getChecklistID()#" />
		</cfif>
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.checklistSection#" property="checklistSectionName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.checklistSection#" property="checklistSectionCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.checklistSection#" property="activeFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.checklistSection#">
			<cf_HibachiTab property="questions" />
			<cf_HibachiTab property="checklistSectionDescription" />
			<cf_HibachiTab property="questionAnswerDependencies" />
			<cf_AdminTabComments object="#rc.checklistSection#" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
