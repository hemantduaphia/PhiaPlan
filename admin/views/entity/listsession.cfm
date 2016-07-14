<cfparam name="rc.sessionSmartList" type="any" />
<cfset rc.sessionSmartList.addOrder('lastRequestDateTime|DESC') />

<cf_HibachiEntityActionBar type="listing" object="#rc.sessionSmartList#" showCreate="false" />


<cf_HibachiListingDisplay smartList="#rc.sessionSmartList#">
	<cf_HibachiListingColumn propertyIdentifier="lastRequestDateTime" />
	<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
	<cf_HibachiListingColumn propertyIdentifier="lastRequestIPAddress" />
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="userAgent" />
	<cf_HibachiListingColumn propertyIdentifier="account.firstName" />
	<cf_HibachiListingColumn propertyIdentifier="account.lastName" />
</cf_HibachiListingDisplay>

