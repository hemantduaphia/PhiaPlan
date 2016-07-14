<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getInternalAccountAuthenticationsByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		
		<cfreturn ormExecuteQuery("SELECT aa FROM #getApplicationValue('applicationKey')#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aa.password is not null AND (a.activeFlag is null OR a.activeFlag = 1) AND aea.emailAddress=:emailAddress", {emailAddress=arguments.emailAddress}) />
	</cffunction>
	
	<cffunction name="getActivePasswordByEmailAddress" returntype="any" access="public">
		<cfargument name="emailAddress" required="true" type="string" />
		
		<cfreturn ormExecuteQuery("SELECT aa FROM #getApplicationValue('applicationKey')#AccountAuthentication aa INNER JOIN FETCH aa.account a INNER JOIN a.accountEmailAddresses aea WHERE aa.password is not null AND (a.activeFlag is null OR a.activeFlag = 1) AND lower(aea.emailAddress)=:emailAddress AND aa.activeFlag = 1", {emailAddress=lcase(arguments.emailAddress)}, true) />
	</cffunction>
	
	<cffunction name="getAccountAuthenticationExists" returntype="any" access="public">
		<cfset var aaCount = ormExecuteQuery("SELECT count(aa.accountAuthenticationID) FROM #getApplicationValue('applicationKey')#AccountAuthentication aa") />
		<cfreturn aaCount[1] gt 0 />
	</cffunction>
	
	<cffunction name="getPasswordResetAccountAuthentication">
		<cfargument name="accountID" type="string" required="true" />
		
		<cfset var aaArray = ormExecuteQuery("SELECT aa FROM #getApplicationValue('applicationKey')#AccountAuthentication aa WHERE aa.account.accountID = :accountID and aa.expirationDateTime >= :now and aa.password is null", {accountID=arguments.accountID, now=now()}) />
		
		<cfif arrayLen(aaArray)>
			<cfreturn aaArray[1] />
		</cfif>
	</cffunction>
	
	<cffunction name="removeAccountFromAllSessions" returntype="void" access="public">
		<cfargument name="accountID" required="true"  />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE Session SET accountID = null, accountAuthenticationID = null WHERE accountID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountID#" />
		</cfquery>
	</cffunction>
	
	<cffunction name="removeAccountAuthenticationFromAllSessions" returntype="void" access="public">
		<cfargument name="accountAuthenticationID" required="true"  />
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE Session SET accountAuthenticationID = null WHERE accountAuthenticationID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.accountAuthenticationID#" />
		</cfquery>
	</cffunction>
	
	<cffunction name="subscribeSend24" >
		<cfargument name="account" required="true" /> 
		<cftry>
			<cfhttp url="http://phia.send24web.com/index.cfm/api/subscriber/#account.getEmailAddress()#?apiKey=DDD6535-FF2D-51A8-CC3693C3738F33CF7" method="put" timeout="10">
				<cfhttpparam type="header" name="content-type" value="text/json" >
				<cfhttpparam type="body" value='{"firstName":"#account.getFirstName()#","lastName":"#account.getLastName()#","mailingListIDs":"1"}' >
			</cfhttp>
			<cfcatch type="any">
			</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>
