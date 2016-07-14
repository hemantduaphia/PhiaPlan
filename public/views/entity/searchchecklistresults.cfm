<cfparam name="rc.checklistID" />
<cfparam name="rc.keyword" default="" />

<cfif rc.keyword NEQ "">
	<cfset questionSearchSmartlist = $.PhiaPlan.getService("planService").getQuestionSmartList(data=rc) />
	<cfset questionSearchSmartlist.addFilter("activeFlag",1) />
	<cfset questionSearchSmartlist.addFilter("checklistSection.activeFlag",1) />
	<cfset questionSearchSmartlist.addFilter("checklistSection.checklist.checklistID",rc.checklistID) />
	<cfset questionSearchSmartlist.addKeywordProperty(propertyIdentifier="questionText", weight=1) />
	<cfset questionSearchSmartlist.addKeywordProperty(propertyIdentifier="questionHint", weight=1) />
	<cfset questionSearchSmartlist.addKeywordProperty(propertyIdentifier="planLanguage", weight=1) />
	<cfset questionSearchSmartlist.addOrder("checklistSection.sortOrder|asc") />
	
	<cfoutput>
	<cfif arraylen(questionSearchSmartlist.getRecords())>
		<p>Results:	#arraylen(questionSearchSmartlist.getRecords())#</p>
		
		<table class="table">
			<tr>
				<th>Section</th>
				<th>Question</th>
			</tr>
			<cfloop array="#questionSearchSmartlist.getRecords()#" index="questionSearchResult">	
				<tr>
					<td>#questionSearchResult.getChecklistSection().getChecklistSectionName()#</td>
					<td class="primary"><a href="/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=#url.clientGroupChecklistID#&checklistsectionID=#questionSearchResult.getChecklistSection().getChecklistSectionID()####questionSearchResult.getQuestionID()#">#questionSearchResult.getQuestionText()#</a></td>
				</tr>
			</cfloop>
		</table>
	<cfelse>
		<p>No results found!</p>
	</cfif>
	</cfoutput>
</cfif>