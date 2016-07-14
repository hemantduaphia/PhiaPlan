<cfsetting requesttimeout="240" /> 
<cfset allowEdit = false />
<cfif $.PhiaPlan.getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.editclientgroupchecklist',$.PhiaPlan.getAccount())>
	<cfset allowEdit = true />
</cfif>
<cfif !$.PhiaPlan.hasApplicationValue("currentEditors_checklists")>
	<cfset $.PhiaPlan.setApplicationValue("currentEditors_checklists","#structNew()#") />
</cfif>
<cfif !StructKeyExists($.PhiaPlan.getApplicationValue("currentEditors_checklists"),rc.clientGroupChecklist.getclientGroupChecklistID())>
	<cfset $.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"] = [] />
</cfif>
<cfif !arrayFind($.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"],$.PhiaPlan.getAccount().getFullName()) >
	<cfset arrayAppend($.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"],$.PhiaPlan.getAccount().getFullName()) />
</cfif>

<!--- Checklist is under edit by another user --->
<cfif arrayLen($.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"]) GT 1 OR (arrayLen($.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"]) AND $.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"][1] NEQ $.PhiaPlan.getAccount().getFullName())>
	<div class="alert alert-error" id="alertUnderEdit">
		<h4><i class="icon-info-sign"></i> Warning:</h4>
		<cfoutput><p>Currently being edited by #arrayToList($.PhiaPlan.getApplicationValue("currentEditors_checklists")["#rc.clientGroupChecklist.getclientGroupChecklistID()#"],", ")#</p></cfoutput>
	</div>
</cfif>

<cfparam name="rc.checklist" default="#rc.clientGroupChecklist.getCheckList()#" />

<cfset sectionSmartlist = rc.checklist.getChecklistSectionsSmartList() />
<cfset sectionSmartlist.addFilter("activeFlag",1) />
<cfset sectionSmartlist.addOrder("sortOrder|asc") />
<cfset checklistSections = sectionSmartlist.getRecords() />

<cfparam name="rc.checklistSection" default="#checklistSections[1]#" />
<cfparam name="rc.answer" default="#structNew()#" />
<cfparam name="url.questionID" default="" />

<!--- get all the responses --->
<cfset clientGroupChecklistAnswerSmartList = $.PhiaPlan.getService("planService").getClientGroupChecklistAnswerSmartList() />
<cfset clientGroupChecklistAnswerSmartList.addFilter("clientGroupChecklist_clientGroupChecklistID",rc.clientGroupChecklist.getClientGroupChecklistID()) />
<cfset clientGroupChecklistAnswerSmartList.joinRelatedProperty("PhiaPlanClientGroupChecklistAnswer","Question","inner",true) />

<!--- get all the excluded questions --->
<cfquery name="qryExcludedQuestions">
	SELECT QAEQ.questionAnswerID,QA.answerValue,QA.questionID,QAEQ.questionID excludedQuestionID 
	FROM QuestionAnswerExcludedQuestion QAEQ INNER JOIN QuestionAnswer QA ON QAEQ.questionAnswerID = QA.questionAnswerID
	INNER JOIN Question Q ON QAEQ.questionID = Q.questionID
	INNER JOIN ChecklistSection CS ON Q.ChecklistSectionID = CS.checklistSectionID
	INNER JOIN Checklist C ON CS.checklistID = C.checklistID
	WHERE C.checklistID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.clientGroupChecklist.getCheckList().getChecklistID()#">
</cfquery>

<!--- create a struct for answers --->
<cfset answerStruct = {} />
<cfloop array="#clientGroupChecklistAnswerSmartList.getRecords(true)#" index="clientGroupChecklistAnswer">
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()] = {} />
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()].clientGroupChecklistAnswerID = clientGroupChecklistAnswer.getClientGroupChecklistAnswerID() />
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()].answerValue = isNull(clientGroupChecklistAnswer.getAnswerValue())?"":clientGroupChecklistAnswer.getAnswerValue() />
</cfloop>

