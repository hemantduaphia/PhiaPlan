<cfparam name="rc.question" type="any" />
<cfparam name="rc.checklistSection" type="any" default="#rc.question.getChecklistSection()#" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.question#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.question#" edit="#rc.edit#" 
							backAction="admin:entity.detailChecklistSection" 
							backQueryString="checklistSectionID=#rc.checklistSection.getChecklistSectionID()#" 
							cancelAction="admin:entity.detailChecklistSection" 
							cancelQueryString="checklistSectionID=#rc.checklistSection.getChecklistSectionID()#" 
							deleteQueryString="redirectAction=admin:entity.detailChecklistSection&checklistSectionID=#rc.checklistSection.getChecklistSectionID()#" />
		
		<cfif rc.edit>
			<input type="hidden" name="checklistSectionID" value="#rc.checklistSection.getChecklistSectionID()#" />
			<input type="hidden" name="checklistSection.checklistSectionID" value="#rc.checklistSection.getChecklistSectionID()#" />
		</cfif>
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.question#" property="questionText" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="questionCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="questionNumber" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="questionNumberLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="requiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="answerType" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="defaultAnswerValue" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="trackAnswerFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="clientApprovedFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.question#" property="phiaApprovedFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.question#">
			<cfif not rc.question.isNew() and not isnull(rc.question.getAnswerType()) and listFindNoCase( "atCheckBoxGroup,atMultiSelect,atRadioGroup,atSelect",rc.question.getAnswerType().getSystemCode() )>
				<cf_HibachiTab property="questionAnswers" />
			</cfif>
			<cf_HibachiTab property="planLanguage" />
			<cf_HibachiTab property="questionHint" />
			<cf_HibachiTab property="questionAnswerDependencies" />
			<cf_AdminTabComments object="#rc.question#" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>
