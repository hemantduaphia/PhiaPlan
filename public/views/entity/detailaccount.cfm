<cfparam name="rc.account" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfoutput>
<cf_HibachiEntityDetailForm object="#rc.account#" edit="#rc.edit#" sRedirectAction="public:entity.accountoverview">
	<div class="row">
		<div class="span12">
			<div class="row">
				<div class="span4">
					<cfif len(rc.account.getAccountID())>
						<h3>Update Account</h3>
					<cfelse>
						<h3>Create Account</h3>
					</cfif>
				</div>
				<div class="span7 pull-right offset1 pageIconsBar">
					<div class="row-fluid">
						<div class="span12 pull-right">
							<a class="btn pull-right" href="/?PPAction=entity.accountoverview">Back to Accounts</a>
							<div class="btn-group pull-right">
								
								<input type="submit" value="Save" class="btn btn-primary">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	

	<cf_HibachiPropertyRow>
		<cf_HibachiPropertyList divclass="span6">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="firstName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="lastName" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="company" edit="#rc.edit#">
			<cf_HibachiPropertyDisplay object="#rc.account#" property="activeFlag" edit="#rc.edit#">
		</cf_HibachiPropertyList>
	</cf_HibachiPropertyRow>
	
</cf_HibachiEntityDetailForm>
	
</cfoutput>
