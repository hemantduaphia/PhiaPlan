<cfparam name="rc.accountEmailAddress" type="any">
<cfparam name="rc.account" type="any" default="#rc.accountEmailAddress.getAccount()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.accountEmailAddress#" edit="#rc.edit#" sRenderItem="detailaccount">
		<cf_HibachiEntityActionBar type="detail" object="#rc.accountEmailAddress#" edit="#rc.edit#"></cf_HibachiEntityActionBar>
		
		<!--- Hidden field to allow rc.account to be set on invalid submit --->
		<input type="hidden" name="accountID" value="#rc.account.getAccountID()#" />
		
		<!--- Hidden field to attach this to the account --->
		<input type="hidden" name="account.accountID" value="#rc.account.getAccountID()#" />
		
		<cf_HibachiPropertyDisplay object="#rc.accountEmailAddress#" property="emailAddress" edit="#rc.edit#">
	</cf_HibachiEntityDetailForm>
</cfoutput>