<!--- get answer dependency for questions --->
<cfset dependentQuestionStruct = {} />
<cfset excludedQuestionStruct = {} />
<cfset excludedQuestionAnswerStruct = {} />
<cfloop array="#rc.checklistSection.getQuestions()#" index="question">
	<cfif arrayLen(question.getQuestionAnswerDependencies())>
		<cfset dependentQuestionStruct[question.getQuestionID()] = {} />
		<cfset dependentQuestionStruct[question.getQuestionID()].questionAnswerID = [] />
		<cfset dependentQuestionStruct[question.getQuestionID()].dependentQuestionID = [] />
		<cfset dependentQuestionStruct[question.getQuestionID()].answerValue = [] />
		<cfloop array="#question.getQuestionAnswerDependencies()#" index="questionAnswer">
			<cfset arrayAppend(dependentQuestionStruct[question.getQuestionID()].questionAnswerID,questionAnswer.getQuestionAnswerID()) />
			<cfset arrayAppend(dependentQuestionStruct[question.getQuestionID()].answerValue,questionAnswer.getAnswerValue()) />
			<cfset arrayAppend(dependentQuestionStruct[question.getQuestionID()].dependentQuestionID,questionAnswer.getQuestion().getQuestionID()) />
		</cfloop>
	</cfif>
</cfloop> 

<!--- loop through exclusions --->
<cfloop query="qryExcludedQuestions">
	<cfparam name="excludedQuestionStruct.#qryExcludedQuestions.questionAnswerID#" default="#structNew()#" />
	<cfparam name="excludedQuestionStruct.#qryExcludedQuestions.questionAnswerID#.questionIDs" default="" />
	<cfset excludedQuestionStruct[qryExcludedQuestions.questionAnswerID].questionIDs = listAppend(excludedQuestionStruct[qryExcludedQuestions.questionAnswerID].questionIDs,qryExcludedQuestions.excludedQuestionID) />

	<cfparam name="excludedQuestionAnswerStruct.#qryExcludedQuestions.excludedQuestionID#" default="#structNew()#" />
	<cfset excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID].answerID = qryExcludedQuestions.questionAnswerID />
	<cfset excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID].answerValue = qryExcludedQuestions.answerValue />
	<cfif StructKeyExists(answerStruct,qryExcludedQuestions.questionID)>
		<cfif !structKeyExists(excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID], "answerSelectedFlag") OR excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID].answerSelectedFlag EQ "false">
			<cfset excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID].answerSelectedFlag = answerStruct[qryExcludedQuestions.questionID].answerValue EQ qryExcludedQuestions.answerValue?true:false />
		</cfif>
	<cfelse>
		<cfset excludedQuestionAnswerStruct[qryExcludedQuestions.excludedQuestionID].answerSelectedFlag = false />
	</cfif>
</cfloop> 

<!--- get answer dependency for sections --->
<cfset dependentSectionStruct = {} />
<cfloop array="#rc.checklist.getCheckListSections()#" index="checkListSection">
	<cfif arrayLen(checkListSection.getQuestionAnswerDependencies())>
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionID()] = {} />
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionID()].answerValue = [] />
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionID()].dependentQuestionID = [] />
		<cfloop array="#checkListSection.getQuestionAnswerDependencies()#" index="questionAnswer">
			<cfset arrayAppend(dependentSectionStruct[checkListSection.getCheckListSectionID()].answerValue,questionAnswer.getAnswerValue()) />
			<cfset arrayAppend(dependentSectionStruct[checkListSection.getCheckListSectionID()].dependentQuestionID,questionAnswer.getQuestion().getQuestionID()) />
		</cfloop>
	</cfif>
</cfloop> 

<cfoutput>
<cfparam name="form.vPosition" default="0" />
<cfparam name="scroll" default="false" />	

<cfif scroll>
	<script>
		$(document).ready(function() {
	    	
	    	var p = $( "###url.questionID#" );
	    	var question = p.position();
			var questionPosition = question.top - 100;	
		
	    	/* $('body').scrollTop( questionPosition ); */
	    	$(window).scrollTop(questionPosition)
	    	
			$("###url.questionID# .questionHeader").delay(2000).animate({
				backgroundColor: "##f3f3f3"
			}, 7000 );  
  
		});
	</script>
</cfif>

