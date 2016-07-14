<cfif Not rc.questionAnswerText.isNew()>
	<cfset rc.questionAnswer = rc.questionAnswerText.getQuestionAnswer() /> 
</cfif>
<cfparam name="rc.questionAnswerText" type="any">
<cfparam name="rc.questionAnswer" type="any" default="#rc.questionAnswerText.getQuestionAnswer()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.questionAnswerText#" saveActionQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.questionAnswerText#" edit="#rc.edit#" 
									backAction="admin:entity.detailQuestionAnswer" 
								    backQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#" 
								    cancelAction="admin:entity.detailQuestionAnswer"
									cancelQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#"
								    saveActionHash="tabquestionanswertexts" />
		
		<!--- Hidden field to allow rc.questionAnswer to be set on invalid submit --->
		<input type="hidden" name="questionAnswerID" value="#rc.questionAnswer.getQuestionAnswerID()#" />
		
		<!--- Hidden field to attach this to the questionAnswer --->
		<input type="hidden" name="questionAnswer.questionAnswerID" value="#rc.questionAnswer.getQuestionAnswerID()#" />

		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.questionAnswerText#" property="extension" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.questionAnswerText#" property="answerText" edit="#rc.edit#">					
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>

	</cf_HibachiEntityDetailForm>
</cfoutput>