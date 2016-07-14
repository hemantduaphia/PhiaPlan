component accessors="true" extends="PhiaPlan.org.Hibachi.HibachiService" {

	property name="planDAO" type="any";
	property name="emailService" type="any";
	property name="hibachiUtilityService" type="any";

	public any function getChecklistSmartList(struct data={}, currentURL="") {
		arguments.entityName = "PhiaPlanChecklist";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty(arguments.entityName, "client", "left");
		
		return smartList;
	}
	
	public any function processChecklist_duplicate(required any checklist, required any processObject) {
		// this could take some time to finish
		getHibachiTagService().cfsetting(requesttimeout="900");
		
		var newChecklistSectionStruct = {};
		var newQuestionStruct = {};
		var pendingDependentQuestionArray = [];
		var pendingDependentSectionArray = [];
		var pendingExcludedQuestionArray = [];
		var pendingExcludedSectionArray = [];
		// duplicate the checklist
		var newChecklist = this.newChecklist();
		newChecklist.setChecklistName( arguments.processObject.getChecklistName() );
		newChecklist.setChecklistCode( arguments.processObject.getChecklistCode() );
		newChecklist.setChecklistDescription( arguments.checklist.getChecklistDescription() );
		
		// Copy Checklist Sections
		for(var checklistSection in arguments.checklist.getChecklistSections()) {
			var newChecklistSection = this.newChecklistSection();
			
			newChecklistSection.setChecklistSectionName( checklistSection.getChecklistSectionName() );
			newChecklistSection.setChecklistSectionCode( checklistSection.getChecklistSectionCode() );
			newChecklistSection.setChecklistSectionDescription( checklistSection.getChecklistSectionDescription() );
			newChecklistSection.setActiveFlag( checklistSection.getActiveFlag() );
			newChecklistSection.setSortOrder( checklistSection.getSortOrder() );
			newChecklistSection.setChecklist( newChecklist );
			
			newChecklistSectionStruct[checklistSection.getChecklistSectionCode()] = newChecklistSection;
		
			// copy checklist section questions
			for(var question in checklistSection.getQuestions()) {
				var newQuestion = this.newQuestion();
				newQuestion.setQuestionText(question.getQuestionText());
				newQuestion.setQuestionCode(question.getQuestionCode());
				newQuestion.setQuestionNumber(question.getQuestionNumber());
				newQuestion.setQuestionNumberLabel(question.getQuestionNumberLabel());
				newQuestion.setQuestionHint(question.getQuestionHint());
				newQuestion.setPlanLanguage(question.getPlanLanguage());
				newQuestion.setDefaultAnswerValue(question.getDefaultAnswerValue());
				newQuestion.setRequiredFlag(question.getRequiredFlag());
				newQuestion.setActiveFlag(question.getActiveFlag());
				newQuestion.setTrackAnswerFlag(question.getTrackAnswerFlag());
				newQuestion.setSortOrder(question.getSortOrder());
				newQuestion.setAnswerType(question.getAnswerType());
				newQuestion.setChecklistSection(newChecklistSection);
				
				newQuestionStruct[question.getQuestionCode()] = newQuestion;
				
				// copy question answers
				
				for(var questionAnswer in question.getQuestionAnswers()) {
					var newQuestionAnswer = this.newQuestionAnswer();
					newQuestionAnswer.setAnswerValue(questionAnswer.getAnswerValue());
					newQuestionAnswer.setAnswerLabel(questionAnswer.getAnswerLabel());
					newQuestionAnswer.setAnswerCode(questionAnswer.getAnswerCode());
					newQuestionAnswer.setAnswerHint(questionAnswer.getAnswerHint());
					newQuestionAnswer.setAnswerPopulateText(questionAnswer.getAnswerPopulateText());
					newQuestionAnswer.setPlanLanguage(questionAnswer.getPlanLanguage());
					newQuestionAnswer.setSortOrder(questionAnswer.getSortOrder());
					newQuestionAnswer.setQuestion(newQuestion);

					// copy all the answertexts
					for(var questionAnswerText in questionAnswer.getQuestionAnswerTexts()) {
						var newQuestionAnswerText = this.newQuestionAnswerText();
						newQuestionAnswerText.setAnswerText(questionAnswerText.getAnswerText());
						newQuestionAnswerText.setSortOrder(questionAnswerText.getSortOrder());
						newQuestionAnswerText.setExtension(questionAnswerText.getExtension());
						newQuestionAnswerText.setQuestionAnswer(newQuestionAnswer);
					}
										
										
					// copy all the dependent questions
					for(var dependentQuestion in questionAnswer.getDependentQuestions()) {
						if(structKeyExists(newQuestionStruct,dependentQuestion.getQuestionCode())){
							newQuestionAnswer.addDependentQuestion( newQuestionStruct[dependentQuestion.getQuestionCode()] );
						} else {
							// if the question doesn't exist yet add it to be proccesed later
							arrayAppend(pendingDependentQuestionArray,{newQuestionAnswer=newQuestionAnswer,questionCode=dependentQuestion.getQuestionCode()});
						}
					}

					// copy all the dependent sections
					for(var dependentChecklistSection in questionAnswer.getDependentChecklistSections()) {
						if(structKeyExists(newChecklistSectionStruct,dependentChecklistSection.getChecklistSectionCode())){
							newQuestionAnswer.addDependentChecklistSection( newChecklistSectionStruct[dependentChecklistSection.getChecklistSectionCode()] );
						} else {
							// if the section doesn't exist yet add it to be proccesed later
							arrayAppend(pendingDependentSectionArray,{newQuestionAnswer=newQuestionAnswer,sectionCode=dependentChecklistSection.getChecklistSectionCode()});
						}
					}

					// copy all the excluded questions
					for(var excludedQuestion in questionAnswer.getExcludedQuestions()) {
						if(structKeyExists(newQuestionStruct,excludedQuestion.getQuestionCode())){
							newQuestionAnswer.addExcludedQuestion( newQuestionStruct[excludedQuestion.getQuestionCode()] );
						} else {
							// if the question doesn't exist yet add it to be proccesed later
							arrayAppend(pendingExcludedQuestionArray,{newQuestionAnswer=newQuestionAnswer,questionCode=excludedQuestion.getQuestionCode()});
						}
					}

					// copy all the excluded sections
					for(var excludedChecklistSection in questionAnswer.getExcludedChecklistSections()) {
						if(structKeyExists(newChecklistSectionStruct,excludedChecklistSection.getChecklistSectionCode())){
							newQuestionAnswer.addExcludedChecklistSection( newChecklistSectionStruct[excludedChecklistSection.getChecklistSectionCode()] );
						} else {
							// if the section doesn't exist yet add it to be proccesed later
							arrayAppend(pendingExcludedSectionArray,{newQuestionAnswer=newQuestionAnswer,sectionCode=excludedChecklistSection.getChecklistSectionCode()});
						}
					}

				}
				
			}
		}
		
		// now that all the questions and sections exists add any pending dependency
		for(var item in pendingDependentQuestionArray) {
			item.newQuestionAnswer.addDependentQuestion( newQuestionStruct[item.questionCode] );
		}
		
		for(var item in pendingDependentSectionArray) {
			item.newQuestionAnswer.addDependentChecklistSection( newChecklistSectionStruct[item.sectionCode] );
		}
		
		// now that all the questions and sections exists add any pending exclusion
		for(var item in pendingExcludedQuestionArray) {
			item.newQuestionAnswer.addExcludedQuestion( newQuestionStruct[item.questionCode] );
		}
		
		for(var item in pendingExcludedSectionArray) {
			item.newQuestionAnswer.addExcludedChecklistSection( newChecklistSectionStruct[item.sectionCode] );
		}
		
		
		
		this.saveChecklist( newChecklist );
				
		return newChecklist;
	}
	
	public any function processPlanDocumentTemplate_duplicate(required any planDocumentTemplate, required any processObject) {
		// this could take some time to finish
		getHibachiTagService().cfsetting(requesttimeout="900");
		
		// duplicate the planDocumentTemplate
		var newPlanDocumentTemplate = this.newPlanDocumentTemplate();
		newPlanDocumentTemplate.setPlanDocumentTemplateName( arguments.processObject.getPlanDocumentTemplateName() );
		newPlanDocumentTemplate.setPlanDocumentTemplateCode( arguments.processObject.getPlanDocumentTemplateCode() );
		newPlanDocumentTemplate.setPlanDocumentTemplateDescription( arguments.planDocumentTemplate.getPlanDocumentTemplateDescription() );
		newPlanDocumentTemplate.setPlanDocumentFooterText( arguments.planDocumentTemplate.getPlanDocumentFooterText() );
		newPlanDocumentTemplate.setPlanDocumentHeaderText( arguments.planDocumentTemplate.getPlanDocumentHeaderText() );
		newPlanDocumentTemplate.setChecklist( arguments.planDocumentTemplate.getChecklist() );
		
		newPlanDocumentTemplate.setOrientation( arguments.planDocumentTemplate.getOrientation() );
		newPlanDocumentTemplate.setMarginTop( arguments.planDocumentTemplate.getMarginTop() );
		newPlanDocumentTemplate.setMarginBottom( arguments.planDocumentTemplate.getMarginBottom() );
		newPlanDocumentTemplate.setMarginRight( arguments.planDocumentTemplate.getMarginRight() );
		newPlanDocumentTemplate.setMarginLeft( arguments.planDocumentTemplate.getMarginLeft() );
		newPlanDocumentTemplate.setParagraphSpacing( arguments.planDocumentTemplate.getParagraphSpacing() );
		newPlanDocumentTemplate.setDefaultFont( arguments.planDocumentTemplate.getDefaultFont() );
		newPlanDocumentTemplate.setDefaultFontSize( arguments.planDocumentTemplate.getDefaultFontSize() );
		newPlanDocumentTemplate.setListMarginAlignment( arguments.planDocumentTemplate.getParagraphSpacing() );
		
		// Copy Checklist Sections
		for(var planDocumentChecklistSection in arguments.planDocumentTemplate.getPlanDocumentChecklistSections()) {
			var newPlanDocumentChecklistSection = this.newPlanDocumentChecklistSection();
			
			newPlanDocumentChecklistSection.setPlanDocumentChecklistSectionDescription( planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription() );
			newPlanDocumentChecklistSection.setChecklistSectionName( planDocumentChecklistSection.getChecklistSectionName() );
			newPlanDocumentChecklistSection.setChecklistSectionCode( planDocumentChecklistSection.getChecklistSectionCode() );
			newPlanDocumentChecklistSection.setSortOrder( planDocumentChecklistSection.getSortOrder() );
			newPlanDocumentChecklistSection.setPhiaApprovedFlag( 0 );
			newPlanDocumentChecklistSection.setClientApprovedFlag( 0 );
			newPlanDocumentChecklistSection.setPlanDocumentTemplate( newPlanDocumentTemplate );
		}
			
		this.savePlanDocumentTemplate( newPlanDocumentTemplate );
				
		return newPlanDocumentTemplate;
	}
	
	public any function processClientGroupChecklist_duplicate(required any clientGroupChecklist, required any processObject) {
		// this could take some time to finish
		getHibachiTagService().cfsetting(requesttimeout="900");
		
		// duplicate the clientGroupChecklist
		var newClientGroupChecklist = this.newClientGroupChecklist();
		newClientGroupChecklist.setClientGroupChecklistName( arguments.processObject.getClientGroupChecklistName() );
		newClientGroupChecklist.setChecklist( arguments.processObject.getChecklist() );
		newClientGroupChecklist.setPlanDocumentTemplate( arguments.processObject.getPlanDocumentTemplate() );
		newClientGroupChecklist.setClientGroup( arguments.clientGroupChecklist.getClientGroup() );
		newClientGroupChecklist.setChecklistStatus( this.getType('5c18b649a18e1a173e685062171f152f') );
		
		
		// get all answers
        var query = new Query( sql="SELECT clientGroupChecklistAnswerID,Question.questionID,Question.questionCode FROM ClientGroupChecklistAnswer INNER JOIN Question ON ClientGroupChecklistAnswer.questionID = Question.questionID WHERE ClientGroupChecklistID = '#arguments.clientGroupChecklist.getClientGroupChecklistID()#'" );
        var clientGroupChecklistAnswersQry = query.execute().getResult();
	
        var query = new Query( sql="SELECT Question.questionID,Question.questionCode FROM Question INNER JOIN ChecklistSection ON Question.checklistSectionID = ChecklistSection.checklistSectionID WHERE ChecklistSection.checklistID = '#arguments.processObject.getChecklist().getChecklistID()#'" );
        var newChecklistAnswersQry = query.execute().getResult();
	
		// Copy Checklist Answers
		for(var clientGroupChecklistAnswer in arguments.clientGroupChecklist.getClientGroupChecklistAnswers()) {
			var newClientGroupChecklistAnswer = this.newClientGroupChecklistAnswer();
			
			var newQuestionID = "";
         	var currentQuestionQry = new Query( sql="SELECT questionCode FROM clientGroupChecklistAnswersQry WHERE clientGroupChecklistAnswerID='#clientGroupChecklistAnswer.getclientGroupChecklistAnswerID()#'", clientGroupChecklistAnswersQry=clientGroupChecklistAnswersQry, DBType='query' );
            var result = currentQuestionQry.execute().getResult();
            var currentQuestionCode = result.questionCode;
            if(currentQuestionCode NEQ "") {
	         	var newQuestionQry = new Query( sql="SELECT questionID FROM newChecklistAnswersQry WHERE questionCode='#currentQuestionCode#'", newChecklistAnswersQry=newChecklistAnswersQry, DBType='query' );
	            var result = newQuestionQry.execute().getResult();
	            var newQuestionID = result.questionID;
            }
			if(newQuestionID != ""){
				newClientGroupChecklistAnswer.setAnswerValue( clientGroupChecklistAnswer.getAnswerValue() );
				newClientGroupChecklistAnswer.setQuestion( this.getQuestion(newQuestionID) );
				newClientGroupChecklistAnswer.setClientGroupChecklist( newClientGroupChecklist );
			}
		}
		
		this.saveClientGroupChecklist( newClientGroupChecklist, {} );
		
		if(!newClientGroupChecklist.hasErrors()) {
			
			//ormflush();
		
			// copy all the comments
			var currentCommentsQry = new Query( sql="SELECT Comment.*,CommentRelationShip.*,Question.questionCode FROM Comment INNER JOIN CommentRelationShip ON Comment.commentID = CommentRelationShip.commentID INNER JOIN Question ON CommentRelationship.questionID = Question.questionID WHERE CommentRelationShip.clientGroupChecklistID='#clientGroupChecklist.getclientGroupChecklistID()#'" );
			var result = currentCommentsQry.execute().getResult();
	
			for(var i=1; i <= result.recordCount; i++) {
				// find new question ID
				var currentQuestionCode = result["questionCode"][i];
	         	var newQuestionQry = new Query( sql="SELECT questionID FROM newChecklistAnswersQry WHERE questionCode='#currentQuestionCode#'", newChecklistAnswersQry=newChecklistAnswersQry, DBType='query' );
	            var newQuestionQryResult = newQuestionQry.execute().getResult();
	            var newQuestionID = newQuestionQryResult.questionID;
				
				if(newQuestionID != ""){
					var newComment = this.newComment();
					newComment.setComment(result["comment"][i]);
					newComment.setPublicFlag(result["publicFlag"][i]);
					newComment.setCreatedDateTime(result["createdDateTime"][i]);
					newComment.setCreatedByAccount(this.getAccount(result["createdByAccountID"][i]));
					
					var newCommentRelationship = this.newCommentRelationship();
					newCommentRelationship.setComment(newComment);
					newCommentRelationship.setQuestion(this.getQuestion(newQuestionID));
					newCommentRelationship.setClientGroupChecklist(newClientGroupChecklist);
					
					this.saveComment( newComment, {} );
				}
			}
		}
				
		return newClientGroupChecklist;
	}
	
	public any function approve(required any entity) {
		arguments.entity.setClientApprovedFlag(1);
		// send email
	}
	
	public any function saveClientGroupChecklistAnswers(struct data={},any clientGroupChecklistID) {
		
		var clientGroupChecklistAnswerArray = [];
		
		for(var questionID in data) {
			// Call the generic save method to populate and validate
			var clientGroupChecklistAnswer = this.getClientGroupChecklistAnswer(data[questionID]["clientGroupChecklistAnswerID"],true);
			data[questionID]["clientGroupChecklist"] = {};
			data[questionID]["clientGroupChecklist"]["clientGroupChecklistID"] = clientGroupChecklistID;
			clientGroupChecklistAnswer = this.save(entity=clientGroupChecklistAnswer, data=data[questionID]);
			// If the clientGroupChecklistAnswer has no errors then we can make necessary custom updates
			if(!clientGroupChecklistAnswer.hasErrors()) {
				arrayAppend(clientGroupChecklistAnswerArray,clientGroupChecklistAnswer);	
			}
		}
		
		clientGroupChecklistAnswer.getClientGroupChecklist().setModifiedDateTime(now());
		
		// delete all unrelated answers		
		for(var answer in clientGroupChecklistAnswerArray) {
			deleteUnRelatedAnswers(answer);	
		}

		ormflush();
				
		return [];
	}

	public void function deleteUnRelatedAnswers(required any clientGroupChecklistAnswer, any questionAnswers) {
		if(!structKeyExists(arguments,"questionAnswers")){
			arguments.questionAnswers = arguments.clientGroupChecklistAnswer.getQuestion().getQuestionAnswers();
		}
		// loop thorugh all the answers of this question
		for(var questionAnswer in questionAnswers) {
			// loop through all the related questions of all the answers other than the one selected
			if(arguments.clientGroupChecklistAnswer.getQuestion().getQuestionID() != questionAnswer.getQuestion().getQuestionID() || listFindNoCase(arguments.clientGroupChecklistAnswer.getAnswerValue(),questionAnswer.getAnswerValue()) == 0) {
				var dependentQuestions = questionAnswer.getDependentQuestions();
				for(var dependentQuestion in dependentQuestions) {
					// recurse through dependent questions
					if(arrayLen(dependentQuestion.getQuestionAnswers())) {
						deleteUnRelatedAnswers(arguments.clientGroupChecklistAnswer,dependentQuestion.getQuestionAnswers());
					}
					// loop thorugh all the answers
					var clientGroupChecklistAnswersRelatedSmartList = dependentQuestion.getClientGroupChecklistAnswersSmartList();
					clientGroupChecklistAnswersRelatedSmartList.addFilter("clientGroupChecklist_clientGroupChecklistID",arguments.clientGroupChecklistAnswer.getClientGroupChecklist().getClientGroupChecklistID());
					var clientGroupChecklistAnswersRelated = clientGroupChecklistAnswersRelatedSmartList.getRecords();
					for(var clientGroupChecklistAnswerRelated IN clientGroupChecklistAnswersRelated) {
						// delete the non related answer
						this.delete(entity=clientGroupChecklistAnswerRelated);
						//getPlanDAO().deleteClientGroupChecklistAnswerQry(clientGroupChecklistAnswerRelated.getClientGroupChecklistAnswerID());
					}
				}
			}
		}
		
	}
	
	public string function validatePlanDocumentChecklistSectionLoopingCode(required any entity) {
		var loopingCode = "";
		if(!isNull(arguments.entity.getPlanDocumentChecklistSectionDescription())) {
			loopingCode = getHibachiUtilityService().findLoopingCode(arguments.entity.getPlanDocumentChecklistSectionDescription(), arguments.entity.getPlanDocumentTemplate().getChecklist());
		}
		return loopingCode;
	}
	
	public any function flagClientGroupChecklistQuestion(required any clientGroupChecklistID, string questionID = "", string context = "add") {
		var clientGroupChecklist = this.getClientGroupChecklist( arguments.clientGroupChecklistID );
		var flaggedQuestionIDs = isNull(clientGroupChecklist.getFlaggedQuestionIDs())?"":clientGroupChecklist.getFlaggedQuestionIDs();
		if(arguments.context == "remove") {
			if(arguments.questionID != "") {
				var position = listFindNoCase(flaggedQuestionIDs, arguments.questionID);
				if(position) {
					clientGroupChecklist.setFlaggedQuestionIDs( listDeleteAt(flaggedQuestionIDs, position) );
				}
			} else {
				clientGroupChecklist.setFlaggedQuestionIDs("");
			}
		} else if(arguments.context == "add") {
			if(arguments.questionID != "" && !listFindNoCase(flaggedQuestionIDs, arguments.questionID)) {
				clientGroupChecklist.setFlaggedQuestionIDs( listAppend(flaggedQuestionIDs, arguments.questionID) );
			}			
		}
		
	}
	
	public any function getChecklistQuestionByQuestionCode(required any questionCode, required any checklistID) {
		return getPlanDAO().getChecklistQuestionByQuestionCode(questionCode,checklistID);
	}
	
	public any function exportTrackedAnswer() {
		var exportQry = getPlanDAO().getTrackedAnswerExportQuery();
			
		export(data=exportQry);
	}
	
	// ====================== START: Save Overrides ===========================
	
	
	public any function saveClientGroupChecklist(required any clientGroupChecklist, required any data) {
		var wasApproved = arguments.clientGroupChecklist.getApprovedFlag();
		
		super.save(arguments.clientGroupChecklist, arguments.data);
		
		if(!arguments.clientGroupChecklist.hasErrors() && !wasApproved && arguments.clientGroupChecklist.getApprovedFlag()) {
			getEmailService().sendEmail('checklistApproval',arguments.clientGroupChecklist.getCreatedByAccount().getEmailAddress(), arguments.clientGroupChecklist.getClientGroup().getClient().getClientID());
		}
		
        return arguments.clientGroupChecklist;
	}
	
	
	// ======================  END: Save Overrides ============================
	
}
