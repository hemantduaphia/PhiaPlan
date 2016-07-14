<cfparam name="rc.plandocumenttemplate" />
<cfparam name="rc.plandocumentChecklistSection" default="#rc.plandocumenttemplate.getPlanDocumentChecklistSections()[1]#" />

<style>
	body { overflow: visible !important; }
</style>

<cfoutput>
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4 sectionName">
				<span>#rc.plandocumenttemplate.getPlanDocumentTemplateName()#</span>
			</div>
			<div class="span7 pull-right offset1">
				<div class="btn-group pull-right">
					<a class="btn-small" href="/?PPAction=entity.listchecklist"><i class="icon-chevron-left smallIcon"></i> Back</a>
				</div>
			</div>
		</div>		
		
		<div class="row" id="#rc.plandocumenttemplate.getPlanDocumentTemplateID()#" name="currentchecklist" data-checklistid="#rc.plandocumenttemplate.getChecklist().getChecklistID()#">
			<div class="span12">
				<h3><a href="##sectionsModal" class="sectionsListIcon" data-target="##sectionsModal" role="button" data-toggle="modal"><i class="icon-reorder"></i></a> #rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionName()#</h3>
			</div>
		</div>
	</div>	
</div>

<div class="row">
	<!---
	<div class="span3">
		<table class="table table-bordered table-striped table-small">
			<thead>
				<tr>
					<th></th>
					<th>Client</th>
					<th>Phia</th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.plandocumenttemplate.getPlanDocumentChecklistSectionsSmartList().getRecords()#" index="planDocumentSections">
					<tr>
						<td><a href="/?PPAction=entity.detailplandocumenttemplate&planDocumentTemplateID=#rc.plandocumenttemplate.getPlanDocumentTemplateID()#&planDocumentChecklistSectionID=#planDocumentSections.getPlanDocumentChecklistSectionID()#" <cfif planDocumentSections.getPlanDocumentChecklistSectionID() EQ rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()>class="active"</cfif>>#planDocumentSections.getChecklistSection().getChecklistSectionName()#</a></td>
						<td class="table-icons checkboxCell"><cfif !isNull(planDocumentSections.getClientApprovedFlag()) && planDocumentSections.getClientApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
						<td class="table-icons checkboxCell"><cfif !isNull(planDocumentSections.getPhiaApprovedFlag()) && planDocumentSections.getPhiaApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
					</tr>
					
				</cfloop>
			</tbody>
		</table>		
	</div>
	--->

	<div class="span12">
		<div class="row-fluid">
			<div class="span12">
				<div class="pricing-header-row-2 questionHeader">
					<div class="row-fluid">
						<div class="span6">
							<h5></h5>
						</div>
						
						<cfif !rc.plandocumentChecklistSection.getClientApprovedFlag()>
							<div class="span4 commentsBlock">
						<cfelse>
							<div class="span6 commentsBlock">
						</cfif>
						
							<cfif !$.phiaPlan.getDisableCommentFlag()>
								<cfset tmpCommentCount = arrayLen(rc.plandocumentChecklistSection.getComments())>
								<ul class="nav nav-pills narrow pull-right">
									<li><a href="javascript:$('##postCommentModal .modal-body').load('?previewonly=true&PPAction=entity.createcomment&planDocumentChecklistSectionID=#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()#',function(e){$('##postCommentModal').modal('show');});void(0);"><i class="icon-comment"></i> Post Comment</a></li>
									<li><a href="javascript:$('##viewCommentModal .modal-body').load('?previewonly=true&PPAction=entity.listcomment&planDocumentChecklistSectionID=#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()#',function(e){$('##viewCommentModal').modal('show');});void(0);"><i class="icon-comments"></i> View (<span id="cCount-#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()#">#tmpCommentCount#</span>)</a></li>
								</ul>
							</cfif>
						</div>
						<cfif !rc.plandocumentChecklistSection.getClientApprovedFlag()>
							<div class="span2 pull-right actionsBlock">
								<form action="?planDocumentTemplateID=#rc.plandocumenttemplate.getPlanDocumentTemplateID()#&planDocumentChecklistSectionID=#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()#" method="post">
									<input type="hidden" name="PPAction" value="entity.approve">
									<input type="hidden" name="entityName" value="PhiaPlanPlanDocumentChecklistSection">
									<input type="hidden" name="sRedirectAction" value="public:entity.detailplanDocumentTemplate">
									<input type="hidden" name="id" value="#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()#">
									<input type="submit" value="Approve" class="btn btn-small btn-success" />
								</form>
							</div>
						</cfif>
					</div>
				</div>
			
				<div class="questionDescription" id="plandocumentsectiontext">
					#rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionDescription()#
				</div>
			</div>		
		</div>
	</div>
</div>

<!--- TABLE OF CONTENTS --->
<div class="modal hide" id="sectionsModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		<h3 id="myModalLabel">Sections</h3>
	</div>	
	<div class="modal-body">
		<div class="row">
			<table class="table table-bordered table-striped table-small">
				<thead>
					<tr>
						<th></th>
						<th>Client</th>
						<th>Phia</th>
					</tr>
				</thead>
				<cfset sectionSmartlist = rc.plandocumenttemplate.getPlanDocumentChecklistSectionsSmartList() />
				<cfset sectionSmartlist.addOrder("sortOrder|asc") />
				<cfloop array="#sectionSmartlist.getRecords()#" index="planDocumentSections">
					<tr>
						<td><a href="/?PPAction=entity.detailplandocumenttemplate&planDocumentTemplateID=#rc.plandocumenttemplate.getPlanDocumentTemplateID()#&planDocumentChecklistSectionID=#planDocumentSections.getPlanDocumentChecklistSectionID()#" <cfif planDocumentSections.getPlanDocumentChecklistSectionID() EQ rc.plandocumentChecklistSection.getPlanDocumentChecklistSectionID()>class="active"</cfif>>#planDocumentSections.getChecklistSectionName()#</a></td>
						<td class="table-icons checkboxCell"><cfif !isNull(planDocumentSections.getClientApprovedFlag()) && planDocumentSections.getClientApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
						<td class="table-icons checkboxCell"><cfif !isNull(planDocumentSections.getPhiaApprovedFlag()) && planDocumentSections.getPhiaApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
					</tr>
				</cfloop>
			</table>
		</div>
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