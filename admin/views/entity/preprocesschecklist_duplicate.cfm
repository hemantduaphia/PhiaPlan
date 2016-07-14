<cfparam name="rc.checklist" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityProcessForm entity="#rc.checklist#" edit="#rc.edit#">
	
	<cf_HibachiEntityActionBar type="preprocess" object="#rc.checklist#">
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="checklistName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="checklistCode" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
</cf_HibachiEntityProcessForm>
