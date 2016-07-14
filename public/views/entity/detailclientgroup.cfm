<cfparam name="rc.clientgroup" />

<cfoutput>
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span6">
				<div class="row-fluid">
					<div class="span12">
                        <h3>#rc.clientGroup.getClientGroupName()#</h3>
                    </div>				
				</div>
			</div>
			<div class="span6 pull-right pageIconsBar">
				<div class="row-fluid">
					<div class="span12 pull-right">
						
						<div class="btn-group pull-right">
							<a class="btn" href="?PPAction=entity.createclientgroupchecklist&clientgroupID=#rc.clientGroup.getClientGroupID()#"><i class="icon-plus-sign"></i> New Checklist</a>
						</div>
						<div class="row-fluid groupicons">
							<ul class="nav nav-pills narrow pull-right">
								<cfset filterData = {"c.publicFlag"=1} />
								<cfset commentCount = trim(arrayLen(rc.clientGroup.getClient().getComments(filterData=filterData)))>
								
								<li><a href="/?PPAction=entity.listdocument&clientgroupID=#rc.clientGroup.getClientGroupID()#"><i class="icon-folder-open"></i> Attachments</a></li>
								<li><a href="/?PPAction=entity.createdocument&clientgroupID=#rc.clientGroup.getClientGroupID()#"><i class="icon-file"></i> New</a></li>
								<cfif !$.phiaPlan.getDisableCommentFlag()>
									<li> || </li>
									<li><a href="javascript:$('##viewCommentModal .modal-body').load('?previewonly=true&PPAction=entity.listcomment&clientID=#rc.clientGroup.getClient().getClientID()#',function(e){$('##viewCommentModal').modal('show');});void(0);"><i class="icon-comments"></i> Comments (<span id="cCount-#rc.clientGroup.getClient().getClientID()#">#commentCount#</span>)</a></li>
									<cfif $.phiaPlan.getAllowCreateCommentFlag()>
										<li><a href="javascript:$('##postCommentModal .modal-body').load('?previewonly=true&PPAction=entity.createcomment&clientID=#rc.clientGroup.getClient().getClientID()#',function(e){$('##postCommentModal').modal('show');});void(0);"><i class="icon-comment-alt"></i> Post</a></li>
									</cfif>
								</cfif>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="span12">
		<h5>Checklists</h5>
	</div>

	<div class="span12">
		<cf_HibachiListingDisplay smartList="#rc.clientGroup.getClientGroupChecklistsSmartList()#"
								   recordEditAction="entity.detailclientgroupchecklist"
								   recordDetailAction="entity.printclientgroupchecklist">
			<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" tdclass="primary wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="checklist.checklistName" title="Master Checklist" search="false" filter="false" tdclass="primary wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="planDocumentTemplate.planDocumentTemplateName" title="Master Template" search="false" filter="false" tdclass="primary wrapText" />
			<cf_HibachiListingColumn propertyIdentifier="checklistStatus.type" title="Status" search="false" />
			<cf_HibachiListingColumn propertyIdentifier="createdDateTime" search="false" range="false" />
			<cf_HibachiListingColumn propertyIdentifier="modifiedDateTime" search="false" range="false" />
		</cf_HibachiListingDisplay>
	</div>
</div>


<!--- COMMENTS EDIT --->
<cfinclude template = "../inc/inc_modal_commentedit.cfm">

<!--- COMMENTS VIEW --->
<cfinclude template = "../inc/inc_modal_comments.cfm">

<!--- POST COMMENT --->
<cfinclude template = "../inc/inc_modal_commentpost.cfm">
</cfoutput>

<script>
	$('.unapprovequestion').click(function() {
		var unapproveForm = $(this).data("question")
		$('#unapprove_' + unapproveForm).submit();
	});

	$(".editCommentBtn").click(function() {
		$('#viewCommentModal').modal('hide');
	});
	
	$('#viewCommentModal').on('hidden', function () {
		$('#viewCommentModal').modal('hide');
		$('body').removeClass('modal-open');
		$('.modal-backdrop').remove();
	});

	$('#postCommentModal').on('hidden', function () {
		$('body').removeClass('modal-open');
		$('.modal-backdrop').remove();
	});	
</script>