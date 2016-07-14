<cfparam name="rc.questionAnswer" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset checklistSectionSmartList = $.phiaplan.getService('planService').getChecklistSectionSmartList() />
<cfset checklistSectionSmartList.addFilter("checklist_checklistID",rc.questionAnswer.getQuestion().getChecklistSection().getChecklist().getChecklistID()) />
<cfset checklistSectionSmartList.addOrder("sortorder|asc") />
<!---<cfset checklistSectionSmartList.setSelectDistinctFlag(0) />--->
<cfset checklistSectionSmartList.applyData({"p:show"="20"}) />

<cfset selectedValues = "" >
<cfloop array="#rc.questionAnswer.getExcludedChecklistSections()#" index="excludedChecklistSection">
	<cfset selectedValues = listAppend(selectedValues,excludedChecklistSection.getChecklistSectionID()) />
</cfloop>

<cf_HibachiListingDisplay smartList="#checklistSectionSmartList#"
						  multiselectFieldName="excludedChecklistSections"
						  multiselectValues="#selectedValues#">
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="checklistSectionName" search="true" /> 
</cf_HibachiListingDisplay>
		
		