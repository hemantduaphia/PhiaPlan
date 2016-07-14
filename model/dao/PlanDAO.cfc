<cfcomponent  extends="PhiaPlan.org.Hibachi.HibachiDAO">

	<cffunction name="deleteClientGroupChecklistAnswerQry" returntype="void">
		<cfargument name="clientGroupChecklistAnswerID" type="string" />
		
		<cfquery name="local.delete">
			DELETE FROM ClientGroupChecklistAnswer
			WHERE clientGroupChecklistAnswerID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientGroupChecklistAnswerID#" />
		</cfquery>
		
	</cffunction>
		
	<cffunction name="getClientChecklistCount" returntype="any">
		<cfargument name="clientID" type="string" />
		<cfargument name="planDocumentTemplateID" type="string" />
		
		<cfquery name="local.checklistCount">
			SELECT COUNT(*) as totalChecklist FROM ClientGroupChecklist
			INNER JOIN ClientGroup ON ClientGroupChecklist.clientGroupID = ClientGroup.clientGroupID
			WHERE ClientGroup.clientID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientID#" />
			AND ClientGroupChecklist.planDocumentTemplateID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.planDocumentTemplateID#" />
		</cfquery>
		
		<cfreturn local.checklistCount.totalChecklist />
	</cffunction>
		
	<cffunction name="getChecklistQuestionByQuestionCode" returntype="any">
		<cfargument name="questionCode" type="string" />
		<cfargument name="checklistID" type="string" />
		
		<cfset var question = ormExecuteQuery("FROM PhiaPlanQuestion q WHERE questionCode = :questionCode AND q.checklistSection.checklist.checklistID = :checklistID ", {questionCode=arguments.questionCode, checklistID = arguments.checklistID}, "true") />
		<cfif !isNull(question)>
			<cfreturn question />
		</cfif>
	</cffunction>
		
	<cffunction name="getTrackedAnswerExportQuery" returntype="any">
		
		<cfquery name="local.trackedAnswers">
			SELECT client.clientName,clientgroup.clientGroupName,checklist.checklistName,question.questionText,question.questionCode,ClientGroupChecklistAnswer.answerValue,Account.firstname,Account.lastname,ClientGroupChecklistAnswer.createdDateTime
			FROM ClientGroupChecklistAnswer
			INNER JOIN Question ON ClientGroupChecklistAnswer.questionID = Question.questionID
			INNER JOIN ClientGroupChecklist ON ClientGroupChecklistAnswer.clientGroupChecklistID = ClientGroupChecklist.clientGroupChecklistID
			INNER JOIN Checklist ON ClientGroupChecklist.checklistID = Checklist.checklistID
			INNER JOIN ClientGroup ON ClientGroupChecklist.clientGroupID = ClientGroup.clientGroupID
			INNER JOIN Client ON ClientGroup.clientID = Client.clientID
			INNER JOIN Account ON ClientGroupChecklistAnswer.createdByAccountID = Account.accountID
			WHERE trackAnswerFlag = 1
		</cfquery>
		
		<cfreturn local.trackedAnswers />
	</cffunction>
		
		
</cfcomponent>