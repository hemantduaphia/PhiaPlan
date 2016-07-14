<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfif !isNull(rc.account.getLoginLockExpiresDateTime()) AND DateCompare(Now(), rc.account.getLoginLockExpiresDateTime()) EQ -1 >
	<cfset rc.$.PhiaPlan.showMessageKey( 'admin.main.lockAccount.tooManyAttempts_error' ) />
</cfif>


<cf_HibachiEntityDetailForm object="#rc.account#" edit="#rc.edit#">
	<cf_HibachiEntityActionBar type="detail" object="#rc.account#" edit="#rc.edit#">
		<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="createPassword" type="list" modal="true" />
		<cf_HibachiProcessCaller entity="#rc.account#" action="admin:entity.preprocessaccount" processContext="changePassword" type="list" modal="true" />
		<li class="divider"></li>
		<cf_HibachiActionCaller action="admin:entity.createaccountemailaddress" queryString="accountID=#rc.account.getAccountID()#" type="list" modal=true />
	</cf_HibachiEntityActionBar>
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="span6">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<cfif !rc.account.isNew()><cf_HibachiPropertyDisplay object="#rc.account#" property="emailAddress" edit="false"></cfif>
			<cf_HibachiPropertyDisplay object="#rc.account#" property="superUserFlag" edit="#rc.edit and $.PhiaPlan.getAccount().getSuperUserFlag()#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="client" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="activeFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
	<cf_HibachiTabGroup object="#rc.account#">
		<cf_HibachiTab property="permissionGroups" />
		<cf_HibachiTab property="allowedClientGroupChecklists" />
		<cf_HibachiTab view="admin:entity/accounttabs/allcomments" />
		<cf_HibachiTab view="admin:entity/accounttabs/disclaimeracceptance" />
	</cf_HibachiTabGroup>
	
</cf_HibachiEntityDetailForm>