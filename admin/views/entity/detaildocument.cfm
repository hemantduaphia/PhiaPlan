<cfparam name="rc.document" type="any">
<cfparam name="rc.edit" type="boolean">
<cfif not isNull(rc.document.getClient())>
	<cfset rc.client = rc.document.getClient() />
</cfif>
<cfif not isNull(rc.document.getClientGroup())>
	<cfset rc.clientGroup = rc.document.getClientGroup() />
</cfif>

<cfset backAction = rc.entityActionDetails.backAction />
<cfset backQueryString = "" />

<!--- find the correct back action & QS --->
<cfif not isNull(rc.client)>
	<cfset backAction = "admin:entity.detailclient" />
	<cfset backQueryString = "clientID=#rc.client.getClientID()#" />	
<cfelseif not isNull(rc.clientgroup)>
	<cfset backAction = "admin:entity.detailclientgroup" />
	<cfset backQueryString = "clientGroupID=#rc.clientgroup.getClientGroupID()#" />	
</cfif>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.document#" edit="#rc.edit#" saveActionQueryString="#backQueryString#" enctype="multipart/form-data">
		<cf_HibachiEntityActionBar type="detail" object="#rc.document#" edit="#rc.edit#" 
								   backAction="#backAction#" 
								   backQueryString="#backQueryString#"
								   deleteQueryString="redirectAction=#backAction#&#backQueryString#"  />

		<cf_HibachiPropertyRow>
			<cfif not isNull(rc.client)>
				<input type="hidden" name="client.clientID" value="#rc.client.getClientID()#" />
				<input type="hidden" name="clientID" value="#rc.client.getClientID()#" />
			<cfelseif not isNull(rc.clientgroup)>
				<input type="hidden" name="clientgroup.clientGroupID" value="#rc.clientGroup.getClientGroupID()#" />
				<input type="hidden" name="clientGroupID" value="#rc.clientGroup.getClientGroupID()#" />
			</cfif>
			
			<cf_HibachiPropertyList divclass="span8">
				<cf_HibachiPropertyDisplay object="#rc.document#" property="documentName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.document#" property="documentFile" edit="#rc.edit#" fieldtype="file">
				<!---<cf_HibachiPropertyDisplay object="#rc.document#" property="documentType" edit="#rc.edit#">--->
				<cf_HibachiPropertyDisplay object="#rc.document#" property="documentDescription" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
