<cfparam name="rc.client" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.editEntityName" type="string" default="" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.client#" edit="#rc.edit#" enctype="multipart/form-data">
		<cf_HibachiEntityActionBar type="detail" object="#rc.client#" edit="#rc.edit#"></cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.client#" property="clientName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.client#" property="allowDownloadFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.client#" property="disableCommentFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.client#" property="logo" edit="#rc.edit#" fieldtype="file">
			</cf_HibachiPropertyList>
			
			<cfif !rc.client.isNew()>
				
				<div class="span4">
					<h4>Statistics</h4>
					
					<div class="row">
						<div class="span4 statsBlock" style="text-align:center;">
							<span style="font-weight:bold;">
								GROUPS
							</span>
							<h4>#arrayLen(rc.client.getClientGroups())#</h4>
						</div>
						<div class="span4 statsBlock" style="text-align:center">
							<span style="font-weight:bold;">
								CHECKLISTS
							</span>
							<h4>#rc.client.getTotalClientGroupChecklists()#</h4>
						</div>
						<div class="span4 statsBlock" style="text-align:center">
							<span style="font-weight:bold;">
								ACCOUNTS
							</span>
							<h4>#arrayLen(rc.client.getAccounts())#</h4>
						</div>
					</div>
					<div class="row">
						<div class="span4 statsBlock" style="text-align:center">
							<span style="font-weight:bold;">
								DOCUMENTS
							</span>
							<h4>#arrayLen(rc.client.getDocuments())#</h4>
						</div>
						<div class="span4 statsBlock" style="text-align:center">
							<span style="font-weight:bold;">
								COMMENTS
							</span>
							<h4>#rc.client.getTotalComments()#</h4>
						</div>
						<div class="span4 statsBlock" style="text-align:center">
							<span style="font-weight:bold;">
								Flagged Questions
							</span>
							<h4>#rc.client.getTotalFlaggedQuestions()#</h4>
						</div>
					</div>
				</div>
				
				
			</cfif>
		</cf_HibachiPropertyRow>
		
		
		<cf_HibachiTabGroup object="#rc.client#">
			<cf_HibachiTab property="accounts">
			<cf_HibachiTab property="clientGroups">
			<cf_AdminTabComments object="#rc.client#" />
			<cf_HibachiTab view="admin:entity/clienttabs/documents" />
			<cf_HibachiTab property="dashboardCopy">
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>