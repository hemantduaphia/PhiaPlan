<cfset checklistSmartList = $.PhiaPlan.getService("planService").getchecklistSmartList() />
<cfset checklistSmartList.addFilter("checklistID","8a80818b49d2ab100149e2882d980194") />
<!--- CHECKLIST ID (DEV): 5124bffa46ceff770146d4d39230024f - Production: 8a80818b49d2ab100149e2882d980194 --->

<cfparam name="url.checklistSectionID" default="" />
<div class="row">
	<div class="span12">
		<div class="row-fluid">
			<div class="span6">
				<cfif !len(url.checklistSectionID)>
					<h3>Member Resources</h3>
				<cfelse>
					<h3><a href="/?PPAction=entity.memberresources">Member Resources</a></h3>	
				</cfif>
			</div>		
		</div>
		
		<hr style="margin: 5px 0px 20px 0px;">		
	</div>
</div>

<cfoutput>
<div class="row">
	<div class="span12">
		
		<cfif !len(url.checklistSectionID)>
			<cfloop array="#checklistSmartList.getPageRecords()#" index="resourceChecklist">
				
				#resourceChecklist.getChecklistDescription()#
				
				<!--- GET SECTIONS --->
				
				<cfset sectionSmartlist = resourceChecklist.getChecklistSectionsSmartList() />
				<cfset sectionSmartlist.addFilter("activeFlag",1) />
				<cfset sectionSmartlist.addOrder("sortOrder|asc") />
				<cfloop array="#sectionSmartlist.getRecords()#" index="questionSection">
					
					<div class="sectionHeader">
						<h2><a href="/?PPAction=entity.memberresources&checklistSectionID=#questionSection.getChecklistSectionID()#">#questionSection.getChecklistSectionName()#</a></h2>
					</div>
				
					<cfset questionSmartList = questionSection.getQuestionsSmartList() />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.setPageRecordsShow(6) />
					<cfset questionSmartList.addOrder("sortOrder|asc") />
					
					<div class="accordion" id="section-#questionSection.getChecklistSectionID()#">
						<cfset count = 0 />
						<cfloop array="#questionSmartList.getPageRecords()#" index="questionDetail">
							<div class="accordion-group">
								<div class="accordion-heading memberResourcesQuestion">
									<a class="accordion-toggle" data-toggle="collapse" data-parent="##section-#questionSection.getChecklistSectionID()#" href="##question#questionDetail.getQuestionID()#">
										#questionDetail.getQuestionText()#
									</a>
								</div>
								<div id="question#questionDetail.getQuestionID()#" class="accordion-body collapse">
									<div class="accordion-inner">
										#paragraphformat(questionDetail.getPlanLanguage())#
									</div>
								</div>
							</div>
							<cfset count ++ />
							<cfif count EQ "5">
								<div class="accordion-body resourceMore">
									<div class="accordion-inner" style="border-top: none;">
										<a href="/?PPAction=entity.memberresources&checklistSectionID=#questionSection.getChecklistSectionID()#"><i class="icon-plus"></i> View all #questionSection.getChecklistSectionName()# questions</a>
									</div>
								</div>
								<cfbreak>
							</cfif>
						</cfloop>
					</div>			
				</cfloop>
			</cfloop>
		<cfelse>

			<!--- SECTION! --->
			<cfloop array="#checklistSmartList.getPageRecords()#" index="resourceChecklist">
				
				<!--- GET SECTION --->
				
				<cfset sectionSmartlist = resourceChecklist.getChecklistSectionsSmartList() />
				<cfset sectionSmartlist.addFilter("activeFlag",1) />
				<cfset sectionSmartlist.addFilter("checklistSectionID",'#url.checklistSectionID#') />
				<cfset sectionSmartlist.addOrder("sortOrder|asc") />
				<cfloop array="#sectionSmartlist.getRecords()#" index="questionSection">
					
					<div class="sectionHeader">
						<h2>#questionSection.getChecklistSectionName()#</h2>
					</div>
				
					<cfset questionSmartList = questionSection.getQuestionsSmartList() />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.addFilter("activeFlag",1) />
					<cfset questionSmartList.setPageRecordsShow(999) />
					<cfset questionSmartList.addOrder("sortOrder|asc") />
					
					<div class="accordion" id="section-#questionSection.getChecklistSectionID()#">
						<cfloop array="#questionSmartList.getPageRecords()#" index="questionDetail">
							<div class="accordion-group">
								<div class="accordion-heading memberResourcesQuestion">
									<a class="accordion-toggle" data-toggle="collapse" data-parent="##section-#questionSection.getChecklistSectionID()#" href="##question#questionDetail.getQuestionID()#">
										#questionDetail.getQuestionText()#
									</a>
								</div>
								<div id="question#questionDetail.getQuestionID()#" class="accordion-body collapse">
									<div class="accordion-inner">
										#paragraphformat(questionDetail.getPlanLanguage())#
									</div>
								</div>
							</div>
						</cfloop>
					</div>			
				</cfloop>
			</cfloop>

			<a class="btn" href="/?PPAction=entity.memberresources">Back to Member Resources</a>

		</cfif>
	</div>
</div>
</cfoutput>	