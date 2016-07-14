<cfparam name="rc.type" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.Type#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.Type#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.Type#" property="systemCode" edit="false">
				<cf_HibachiPropertyDisplay object="#rc.Type#" property="type" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
