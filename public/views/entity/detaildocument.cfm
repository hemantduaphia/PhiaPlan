<cfparam name="rc.document" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.document#" edit="#rc.edit#" sRedirectAction="" sRenderItem="listdocument" enctype="multipart/form-data">
	<div class="row">
		<div class="span12">
			<div class="row">
				<div class="span4">
					<h3>Document</h3>
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
					<cfif not isNull(rc.clientgroupID)>
						<input type="hidden" name="clientgroup.clientGroupID" value="#rc.clientgroupID#" />
						<input type="hidden" name="clientGroupID" value="#rc.clientgroupID#" />
					<cfelse>
						<input type="hidden" name="client.clientID" value="#$.PhiaPlan.getAccount().getClient().getClientID()#" />
						<input type="hidden" name="clientID" value="#$.PhiaPlan.getAccount().getClient().getClientID()#" />
					</cfif>
		
					<cf_HibachiPropertyList divclass="span8">
						<cf_HibachiPropertyDisplay object="#rc.document#" property="documentName" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.document#" property="documentFile" edit="#rc.edit#" fieldtype="file">
						<!---<cf_HibachiPropertyDisplay object="#rc.document#" property="documentType" edit="#rc.edit#">
						<cf_HibachiPropertyDisplay object="#rc.document#" property="documentDescription" edit="#rc.edit#">--->
					</cf_HibachiPropertyList>
				</cf_HibachiPropertyRow>
			
			</div>
		</div>
	</div>
	</cf_HibachiEntityDetailForm>
</cfoutput>