<form action="" method="post" id="updateForm">
<input type="hidden" name="PPAction" value="entity.saveClientGroupChecklistAnswers" />
<input type="hidden" name="hasSuccessAction" value="1" />
<input type="hidden" name="vPosition" id="vPosition" value="0" />
<div class="row">
	<div class="span12">
		<div class="row">
			<div class="span4 sectionName">
				<span class="smaller">#rc.checklist.getChecklistName()#</span>
			</div>
			<div class="span7 pull-right offset1">
				<div class="btn-group pull-right">
					<a class="btn-small" href="/"><i class="icon-home smallIcon"></i> Home </a>  || 
					<cf_phiaActionCaller action="public:entity.detailclientgroup" queryString="clientGroupID=#rc.clientGroupChecklist.getClientGroup().getClientGroupID()#" icon="chevron-left" class="smallIcon btn-small" text=" Back" />
				</div>
			</div>
		</div>
		
		<div class="row">
			<div class="span12 checklistName">
				<span>#rc.clientGroupChecklist.getClientGroupChecklistName()#</span>
			</div>
		</div>
		<cfset checklistStatus = rc.clientGroupChecklist.getChecklistStatus().getType() />
		<cfif checklistStatus EQ "closed">
			<div class="alert">
				<b>#rc.clientGroupChecklist.getClientGroupChecklistName()#</b> has been marked as closed. 
			</div>
		</cfif>
		
		<div class="row subnav navbar">
			<div class="span7">
				<h3><a href="##sectionsModal" class="sectionsListIcon" data-target="##sectionsModal" role="button" data-toggle="modal"><i class="icon-reorder"></i></a> #rc.checklistSection.getChecklistSectionName()#</h3>
			</div>			
			<div class="span5 pull-right offset1 pageIconsBar">
				<div class="row-fluid">
					<cfif rc.clientGroupChecklist.getChecklistStatus().getSystemCode() NEQ "cgcsClosed" AND allowEdit>
						
						<cfparam name="form.hasSuccessAction" default="" />
						<cfif form.hasSuccessAction EQ "1">
							<div class="alert alert-error span8" id="savedAlert">
								<b>#rc.clientGroupChecklist.getClientGroupChecklistName()#</b> saved. 
							</div>
						<cfelseif checklistStatus EQ "closed">
							<div class="alert">
								<b>#rc.clientGroupChecklist.getClientGroupChecklistName()#</b> has been marked as closed. 
							</div>
						</cfif>
						
						<div class="alert alert-warning" id="displayFormWarning">
							<i class="icon-bolt"></i> Checklist changes made
						</div>

						<div class="span2 pull-right">
							<div class="btn-group pull-right">
								<a class="btn btn-primary" id="saveChecklist">Save Checklist</a>
							</div>
							<span style="display: none;" class="savingAlert pull-right">Saving...</span>
						</div>
					</cfif>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="btn-group pull-right" style="margin-top: 5px;">
				<a class="btn-small launchSearchModal"><i class="icon-search"></i> Search</a>
				<a class="btn-small" href="/?PPAction=entity.listclientgroupchecklistanswer&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#"><i class="icon-print smallIcon"></i>View All Answers</a>
				<cfif checklistStatus NEQ "closed" AND allowEdit>
					<a class="btn-small" href="##confirmationModal" data-target="##confirmationModal" role="button" data-toggle="modal"><i class="icon-save smallIcon"></i>Complete Checklist</a>
				</cfif>
				<cfif !rc.clientGroupChecklist.getChecklistLimitReachedFlag()><cf_phiaActionCaller action="public:entity.preprocessclientgroupchecklist" queryString="processcontext=duplicate&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#" icon="copy smallIcon" class="btn-small" text="Duplicate" /></cfif>
				<cf_phiaActionCaller action="public:entity.printclientgroupchecklist" queryString="clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#" icon="print smallIcon" class="btn-small" text="View Document" />
				<a class="btn-small removeAllFlag" <cfif listlen(rc.clientGroupChecklist.getFlaggedQuestionIDs()) GTE "1">style="display: inline-block;"</cfif>><i class="icon-flag smallIcon"></i>Remove Flags</a>
			</div>
		</div>
	</div>	
</div>

