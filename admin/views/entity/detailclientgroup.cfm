<cfif Not rc.clientGroup.isNew()>
	<cfset rc.client = rc.clientGroup.getClient() /> 
</cfif>
<cfparam name="rc.clientGroup" type="any">
<cfparam name="rc.client" type="any" default="#rc.clientGroup.getClient()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.clientGroup#" edit="#rc.edit#"
						 sRedirectAction="admin:entity.detailClient" 
						 sRedirectQS="clientID=#rc.client.getClientID()###tabclientgroups">
						 
		<cf_HibachiEntityActionBar type="detail" object="#rc.clientGroup#" edit="#rc.edit#" 
									backAction="admin:entity.detailClient" 
								    backQueryString="clientID=#rc.client.getClientID()#" 
								    cancelAction="admin:entity.detailClient"
									cancelQueryString="clientID=#rc.client.getClientID()#"
									deleteQueryString="redirectAction=admin:entity.detailClient&clientID=#rc.client.getClientID()#" />
		
		<!--- Hidden field to allow rc.client to be set on invalid submit --->
		<input type="hidden" name="clientID" value="#rc.client.getClientID()#" />
		
		<!--- Hidden field to attach this to the client --->
		<input type="hidden" name="client.clientID" value="#rc.client.getClientID()#" />

		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.clientGroup#" property="clientGroupName" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.clientGroup#">
			<cf_HibachiTab view="admin:entity/clientgrouptabs/clientGroupChecklists" />
			<cf_HibachiTab view="admin:entity/clientgrouptabs/documents" />
		</cf_HibachiTabGroup>
		
		
	</cf_HibachiEntityDetailForm>
</cfoutput>