<cfparam name="rc.checklistSection" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset questionAnswerDependencySmartList = $.phiaplan.getService('planService').getQuestionAnswerSmartList() />
<cfset questionAnswerDependencySmartList.addFilter("question_checklistSection_checklist_checklistID",rc.checklistSection.getChecklist().getChecklistID()) />
<cfset questionAnswerDependencySmartList.addOrder("question_checklistSection_sortorder|asc") />
<cfset questionAnswerDependencySmartList.addOrder("question_sortorder|asc") />
<cfset questionAnswerDependencySmartList.addOrder("sortorder|asc") />
<cfset questionAnswerDependencySmartList.setSelectDistinctFlag(0) />

<cfset selectedValues = "" >
<cfloop array="#rc.checklistSection.getQuestionAnswerDependencies()#" index="QuestionAnswer">
	<cfset selectedValues = listAppend(selectedValues,questionAnswer.getQuestionAnswerID()) />
</cfloop>

<cf_HibachiListingDisplay smartList="#questionAnswerDependencySmartList#"
						  multiselectFieldName="questionAnswerDependencies"
						  multiselectValues="#selectedValues#">
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="extendedSimpleRepresentation" /> 
</cf_HibachiListingDisplay>
		
		