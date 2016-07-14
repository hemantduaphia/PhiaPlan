<cfparam name="rc.question" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cfif listFindNoCase( "atCheckBoxGroup,atMultiSelect,atRadioGroup,atSelect",rc.question.getAnswerType().getSystemCode() )>
		
		<cf_HibachiListingDisplay smartList="#rc.question.getQuestionAnswersSmartList()#"
								   recordEditAction="admin:entity.editquestionanswer" 
								   recordEditQueryString="questionID=#rc.question.getQuestionID()#&sRedirectAction=admin:entity.detailquestion"
								   recordDetailAction="admin:entity.detailquestionanswer" 
								   recordDetailQueryString="questionID=#rc.question.getQuestionID()#"
								   recordDeleteAction="admin:entity.deletequestionanswer"
								   recordDeleteQueryString="questionID=#rc.question.getQuestionID()#&sRedirectAction=admin:entity.detailquestion"
								   sortProperty="sortOrder"
								   sortContextIDColumn="questionID"
								   sortContextIDValue="#rc.question.getQuestionID()#">
			<cf_HibachiListingColumn propertyIdentifier="answerCode" /> 
			<cf_HibachiListingColumn propertyIdentifier="answerValue" /> 
			<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="answerLabel" /> 
		</cf_HibachiListingDisplay>
		
		<cf_HibachiActionCaller action="admin:entity.createquestionanswer" class="btn btn-inverse" icon="plus icon-white" queryString="questionID=#rc.question.getQuestionID()#" modal=true />
	</cfif>
	
</cfoutput>