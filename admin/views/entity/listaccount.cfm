<cfparam name="rc.accountSmartList" type="any" />

<cfoutput>
	<cf_HibachiEntityActionBar type="listing" object="#rc.accountSmartList#" showCreate="false">
		
		<!--- Create --->
		<cf_HibachiEntityActionBarButtonGroup>
			<cf_HibachiProcessCaller action="admin:entity.preprocessaccount" entity="account" processContext="create" class="btn btn-primary" icon="plus icon-white" text="Create Account" modal="true" />
		</cf_HibachiEntityActionBarButtonGroup>
		
	</cf_HibachiEntityActionBar>
	
	
	<cf_HibachiListingDisplay smartList="#rc.accountSmartList#"
							   recordEditAction="admin:entity.editaccount"
							   recordDetailAction="admin:entity.detailaccount">
		<cf_HibachiListingColumn propertyIdentifier="firstName" search="true" />
		<cf_HibachiListingColumn propertyIdentifier="lastName" search="true" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="company" />
		<cf_HibachiListingColumn propertyIdentifier="primaryEmailAddress.emailAddress" search="true" />
	</cf_HibachiListingDisplay>
</cfoutput>