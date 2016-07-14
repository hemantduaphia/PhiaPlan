<cfset rc.client = $.PhiaPlan.getAccount().getClient() />
<cfparam name="rc.clientGroupChecklist" type="any">
<cfparam name="rc.clientGroup" type="any">
<cfparam name="rc.edit" type="boolean">

<cf_HibachiMessageDisplay />

<cfoutput>
<cf_HibachiEntityDetailForm object="#rc.clientGroupChecklist#" sRenderItem="detailClientGroupChecklist" edit="#rc.edit#">
<input type="hidden" name="checklistStatus.typeID" value="5c18b649a18e1a173e685062171f152f" />
<!--- Hidden field to allow rc.client to be set on invalid submit --->
<input type="hidden" name="clientGroupID" value="#rc.clientGroup.getClientGroupID()#" />

<!--- Hidden field to attach this to the client --->
<input type="hidden" name="clientGroup.clientGroupID" value="#rc.clientGroup.getClientGroupID()#" />

<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4">
				<h3>New Checklist</h3>
			</div>
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					
					<div class="span12 pull-right">
						<div class="btn-group pull-right">
							<input type="submit" value="Save Checklist" id="frmSaveChecklist" class="btn btn-primary" />
						</div>
						
						<span style="display: none;" class="savingAlert pull-right">Saving...</span>
						
						<div class="btn-group pull-right">
							<a class="btn" href="/?PPAction=entity.detailclientgroup&clientgroupID=#rc.clientGroup.getClientGroupID()#"><i class="icon-chevron-left smallIcon"></i> Back</a>
						</div>
					</div>
				</div>
			</div>			
			
			<cf_HibachiPropertyRow>
				<cf_HibachiPropertyList>
					<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="checklist" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="planDocumentTemplate" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.clientGroupChecklist#" property="clientGroupChecklistName" edit="#rc.edit#">
				</cf_HibachiPropertyList>
			</cf_HibachiPropertyRow>
		</div>
	</div>
</div>			
</cf_HibachiEntityDetailForm>
</cfoutput>

<script>
	$('#frmSaveChecklist').click(function(e) {
		
		$('#frmSaveChecklist').parent().hide();

		$('.savingAlert').show();

	});
</script>