<div class="row">
	<div class="span12">
		<cfset questionSmartList = rc.checklistSection.getQuestionsSmartList() />
		<cfset questionSmartList.addFilter("activeFlag",1) />
		<cfset questionSmartList.addOrder("sortOrder|asc") />
		
		<cfloop array="#questionSmartList.getRecords()#" index="question" >
			<!--- DISPLAY ANSWERS! --->
			<cfif structKeyExists(answerStruct,question.getQuestionID())>
				<cfset rc.answer[question.getQuestionID()] = {} />
				<cfset rc.answer[question.getQuestionID()].answerValue = answerStruct[question.getQuestionID()].answerValue />
				<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = answerStruct[question.getQuestionID()].clientGroupChecklistAnswerID />
			<cfelse>
				<cfset rc.answer[question.getQuestionID()] = {} />
				<cfset rc.answer[question.getQuestionID()].answerValue = "" />
				<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = "" />
			</cfif>
			<!--- for check boxes default the answer value to '' --->
			<cfparam name="rc.answer[question.getQuestionID()].answerValue" default="" />
			<cfset showDependentQuestion = false />
			<cfif structKeyExists(dependentQuestionStruct,question.getQuestionID())>
				<cfset dependentQuestionID = dependentQuestionStruct[question.getQuestionID()]["dependentquestionID"][1] />
				<cfset dependentAnswerValue = dependentQuestionStruct[question.getQuestionID()]["answerValue"][1] />
				<cfif structKeyExists(answerStruct,dependentQuestionID) AND listFindNoCase(answerStruct[dependentQuestionID]["answerValue"],dependentAnswerValue)>
					<cfset showDependentQuestion = true />	
				</cfif>
			</cfif>
			<!--- hide based on exclusion on load --->
			<cfset showExcludedQuestion = true />
			<cfif structKeyExists(excludedQuestionAnswerStruct,question.getQuestionID()) AND excludedQuestionAnswerStruct[question.getQuestionID()].answerSelectedFlag>
				<cfset showExcludedQuestion = false />
			</cfif>
			<cfset classList = "questionDisplay row-fluid" />
			<cfif Not showExcludedQuestion>
				<cfset classList &= " excludeQuestion" />
			</cfif>
			
			<cfset questionFlagged = "false" />
			<cfif listFind(rc.clientGroupChecklist.getFlaggedQuestionIDs(),question.getQuestionID())>
				<cfset questionFlagged = "true" />
			</cfif>
			
			<div id="#question.getQuestionID()#" <cfif structKeyExists(dependentQuestionStruct,question.getQuestionID())><cfif Not showDependentQuestion>style="display:none;"</cfif> class="#classList# #arrayToList(dependentQuestionStruct[question.getQuestionID()].dependentQuestionID,' ')# #arrayToList(dependentQuestionStruct[question.getQuestionID()].questionAnswerID,' ')#"<cfelse> class="#classList#"</cfif> data-hiddenbyquestionid="">
				<div class="span12">
					<div class="pricing-header-row-2 questionHeader <cfif url.questionID EQ question.getQuestionID()>scrollTo</cfif> <cfif questionFlagged>flaggedHeader</cfif>">
						<div class="row-fluid">
							<div class="span4">
								<h5>
									<cfif question.getAnswerType().getType() EQ "none">#question.getQuestionText()#<cfelse>#question.getQuestionNumberLabel()#</cfif>
									<cfif len(question.getQuestionHint())>
										<a class="questionHintIcon" data-toggle="popover" title="" data-content="#question.getQuestionHint()#" data-original-title=""><i class="icon-question-sign"></i></a>
									</cfif>
									
									<cfif $.PhiaPlan.getAccount().getSuperUserFlag()>
										<span class="questionCodeDisplay">
											#question.getQuestionCode()#
										</span>
									</cfif>
								</h5>
							</div>
							<cfif question.getAnswerType().getType() NEQ "none">
								<div class="span8 commentsBlock">
									<ul class="nav nav-pills narrow pull-right">
										<cfset commentCount = arrayLen(question.getComments(filterData = {"cr.clientGroupChecklist.clientGroupChecklistID" = "#rc.clientGroupChecklist.getClientGroupChecklistID()#","c.publicFlag"=1}))>
										<cfif checklistStatus NEQ "closed" AND !$.phiaPlan.getDisableCommentFlag() AND $.phiaPlan.getAllowCreateCommentFlag()>
											<li><a href="javascript:$('##postCommentModal .modal-body').load('?previewonly=true&PPAction=entity.createcomment&questionID=#question.getQuestionID()#&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#',function(e){$('##postCommentModal').modal('show');});void(0);"><i class="icon-comment"></i> Post Comment</a></li>
										</cfif>
										<li><a href="javascript:$('##viewCommentModal .modal-body').load('?previewonly=true&PPAction=entity.listcomment&questionID=#question.getQuestionID()#&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#',function(e){$('##viewCommentModal').modal('show');});void(0);" class="openCommentModal"><i class="icon-comments"></i> View (<span id="cCount-#question.getQuestionID()#">#commentCount#</span>)</a></li>
										<!---<li><a href=""><i class="icon-time"></i> Version History</a></li>--->
										
										<li><a <cfif questionFlagged>class="unflagComment"<cfelse>class="flagComment"</cfif> data-questionID="#question.getQuestionID()#"><i class="icon-flag"></i> <cfif questionFlagged>Unflag<cfelse>Flag</cfif></a></li>
									</ul>
								</div>
							</cfif>
						</div>
					</div>
					<cfif question.getAnswerType().getType() NEQ "none">
						<div class="pricing-content-row-even">
							<p class="questionBlockText">#question.getQuestionText()#</p>
							<cfif len(question.getPlanLanguage())>
								<div class="questionPlanLanguage">#question.getPlanLanguage()#</div>
							</cfif>
							
							<!--- <cf_fieldDisplay fieldName="answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getDefaultAnswerValue()#" value="#answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" /> --->
							<input type="hidden" name="answer.#question.getQuestionID()#.clientGroupChecklistAnswerID" value="#rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID#" />
							<input type="hidden" name="answer.#question.getQuestionID()#.question.questionID" value="#question.getQuestionID()#" />
							<cf_fieldDisplay fieldName="answer.#question.getQuestionID()#.answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getQuestionHint()#" value="#rc.answer[question.getQuestionID()].answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" excludedQuestionStruct="#excludedQuestionStruct#" />
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
		<cfif currentSectionID EQ checklistSectionArray[i].getChecklistSectionID() OR nextSectionID NEQ "">
			<cfif i LT arrayLen(checklistSectionArray)>
				<cfset nextSectionID = checklistSectionArray[i+1].getChecklistSectionID() />
			<cfelse>
				<cfset nextSectionID = "" />
				<cfbreak />
			</cfif>
		</cfif>
		<cfif nextSectionID NEQ "">
			<cfif !structKeyExists(dependentSectionStruct,nextSectionID) OR (structKeyExists(answerStruct,dependentSectionStruct[nextSectionID].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[nextSectionID].dependentQuestionID[1]].answerValue,dependentSectionStruct[nextSectionID].answerValue[1]))>
				<cfbreak />
			</cfif>
		</cfif>
	</cfloop>
	<cfloop from="#arrayLen(checklistSectionArray)#" to="1" index="i" step="-1">
		<cfif currentSectionID EQ checklistSectionArray[i].getChecklistSectionID() OR previousSectionID NEQ "">
			<cfif i GT 1>
				<cfset previousSectionID = checklistSectionArray[i-1].getChecklistSectionID() />
			<cfelse>
				<cfset previousSectionID = "" />
				<cfbreak />
			</cfif>
		</cfif>
		<cfif previousSectionID NEQ "">
			<cfif !structKeyExists(dependentSectionStruct,previousSectionID) OR (structKeyExists(answerStruct,dependentSectionStruct[previousSectionID].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[previousSectionID].dependentQuestionID[1]].answerValue,dependentSectionStruct[previousSectionID].answerValue[1]))>
				<cfbreak />
			</cfif>
		</cfif>
	</cfloop>
	<div class="pull-right footerBtns" id="bottom">
		<p class="pull-right">
			<span style="display: none;" class="savingAlert pull-right">Saving...</span>
			<cfif previousSectionID NEQ "">
				<a class="btn" href="/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=#rc.clientGroupChecklistID#&checklistSectionID=#previousSectionID#"><i class="icon-chevron-left smallIcon"></i> Previous Section</a>
			</cfif>
			<cfif nextSectionID NEQ "">
				<a class="btn" href="/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=#rc.clientGroupChecklistID#&checklistSectionID=#nextSectionID#"><i class="icon-chevron-right smallIcon"></i> Next Section</a>
			</cfif>
			
			<span class="alert alert-warning" id="displayFormWarningBtm">
				<i class="icon-bolt"></i> Checklist changes made
			</span>
			
			<cfif rc.clientGroupChecklist.getChecklistStatus().getSystemCode() NEQ "cgcsClosed" AND allowEdit >
				<input type="submit" class="btn btn-primary" id="bottomFormBtn" value="Save Checklist" />
			</cfif>
		</p>
	</div>
	</form>
