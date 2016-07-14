<cfparam name="rc.clientGroupChecklistID" />
<cfset rc.clientGroupChecklist = $.PhiaPlan.getService("planService").getClientGroupChecklist(rc.clientGroupChecklistID) />
<cfparam name="rc.checklist" default="#rc.clientGroupChecklist.getCheckList()#" />

<cfset clientGroupChecklistAnswerStruct = {} />
<cfset clientGroupChecklistAnswerSmartList = $.PhiaPlan.getService("planService").getClientGroupChecklistAnswerSmartList() />
<cfset clientGroupChecklistAnswerSmartList.addFilter("clientGroupChecklist.clientGroupChecklistID",rc.clientGroupChecklist.getClientGroupChecklistID()) />
<cfloop array="#clientGroupChecklistAnswerSmartList.getRecords()#" index="clientGroupChecklistAnswer">
	<cfset clientGroupChecklistAnswer[#clientGroupChecklistAnswer.getQuestion().getQuestionID()#] = clientGroupChecklistAnswer.getAnswerValue() />
</cfloop>
<!--- get all the responses --->
<cfquery name="getclientGroupChecklistAnswers">
	SELECT q.questionID,q.questionCode,cgca.answerValue,isNull(qa.answerLabel,Stuff((select ',' + qa1.answerlabel from SplitList(cgca.answerValue,',') INNER JOIN QuestionAnswer qa1 ON qa1.answerValue = item AND qa1.questionID = cgca.questionID FOR XML PATH('')),1,1,'')) AS answerLabel
	FROM clientGroupChecklistAnswer cgca INNER JOIN clientGroupChecklist cgc ON cgca.clientGroupChecklistID = cgc.clientGroupChecklistID
	INNER JOIN Question q ON cgca.questionID = q.questionID
	LEFT JOIN QuestionAnswer qa ON q.questionID  = qa.questionID AND cgca.answerValue = qa.answerValue
	WHERE cgca.clientGroupChecklistID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.clientGroupChecklist.getClientGroupChecklistID()#">
</cfquery>	
<!--- create a struct for answers --->
<cfset answerStruct = {} />
<cfloop query="getclientGroupChecklistAnswers">
	<cfset answerStruct[getclientGroupChecklistAnswers.questionID] = {} />
	<cfset answerStruct[getclientGroupChecklistAnswers.questionID].answerValue = getclientGroupChecklistAnswers.answerValue />
	<cfset answerStruct[getclientGroupChecklistAnswers.questionID].answerLabel = getclientGroupChecklistAnswers.answerLabel />
</cfloop>

<cfset checklistSectionSmartList = $.PhiaPlan.getService("planService").getChecklistSectionSmartList() />
<cfset checklistSectionSmartList.addFilter("checklist.checklistID",rc.clientGroupChecklist.getChecklist().getChecklistID()) />
<cfset checklistSectionSmartList.addFilter("activeFlag",1) />
<cfset checklistSectionSmartList.addOrder("sortOrder|Asc") />

<cfif !structKeyExists(rc,"download")>
	<cfoutput>
	<div class="row">
		<div class="span9 sectionName">
			<span class="smaller">#rc.checklist.getChecklistName()#</span>
		</div>
		<div class="span3 pull-right offset1">
			<div class="btn-group pull-right">
				<a class="btn-small" href="/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=#rc.clientGroupChecklistID#"><i class="icon-chevron-left smallIcon"></i> Back</a>
			</div>
		</div>
	</div>	
	
	<div class="row">
		<div class="span9 checklistName">
			<span>#rc.clientGroupChecklist.getClientGroupChecklistName()#</span>
		</div>
		<div class="span3">
			<div class="btn-group pull-right">
				<a class="btn btn-default" href="/index.cfm?#cgi.query_string#&download=1&format=doc" class="btn btn-primary">Download (Word)</a></button>
				<a class="btn btn-default" href="/index.cfm?#cgi.query_string#&download=1&format=PDF" class="btn btn-primary">Download (PDF)</a>
			</div>
		</div>
	</div>
	
	<cfloop array="#checklistSectionSmartList.getRecords()#" index="checklistSection">
		<div id="viewAllAnswers">
			
			<h3>#checklistSection.getChecklistSectionName()#</h3>
		
			<cfset questionSmartList = checklistSection.getQuestionsSmartList() />
			<cfset questionSmartList.addFilter("activeFlag",1) />
			<cfset questionSmartList.addOrder("sortOrder|Asc") />
			<ul>
				<cfloop array="#questionSmartList.getRecords()#" index="question">
					<!--- DISPLAY ANSWERS! --->
					<cfif structKeyExists(answerStruct,question.getQuestionID())>
						<cfset rc.answer[question.getQuestionID()] = {} />
						<cfset rc.answer[question.getQuestionID()].answerValue = answerStruct[question.getQuestionID()].answerValue />
						<!--- <cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = answerStruct[question.getQuestionID()].clientGroupChecklistAnswerID /> --->
					<cfelse>
						<cfset rc.answer[question.getQuestionID()] = {} />
						<cfset rc.answer[question.getQuestionID()].answerValue = "" />
						<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = "" />
					</cfif>
					<!--- for check boxes default the answer value to '' --->
					<cfparam name="rc.answer[question.getQuestionID()].answerValue" default="" />
					
					<li>
						<cfif question.getAnswerType().getType() NEQ "none">
							<div class="viewAllQuestion">
								<span>#question.getQuestionText()#</span>
							</div>
							
							<cfif len(question.getPlanLanguage())>
								<div class="viewAllPlanLanguage">#question.getPlanLanguage()#</div>
							</cfif>
							
							<div class="viewAllAnswers">
								<cf_fieldStatic fieldName="answer.#question.getQuestionID()#.answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getQuestionHint()#" value="#rc.answer[question.getQuestionID()].answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" />
							</div>
						<cfelse>
							<div class="viewAllQuestionHeader">
								<span>#trim(question.getQuestionText())#</span>
							</div>
						</cfif>
					</li>
				</cfloop>
			</ul>
		</div>
	</cfloop>
	</cfoutput>
	
	<script>
		$('.viewAllAnswers input, .viewAllAnswers textarea, .viewAllAnswers select').attr('disabled','disabled');
	</script>
	
<cfelse>
	<cfparam name="format" default="PDF" />
	
	<cfif format EQ "PDF">
		<cfheader name="Content-Disposition" value="attachment; filename=#rereplace(rc.clientGroupChecklist.getClientGroupChecklistName(),'[^a-zA-z0-9]','_','all')#.pdf">
		<cfcontent type="application/pdf">
		<cfdocument format="pdf">
			<style>
				body { font-family: Arial; }
				#content_container { clear: both; text-align: left; margin-top: 25px; float: left; width: 950px; }
				
				p.footer { font-family: Arial, Helvetica, sans-serif; font-size: 10px; text-align: right; }
				
				h1 { font-family: Arial, Helvetica, sans-serif; font-size: 24px; }
				h3 { font-family: Arial, Helvetica, sans-serif; font-size: 16px; }
				
				#surveyResults ul { list-style: none; margin: 0px;  }
			</style>	
			
			<cfoutput>		
			<h1>#rc.clientGroupChecklist.getClientGroupChecklistName()#</h1>
				
			<cfloop array="#checklistSectionSmartList.getRecords()#" index="checklistSection">
				<div id="viewAllAnswers">
					
					<h3>#checklistSection.getChecklistSectionName()#</h3>
				
					<cfset questionSmartList = checklistSection.getQuestionsSmartList() />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.addOrder("sortOrder|Asc") />
					
					<div class="sectionGroup">
						<cfloop array="#questionSmartList.getRecords()#" index="question">
							<!--- DISPLAY ANSWERS! --->
							<cfif structKeyExists(answerStruct,question.getQuestionID())>
								<cfset rc.answer[question.getQuestionID()] = {} />
								<cfset rc.answer[question.getQuestionID()].answerValue = answerStruct[question.getQuestionID()].answerValue />
								<!---<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = answerStruct[question.getQuestionID()].clientGroupChecklistAnswerID />--->
							<cfelse>
								<cfset rc.answer[question.getQuestionID()] = {} />
								<cfset rc.answer[question.getQuestionID()].answerValue = "" />
								<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = "" />
							</cfif>
							<!--- for check boxes default the answer value to '' --->
							<cfparam name="rc.answer[question.getQuestionID()].answerValue" default="" />
							
							<div class="sectionGroupQuestion">
								<cfif question.getAnswerType().getType() NEQ "none">
									<div class="viewAllQuestion" style="width: 100%; background: ##eee; clear: both; padding: 10px; font-size: 12px; border-top: 1px solid ##ccc; margin-bottom: 10px;">
										#question.getQuestionText()#
									</div>
									
									<cfif len(question.getPlanLanguage())>
										<div class="viewAllPlanLanguage" style="width: 100%; clear: both; padding: 10 20px; font-size: 12px; margin-bottom: 10px;">
											#question.getPlanLanguage()#
										</div>
									</cfif>
									
									<div class="viewAllAnswers" style="font-size: 12px; clear: both; padding: 10px;">
										<cf_fieldStatic fieldName="answer.#question.getQuestionID()#.answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getQuestionHint()#" value="#rc.answer[question.getQuestionID()].answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" />
									</div>
								<cfelse>
									<div class="viewAllQuestion" style="width: 100%; background: ##fff; clear: both; padding: 10px; font-size: 12px; margin-top: 10px; margin-bottom: 10px;">
										#question.getQuestionText()#
									</div>
								</cfif>
							</div>
						</cfloop>
					</div>
				</div>
			</cfloop>
			
			<cfdocumentitem type = "footer">
				<p class="footer">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</p>
			</cfdocumentitem>
	    	
			</cfoutput>
		</cfdocument>
	<cfelseif format EQ "doc">

		<cfsavecontent variable="clientGroupChecklistAnswer">
			<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'>
			<head><title></title>
			
			<!--[if gte mso 9]>
			<xml>
			<w:WordDocument>
				<w:View>Print</w:View>
				<w:Zoom>90</w:Zoom>
				<w:DoNotOptimizeForBrowser/>
			</w:WordDocument>
			</xml>
			<![endif]-->
			
			<style>
			p.MsoFooter, li.MsoFooter, div.MsoFooter {
				margin:0in;
				margin-bottom:.0001pt;
				mso-pagination:widow-orphan;
				tab-stops:center 3.0in right 6.0in;
				font-size:#defaultFontSize#.0pt;
				}
			<style>
			
			<!-- /* Style Definitions */ -->
			
			@page {
			    mso-page-orientation: #orientation#;
			    margin: #planDocumentTemplate.getmarginTop()#in #planDocumentTemplate.getMarginRight()#in #planDocumentTemplate.getMarginBottom()#in #planDocumentTemplate.getMarginLeft()#in;
				font-size:#defaultFontSize#.0pt;
				font-family: #defaultFont#;
				text-align: justify;
				}
			
			@page Section1 {
				mso-page-orientation: #orientation#;
				size: #pageSize#;	
					
				margin: #planDocumentTemplate.getmarginTop()#in #planDocumentTemplate.getMarginRight()#in #planDocumentTemplate.getMarginBottom()#in #planDocumentTemplate.getMarginLeft()#in;
				mso-header-margin:.5in;
				mso-header:h1;
				mso-footer: f1; 
				mso-footer-margin:.5in;
				}
			
			div.Section1 {
				page:Section1;
				}
			
			table##hrdftrtbl {
				margin: 0in 0in 0in 11in;
				}
					
			p.MsoFooter p { text-align: left !important; }	
			
			body { font-family: Arial; }
			#content_container { clear: both; text-align: left; margin-top: 25px; float: left; width: 950px; }
			
			p.footer { font-family: Arial, Helvetica, sans-serif; font-size: 10px; text-align: right; }
			
			h1 { font-family: Arial, Helvetica, sans-serif; font-size: 24px; }
			h3 { font-family: Arial, Helvetica, sans-serif; font-size: 16px; }
			
			#surveyResults ul { list-style: none; margin: 0px;  }
			
			input[type=hidden] { display: none; visibility: hidden; }
			
			</style></head>
			
			<cfoutput>		
			<h1>#rc.clientGroupChecklist.getClientGroupChecklistName()#</h1>
			
			<cfloop array="#checklistSectionSmartList.getRecords()#" index="checklistSection">
				<div id="viewAllAnswers">
					
					<h3>#checklistSection.getChecklistSectionName()#</h3>
					
					<cfset questionSmartList = checklistSection.getQuestionsSmartList() />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.addOrder("sortOrder|Asc") />
					
					<div class="sectionGroup">
						<cfloop array="#questionSmartList.getRecords()#" index="question">
							<!--- DISPLAY ANSWERS! --->
							<cfif structKeyExists(answerStruct,question.getQuestionID())>
								<cfset rc.answer[question.getQuestionID()] = {} />
								<cfset rc.answer[question.getQuestionID()].answerValue = answerStruct[question.getQuestionID()].answerValue />
								<!---<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = answerStruct[question.getQuestionID()].clientGroupChecklistAnswerID />--->
							<cfelse>
								<cfset rc.answer[question.getQuestionID()] = {} />
								<cfset rc.answer[question.getQuestionID()].answerValue = "" />
								<cfset rc.answer[question.getQuestionID()].clientGroupChecklistAnswerID = "" />
							</cfif>
							<!--- for check boxes default the answer value to '' --->
							<cfparam name="rc.answer[question.getQuestionID()].answerValue" default="" />
							
							<div class="sectionGroupQuestion">
								<cfif question.getAnswerType().getType() NEQ "none">
									<div class="viewAllQuestion" style="width: 100%; background: ##eee; clear: both; padding: 10px; font-size: 12px; border-top: 1px solid ##ccc; margin-bottom: 10px;">
										#question.getQuestionText()#
									</div>
									
									<cfif len(question.getPlanLanguage())>
										<div class="viewAllPlanLanguage" style="width: 100%; clear: both; padding: 10 20px; font-size: 12px; margin-bottom: 10px;">
											#question.getPlanLanguage()#
										</div>
									</cfif>
									
									<div class="viewAllAnswers" style="font-size: 12px; clear: both; padding: 10px;">
										<cf_fieldStatic fieldName="answer.#question.getQuestionID()#.answerValue" questionDefaultValue="#question.getDefaultAnswerValue()#" questionCode="#question.getQuestionCode()#" questionID="#question.getQuestionID()#" fieldType="#question.getAnswerType().getType()#" questionHint="#question.getQuestionHint()#" value="#rc.answer[question.getQuestionID()].answerValue#" valueOptions="#question.getQuestionAnswersOptions()#" />
									</div>
								<cfelse>
									<div class="viewAllQuestion" style="width: 100%; background: ##fff; clear: both; padding: 10px; font-size: 12px; margin-top: 10px; margin-bottom: 10px;">
										#question.getQuestionText()#
									</div>
								</cfif>
							</div>
						</cfloop>
					</div>
				</div>
			</cfloop>
			
			<table id='hrdftrtbl' border='0' cellspacing='0' cellpadding='0'>
				<tr>
					<td>
						<div style='mso-element: footer' id="f1">
			               	<p class="MsoFooter">
								<span style='mso-tab-count:2'></span><span style='mso-field-code:" PAGE "'></span> 
							</p>
			            </div>
					</td>
				</tr>
			</table>
			
			</body>
			</html>	
			</cfoutput>
		</cfsavecontent>
	
		<cfheader name="Content-Disposition" value="attachment; filename=#rereplace(rc.clientGroupChecklist.getClientGroupChecklistName(),'[^a-zA-z0-9]','_','all')#.doc">
		<cfcontent type="application/msword" variable="#ToBinary(ToBase64(clientGroupChecklistAnswer))#">
	</cfif>
</cfif>