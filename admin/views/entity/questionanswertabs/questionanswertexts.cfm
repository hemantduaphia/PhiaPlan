<cfparam name="rc.questionAnswer" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
		<cf_HibachiListingDisplay smartList="#rc.questionAnswer.getQuestionAnswerTextsSmartList()#"
								   recordEditAction="admin:entity.editquestionanswertext" 
								   recordEditQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#&sRedirectAction=admin:entity.detailquestionAnswer"
								   recordDetailAction="admin:entity.detailquestionanswertext" 
								   recordDetailQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#"
								   recordDeleteAction="admin:entity.deletequestionanswertext"
								   recordDeleteQueryString="questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#&sRedirectAction=admin:entity.detailquestionanswer"
								   sortProperty="extension"
								   sortContextIDColumn="questionAnswerID"
								   sortContextIDValue="#rc.questionAnswer.getQuestionAnswerID()#">
			<cf_HibachiListingColumn propertyIdentifier="extension" /> 
			<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="shortAnswerText" /> 
		</cf_HibachiListingDisplay>
		
		<cf_HibachiActionCaller action="admin:entity.createquestionanswertext" class="btn btn-inverse" icon="plus icon-white" queryString="sRedirectAction=admin:entity.detailQuestionAnswer&questionAnswerID=#rc.questionAnswer.getQuestionAnswerID()#" modal=true />
</cfoutput>