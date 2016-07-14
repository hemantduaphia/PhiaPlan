<cfparam name="rc.question" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset questionAnswerDependencySmartList = $.phiaplan.getService('planService').getQuestionAnswerSmartList() />
<cfset questionAnswerDependencySmartList.addFilter("question_checklistSection_checklist_checklistID",rc.question.getChecklistSection().getChecklist().getChecklistID()) />
<cfset questionAnswerDependencySmartList.addOrder("question_checklistSection_sortorder|asc") />
<cfset questionAnswerDependencySmartList.addOrder("question_sortorder|asc") />
<cfset questionAnswerDependencySmartList.addOrder("sortorder|asc") />
<cfset questionAnswerDependencySmartList.setSelectDistinctFlag(0) />

<cfset selectedcodes = [] />
<cfset selectedValues = "" >
<cfloop array="#rc.question.getQuestionAnswerDependencies()#" index="QuestionAnswer">
	<cfset arrayAppend(selectedcodes,questionAnswer.getQuestion().getQuestionCode()) />
	<cfset selectedValues = listAppend(selectedValues,questionAnswer.getQuestionAnswerID()) />
</cfloop>

<cfoutput><strong>Selected Question Codes:</strong> <cfif arrayLen(selectedcodes)>#arrayToList(selectedcodes,", ")#<cfelse>None</cfif></cfoutput>
<p>
<cf_HibachiListingDisplay smartList="#questionAnswerDependencySmartList#"
						  multiselectFieldName="questionAnswerDependencies"
						  multiselectValues="#selectedValues#">
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="extendedSimpleRepresentation" /> 
</cf_HibachiListingDisplay>
		
		