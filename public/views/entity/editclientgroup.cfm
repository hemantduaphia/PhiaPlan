<cfparam name="rc.clientGroup" type="any">
<cfparam name="rc.edit" type="boolean" default="true">
<cfif rc.clientGroup.isNew()>
	<cfset rc.client = $.PhiaPlan.getAccount().getClient() />
<cfelse>
	<cfset rc.client = rc.clientGroup.getClient() />
</cfif>

<cfoutput>
<cf_HibachiEntityDetailForm object="#rc.clientGroup#" sRenderItem="detailClientGroup" edit="#rc.edit#">
	
<!--- Hidden field to allow rc.client to be set on invalid submit --->
<input type="hidden" name="clientID" value="#rc.client.getClientID()#" />

<!--- Hidden field to attach this to the client --->
<input type="hidden" name="client.clientID" value="#rc.client.getClientID()#" />	
		
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>Client Group</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<div class="span12 pull-right">
						<div class="btn-group pull-right">
							<input type="submit" value="Save" class="btn btn-primary" />
						</div>
					</div>
				</div>
			</div>
			
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
					<cf_HibachiPropertyDisplay object="#rc.clientGroup#" property="clientGroupName" edit="#rc.edit#">
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
		</div>
	</div>
</div>
</cf_HibachiEntityDetailForm>
</cfoutput>