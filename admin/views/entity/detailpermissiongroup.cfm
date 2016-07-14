<cfparam name="rc.permissionGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.editEntityName" type="string" default="" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.permissionGroup#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.permissionGroup#" edit="#rc.edit#"></cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.permissionGroup#" property="permissionGroupName" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		
		<cf_HibachiTabGroup object="#rc.permissionGroup#">
			<cf_HibachiTab view="admin:entity/permissiongrouptabs/entitypermissions">
			<cf_HibachiTab view="admin:entity/permissiongrouptabs/actionpermissions">
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>