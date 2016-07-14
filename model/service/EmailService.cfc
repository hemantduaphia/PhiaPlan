<cfcomponent extends="PhiaPlan.org.Hibachi.HibachiService" accessors="true" output="false">
		
	<cffunction name="sendEmail" returntype="void" access="public">
		<cfargument name="emailTemplateCode" type="any" required="true" />
		<cfargument name="emailTo" type="any" required="false" default="" />
		<cfargument name="clientID" type="any" required="false" default="" />
		
		<cfif arguments.clientID NEQ "">
			<cfset var emailTemplateSmartList = this.getEmailTemplateSmartlist() />
			<cfset emailTemplateSmartList.addFilter("emailTemplateCode", arguments.emailTemplateCode) />
			<cfset emailTemplateSmartList.addFilter("clients.clientID", arguments.clientID) />
			<cfset emailTemplateSmartList.setPageRecordsShow(1) />
			<cfset var emailTemplates = emailTemplateSmartList.getPageRecords() />
			<cfif arrayLen(emailTemplates)>
				<cfset var emailTemplate = emailTemplates[1] />
			</cfif>
		</cfif>
		<cfif isNull(emailTemplate)>
			<cfset var emailTemplateSmartList = this.getEmailTemplateSmartlist() />
			<cfset emailTemplateSmartList.addFilter("emailTemplateCode", arguments.emailTemplateCode) />
			<cfset emailTemplateSmartList.addWhereCondition("size(aphiaplanemailtemplate.clients) = 0") />
			<cfset emailTemplateSmartList.setPageRecordsShow(1) />
			<cfset var emailTemplates = emailTemplateSmartList.getPageRecords() />
			<cfif arrayLen(emailTemplates)>
				<cfset var emailTemplate = emailTemplates[1] />
			</cfif>
		</cfif>
		
		<cfif isNull(emailTemplate)>
			<cfreturn />
		</cfif>
		<cfif arguments.emailTo EQ "">
			<cfset arguments.emailTo = emailTemplate.getEmailTo() />
		</cfif> 
		<!--- Send Multipart E-mail --->
		<cfif len(emailTemplate.getEmailBodyHTML()) && len(emailTemplate.getEmailBodyText())>
			<cfmail to="#arguments.emailTo#"
				from="#emailTemplate.getEmailFrom()#"
				subject="#emailTemplate.getEmailSubject()#"
				cc="#emailTemplate.getEmailCC()#"
				bcc="#emailTemplate.getEmailBCC()#"
				charset="utf-8">
				<cfmailpart type="text/plain">
					<cfoutput>#emailTemplate.getEmailBodyText()#</cfoutput>
				</cfmailpart>
				<cfmailpart type="text/html">
					<html>
						<body><cfoutput>#emailTemplate.getEmailBodyHTML()#</cfoutput></body>
					</html>
				</cfmailpart>
			</cfmail>
		<!--- Send HTML Only E-mail --->
		<cfelseif len(emailTemplate.getEmailBodyHTML())>
			<cfmail to="#arguments.emailTo#"
				from="#emailTemplate.getEmailFrom()#"
				subject="#emailTemplate.getEmailSubject()#"
				cc="#emailTemplate.getEmailCC()#"
				bcc="#emailTemplate.getEmailBCC()#"
				charset="utf-8"
				type="text/html">
				<html>
					<body><cfoutput>#emailTemplate.getEmailBodyHTML()#</cfoutput></body>
				</html>
			</cfmail>
		<!--- Send Text Only E-mail --->
		<cfelseif len(emailTemplate.getEmailBodyText())>
			<cfmail to="#arguments.emailTo#"
				from="#emailTemplate.getEmailFrom()#"
				subject="#emailTemplate.getEmailSubject()#"
				cc="#emailTemplate.getEmailCC()#"
				bcc="#emailTemplate.getEmailBCC()#"
				charset="utf-8"
				type="text/plain">
				<cfoutput>#emailTemplate.getEmailBodyText()#</cfoutput>
			</cfmail>
		</cfif>
		
	</cffunction>

</cfcomponent>

