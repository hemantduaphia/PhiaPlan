<cfif Not rc.questionAnswer.isNew()>
	<cfset rc.question = rc.questionAnswer.getQuestion() /> 
</cfif>
<cfparam name="rc.questionAnswer" type="any">
<cfparam name="rc.question" type="any" default="#rc.questionAnswer.getQuestion()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.questionAnswer#" saveActionQueryString="questionID=#rc.question.getQuestionID()#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.questionAnswer#" edit="#rc.edit#" 
									backAction="admin:entity.detailQuestion" 
								    backQueryString="questionID=#rc.question.getQuestionID()#" 
								    cancelAction="admin:entity.detailQuestion"
									cancelQueryString="questionID=#rc.question.getQuestionID()#" />
		
		<!--- Hidden field to allow rc.question to be set on invalid submit --->
		<input type="hidden" name="questionID" value="#rc.question.getQuestionID()#" />
		
		<!--- Hidden field to attach this to the question --->
		<input type="hidden" name="question.questionID" value="#rc.question.getQuestionID()#" />

		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.questionAnswer#" property="answerCode" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.questionAnswer#" property="answerLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.questionAnswer#" property="answerValue" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.questionAnswer#">
			<cf_HibachiTab property="excludedQuestions" />
			<cf_HibachiTab property="excludedChecklistSections" />
			<cf_HibachiTab property="planLanguage" />
			<cf_HibachiTab property="answerHint" />
			<cf_HibachiTab property="questionAnswerTexts" />
			<cf_HibachiTab property="answerPopulateText" />
		</cf_HibachiTabGroup>

	</cf_HibachiEntityDetailForm>
</cfoutput>