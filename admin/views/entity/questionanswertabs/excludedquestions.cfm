<cfparam name="rc.questionAnswer" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset questionSmartList = $.phiaplan.getService('planService').getQuestionSmartList() />
<cfset questionSmartList.addFilter("checklistSection_checklist_checklistID",rc.questionAnswer.getQuestion().getChecklistSection().getChecklist().getChecklistID()) />
<cfset questionSmartList.addOrder("checklistSection_sortorder|asc") />
<cfset questionSmartList.addOrder("sortorder|asc") />
<cfset questionSmartList.setSelectDistinctFlag(0) />
<cfset questionSmartList.applyData({"p:show"="20"}) />

<cfset selectedcodes = [] />
<cfset selectedValues = "" >
<cfloop array="#rc.questionAnswer.getExcludedQuestions()#" index="excludedQuestion">
	<cfset arrayAppend(selectedcodes,excludedQuestion.getQuestionCode()) />
	<cfset selectedValues = listAppend(selectedValues,excludedQuestion.getQuestionID()) />
</cfloop>

<cfoutput><strong>Selected Question Codes:</strong> <cfif arrayLen(selectedcodes)>#arrayToList(selectedcodes,", ")#<cfelse>None</cfif></cfoutput>
<p>
<cf_HibachiListingDisplay smartList="#questionSmartList#"
						  multiselectFieldName="excludedQuestions"
						  multiselectValues="#selectedValues#">
	<cf_HibachiListingColumn propertyIdentifier="questionCode" search="true" /> 
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="questionText" search="true" /> 
</cf_HibachiListingDisplay>
		
		