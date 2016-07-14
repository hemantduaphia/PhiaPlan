<cfparam name="rc.checklist" />
<cfparam name="rc.checklistSection" default="#rc.checklist.getCheckListSections()[1]#" />

<cfoutput>
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4 sectionName">
				<span>#rc.checklist.getChecklistName()#</span>
			</div>
			<div class="span7 pull-right offset1">
				<div class="btn-group pull-right">
					<a class="btn-small" href="/?PPAction=entity.listchecklist"><i class="icon-chevron-left smallIcon"></i> Back</a>
				</div>
			</div>
		</div>
		
		<div class="row">
			<div class="span5">
				<h3><a href="##sectionsModal" class="sectionsListIcon" data-target="##sectionsModal" role="button" data-toggle="modal"><i class="icon-reorder"></i></a> #rc.checklistSection.getChecklistSectionName()#</h3>
			</div>			
			<div class="span7 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<div class="span12 pull-right"></div>
				</div>
			</div>
		</div>
	</div>		
</div>

<div class="row">
	<div class="span12">
		<!--- create a struct for answers --->
		<cfset answerStruct = {} />
		<cfset answerCount = "0" />
		<cfset questionSmartList = rc.checklistSection.getQuestionsSmartList() />
		<cfset questionSmartList.addFilter("activeFlag",1) />
		<cfset questionSmartList.addOrder("sortOrder|asc") />
		<cfloop array="#questionSmartList.getRecords()#" index="question" >
			<cfset answerCount ++ />
			<div class="row-fluid" id="#question.getQuestionID()#">
				<!--- DISPLAY ANSWERS! --->
				<cfif structKeyExists(answerStruct,question.getQuestionID())>
					<cfset answerValue = answerStruct[question.getQuestionID()].answerValue />
				<cfelse>
					<cfset answerValue = "" />
					<!--- <cfset answerValue = isNull(question.getDefaultAnswerValue())?"":question.getDefaultAnswerValue() /> --->
				</cfif>
									
				<div class="span12">
					<div class="pricing-header-row-2 questionHeader">
						<div class="row-fluid">
							<div class="span4">
								<h5>
									<cfif question.getAnswerType().getType() EQ "none">#question.getQuestionText()#<cfelse>#question.getQuestionNumberLabel()#</cfif>
									<cfif len(question.getQuestionHint())>
										<a class="questionHintIcon" data-toggle="popover" title="" data-content="#question.getQuestionHint()#" data-original-title=""><i class="icon-question-sign"></i></a>
									</cfif>
								</h5>
							</div>
							<cfif question.getAnswerType().getType() NEQ "none">
								<cfset tmpCommentCount = trim(arrayLen(question.getComments()))>
								
								<cfif !$.phiaPlan.getDisableCommentFlag()>
									<div class="span6 commentsBlock">
										<ul class="nav nav-pills narrow pull-right">
											<li><a href="javascript:$('##postCommentModal .modal-body').load('?previewonly=true&PPAction=entity.createcomment&questionID=#question.getQuestionID()#',function(e){$('##postCommentModal').modal('show');});void(0);"><i class="icon-comment"></i> Post Comment</a></li>
											<li><a href="javascript:$('##viewCommentModal .modal-body').load('?previewonly=true&PPAction=entity.listcomment&questionID=#question.getQuestionID()#',function(e){$('##viewCommentModal').modal('show');});void(0);"><i class="icon-comments"></i> View (<span id="cCount-#question.getQuestionID()#">#tmpCommentCount#</span>)</a></li>
											<!--- <li><a href=""><i class="icon-time"></i> Version History</a></li> --->
										</ul>
									</div>
								</cfif>
								<cfif question.getClientApprovedFlag() EQ "no">
									<div class="span2 pull-right actionsBlock">
										<form action="?checklistID=#rc.checklist.getChecklistID()#&checklistSectionID=#rc.checklistSection.getChecklistSectionID()####question.getQuestionID()#" method="post">
											<input type="hidden" name="PPAction" value="entity.approve">
											<input type="hidden" name="entityName" value="PhiaPlanQuestion">
											<input type="hidden" name="sRedirectAction" value="public:entity.detailchecklist">
											<input type="hidden" name="id" value="#question.getQuestionID()#">
											<input type="submit" value="Approve" class="btn btn-small btn-success" />
										</form>
										<!---<a class="btn btn-small btn-success" href="##"> <i class="icon-save"></i> Approve</a>--->
									</div>
								<cfelse>
									<div class="span2 pull-right actionsBlock">
										<span class="approved"><i class="icon-check-sign"></i>Approved</span>
										<form id="unapprove_#question.getQuestionID()#" action="?checklistID=#rc.checklist.getChecklistID()#&checklistSectionID=#rc.checklistSection.getChecklistSectionID()####question.getQuestionID()#" method="post">
											<input type="hidden" name="questionID" value="#question.getQuestionID()#" />
											<input type="hidden" name="PPAction" value="entity.savequestion">
											<input type="hidden" name="entityName" value="PhiaPlanQuestion">
											<input type="hidden" name="sRedirectAction" value="public:entity.detailchecklist">
											<input type="hidden" name="id" value="#question.getQuestionID()#">
											<input type="hidden" name="clientApprovedFlag" value="0" />
										</form>
										
										<a class="unapprovequestion" data-question="#question.getQuestionID()#"><i class="icon-remove"></i>unapprove</a>
									</div>
								</cfif>
							</cfif>
						</div>
					</div>
					
					<cfif question.getAnswerType().getType() NEQ "none">
						<div class="pricing-content-row-even <cfif arraylen(rc.checklistSection.getQuestions()) EQ answerCount>lastAnswer</cfif>">
							<p class="questionBlockText">#question.getQuestionText()#</p>
							
							<cfif len(question.getPlanLanguage())>
								<div class="questionPlanLanguage">#question.getPlanLanguage()#</div>
							</cfif>
							
							<!--- <cf_fieldDisplay fieldName="answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getDefaultAnswerValue()#" value="#answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" /> --->
							<cf_fieldDisplay questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" fieldName="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getQuestionHint()#"  valueOptions="#question.getQuestionAnswersOptions()#" />
	
							<br clear="all">
						</div>
					</cfif>
				</div>							
			</div>
		</cfloop>
	</div>
	
	<cfset sectionSmartlist = rc.checklist.getChecklistSectionsSmartList() />
	<cfset sectionSmartlist.addFilter("activeFlag",1) />
	<cfset sectionSmartlist.addOrder("sortOrder|asc") />
	
	<cfset currentSectionID = rc.checklistSection.getChecklistSectionID() />
	<cfset nextSectionID = "" />
	<cfset previousSectionID = "" />
	<cfset checklistSectionArray = sectionSmartlist.getRecords() />
	<cfloop from="1" to="#arrayLen(checklistSectionArray)#" index="i">
		<cfif currentSectionID EQ checklistSectionArray[i].getChecklistSectionID()>
			<cfif i LT arrayLen(checklistSectionArray)>
				<cfset nextSectionID = checklistSectionArray[i+1].getChecklistSectionID() />
			</cfif>
			<cfif i GT 1>
				<cfset previousSectionID = checklistSectionArray[i-1].getChecklistSectionID() />
			</cfif>
			<cfbreak />
		</cfif>
	</cfloop>
	<div class="pull-right footerBtns">
		<p>
			<cfif previousSectionID NEQ "">
				<a class="btn" href="/?PPAction=entity.detailchecklist&checklistID=#rc.checklistID#&checklistSectionID=#previousSectionID#"><i class="icon-chevron-left smallIcon"></i> Previous Section</a>
			</cfif>
			<cfif nextSectionID NEQ "">
				<a class="btn" href="/?PPAction=entity.detailchecklist&checklistID=#rc.checklistID#&checklistSectionID=#nextSectionID#"><i class="icon-chevron-right smallIcon"></i> Next Section</a>
			</cfif>
		</p>
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
				<tbody>
					<cfloop array="#sectionSmartlist.getRecords()#" index="checklistSection">
						<tr>
							<td><a href="/?PPAction=entity.detailchecklist&checklistID=#rc.checklist.getCheckListID()#&checklistsectionID=#checklistSection.getCheckListSectionID()#" <cfif checklistSection.getCheckListSectionID() EQ rc.checklistsection.getchecklistsectionID()>class="active"</cfif>>#checklistSection.getChecklistSectionName()#</a></td>
							<td class="table-icons checkboxCell"><cfif checklistSection.getAllQuestionClientApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
							<td class="table-icons checkboxCell"><cfif checklistSection.getAllQuestionPhiaApprovedFlag()><i class="icon-check-sign"></i></cfif></td>
						</tr>
					</cfloop>
				</tbody>
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