</div>

<!--- COMPLETE COMFIRMATION --->
<div class="modal hide" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		<h3 id="myModalLabel">Confirmation</h3>
	</div>	
	<div class="modal-body">
		Before submitting the checklist, please ensure there are no unanswered questions. Any questions left unanswered may result in the production of an incomplete, inaccurate, and/or non-compliant document. Additionally, please ensure that you are saving the checklist prior to completing and downloading the finished version of your document. Are you sure you want to submit this checklist and no longer edit it?
	</div>
	<div class="modal-footer">
		<a href="##" data-dismiss="modal" class="btn">Close</a>
		<a href="/?PPAction=entity.markChecklistComplete&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#" class="btn btn-primary">Yes, Complete Checklist</a>
	</div>
</div>

<!--- FLAG REMOVAL COMFIRMATION --->
<div class="modal hide" id="flagRemoveModal" tabindex="-1" role="dialog" aria-labelledby="flagRemoveModal" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		<h3 id="myModalLabel">Confirmation</h3>
	</div>	
	<div class="modal-body">
		Are you sure you want to remove all flags?
	</div>
	<div class="modal-footer">
		<a href="##" data-dismiss="modal" class="btn">Close</a>
		<a class="btn btn-primary removeAllFlagConfirm">Yes, Remove Flags</a>
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
				<cfloop array="#checklistSections#" index="checklistSection">
					<cfif !structKeyExists(dependentSectionStruct,checklistSection.getChecklistSectionID()) OR (structKeyExists(answerStruct,dependentSectionStruct[checklistSection.getChecklistSectionID()].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[checklistSection.getChecklistSectionID()].dependentQuestionID[1]].answerValue,dependentSectionStruct[checklistSection.getChecklistSectionID()].answerValue[1]))>
						<tr>
							<td><a href="/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#&checklistsectionID=#checklistSection.getCheckListSectionID()#" <cfif checklistSection.getCheckListSectionID() EQ rc.checklistsection.getchecklistsectionID()>class="active"</cfif>>#checklistSection.getChecklistSectionName()#</a></td>
						</tr>
					</cfif>
				</cfloop>
			</table>
		</div>
	</div>
