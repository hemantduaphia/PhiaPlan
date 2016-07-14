<cfparam name="rc.checklist" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityDetailForm object="#rc.checklist#" edit="#rc.edit#">
	<cf_HibachiEntityActionBar type="detail" object="#rc.checklist#" edit="#rc.edit#" showDelete="0">
		<cf_HibachiProcessCaller entity="#rc.checklist#" action="admin:entity.preprocesschecklist" processContext="duplicate" type="list" modal="true" />
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.checklist#" property="client" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.checklist#" property="checklistName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.checklist#" property="checklistCode" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.checklist#" property="activeFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.checklist#">
		<cf_HibachiTab property="checklistSections" />
		<cf_HibachiTab property="checklistDescription" />
		<cf_AdminTabComments object="#rc.checklist#" />
		<cf_HibachiTab view="admin:entity/checklisttabs/allcomments" />
		<cf_HibachiTab view="admin:entity/checklisttabs/allquestions" />
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>