<cfparam name="rc.account" type="any" />
<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cf_HibachiEntityProcessForm entity="#rc.account#" edit="#rc.edit#" sRedirectAction="public:entity.accountoverview">
	
	<cf_HibachiEntityActionBar type="preprocess" object="#rc.account#" />
	
	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList>
			<input type="hidden" name="createAuthenticationFlag" value="1" />
			<input type="hidden" name="client.clientID" value="#rc.client.getClientID()#" />
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="firstName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="lastName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="company" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddress" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="emailAddressConfirm" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="password" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.processObject#" property="passwordConfirm" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
</cf_HibachiEntityProcessForm>