</div>	

<!--- SEARCH MODAL --->
<div id="searchModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="searchModalLabel" aria-hidden="true">
	<div class="modal-header">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
		<h3>Search Checklist</h3>
	</div>
	<div class="modal-body"></div>
</div>

<!--- COMMENTS EDIT --->
<cfinclude template = "../inc/inc_modal_commentedit.cfm">

<!--- COMMENTS VIEW --->
<cfinclude template = "../inc/inc_modal_comments.cfm">

<!--- POST COMMENT --->
<cfinclude template = "../inc/inc_modal_commentpost.cfm">

<script type="text/javascript" src="/assets/js/jquery.are-you-sure.js"></script>
</cfoutput>

<script>
	<cfoutput>
	<cfif form.vPosition NEQ "0">
		var y = $(window).scrollTop();  
		$("html, body").animate({ scrollTop: y + #form.vPosition# }, 600);
	</cfif>
	</cfoutput>
	
	$(document).ready(function() {
		$("#savedAlert").delay(3000).fadeOut("slow");
	});
	
	<!--- ALL FLAGS MODAL --->
	$(".removeAllFlag").click(function() {
		$('#flagRemoveModal').modal('show');
	});
	
	<!--- REMOVE ALL FLAGS --->
	$(document.body).on('click', '.removeAllFlagConfirm', function(){
		
		<cfoutput>
		var url = '/?PPAction=public:entity.flagClientGroupChecklistQuestion&clientgroupchecklistID=#url.clientGroupChecklistID#&context=remove&ajaxrequest=1';
		</cfoutput>

		$.ajax({
			url: url,
			type: "POST",
			beforeSend: function(xhr) {
				xhr.setRequestHeader('X-Hibachi-AJAX', true);
				}
			})
			.done(function( data ) {
				$('.unflagComment').html('<i class="icon-flag"></i> Flag');
				$(".flaggedHeader").removeClass("flaggedHeader");
				$(".unflagComment").toggleClass("unflagComment flagComment");
				$('.removeAllFlag').css('display','none');
				$('#flagRemoveModal').modal('hide');
			}
		);
	});
	
	<!--- ADD FLAG --->
	$(document.body).on('click', '.flagComment', function(){
		var getQuestionID = $(this).attr("data-questionID");

		<cfoutput>
		var url = '/?PPAction=public:entity.flagClientGroupChecklistQuestion&clientgroupchecklistID=#url.clientGroupChecklistID#&context=add&ajaxrequest=1&questionID=' + getQuestionID;
		</cfoutput>

		$.ajax({
			url: url,
			type: "POST",
			beforeSend: function(xhr) {
				xhr.setRequestHeader('X-Hibachi-AJAX', true);
				}
			})
			.done(function( data ) {
				$('#' + getQuestionID + ' .flagComment').html('<i class="icon-flag"></i> Un-Flag');
				$('#' + getQuestionID + ' .flagComment').closest('.questionHeader').addClass('flaggedHeader');
				$('#' + getQuestionID + ' .flagComment').toggleClass('flagComment unflagComment');
				$('.removeAllFlag').css('display','inline-block');
			}
		);	
		
	});
	
	<!--- REMOVE FLAG --->
	$(document.body).on('click', '.unflagComment', function(){
		var getQuestionID = $(this).attr("data-questionID");

		<cfoutput>
		var url = '/?PPAction=public:entity.flagClientGroupChecklistQuestion&clientgroupchecklistID=#url.clientGroupChecklistID#&context=remove&ajaxrequest=1&questionID=' + getQuestionID;
		</cfoutput>

		$.ajax({
			url: url,
			type: "POST",
			beforeSend: function(xhr) {
				xhr.setRequestHeader('X-Hibachi-AJAX', true);
				}
			})
			.done(function( data ) {
				$('#' + getQuestionID + ' .unflagComment').html('<i class="icon-flag"></i> Flag');
				$('#' + getQuestionID + ' .unflagComment').closest('.questionHeader').toggleClass('flaggedHeader');
				$('#' + getQuestionID + ' .unflagComment').addClass('flagComment').removeClass('unflagComment');
			}
		);	
		
	});
	
	$('#updateForm').areYouSure( {'silent':true} );
	$('#updateForm').on('dirty.areYouSure', function() {
		$('#displayFormWarning, #displayFormWarningBtm').show('slide', {direction: 'down'}, 1000);
	});	
	$('#updateForm').on('clean.areYouSure', function() {
		$('#displayFormWarning, #displayFormWarningBtm').hide('slide', {direction: 'down'}, 1000);
	});
	
	$('#saveChecklist, #bottomFormBtn').click(function(e) {
		
		$('#saveChecklist').parent().hide();
		$('#bottomFormBtn').hide();
		
		$('.savingAlert').show();
		
		// SET OFFSET FROM TOP
		var offset = $(this).offset();
		$('#vPosition').val(offset.top - 40)
		
		// SUBMIT FORM
		$('#updateForm').submit();
	});
	
	$(document).scroll(function(){
	    var elem = $('.subnav');
	    if (!elem.attr('data-top')) {
	        if (elem.hasClass('navbar-fixed-top'))
	            return;
	         var offset = elem.offset()
	        elem.attr('data-top', offset.top);
	    }
	    if (elem.attr('data-top') - elem.outerHeight() <= $(this).scrollTop() - $(elem).outerHeight())
	        elem.addClass('navbar-fixed-top');
	    else
	        elem.removeClass('navbar-fixed-top');
	});	
	
	$('#bottomFormBtn').click(function(e) {
		e.preventDefault();
		$('#updateForm').attr('action', '#bottom');
		$('#updateForm').submit();
	});
	
	$('#viewCommentModal').on('shown', function () {
	    $('body').css('overflow', 'hidden');
	}).on('hidden', function(){
	    $('body').css('overflow', 'auto');
	});
	
	$('.unapprovequestion').click(function() {
		var unapproveForm = $(this).data("question")
		$('#unapprove_' + unapproveForm).submit();
	});

	<cfoutput>
	$('.launchSearchModal').click(function() {
		$('##searchModal').modal({
			remote: '/?previewonly=true&PPAction=entity.searchchecklist&checklistID=#rc.clientGroupChecklist.getCheckList().getChecklistID()#&clientGroupChecklistID=#rc.clientGroupChecklist.getClientGroupChecklistID()#',
			backdrop: 'static'
		});
	});
	</cfoutput>

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
	
	<cfif checklistStatus EQ "closed" OR !allowEdit>
		$('body').find('select').attr('disabled','disabled');
		$('body').find('textarea').attr("readonly","readonly");
		$('body').find('input').attr("readonly","readonly");
		$('body').find('input:checkbox, input:radio').attr("disabled","disabled");
	</cfif>
</script>
