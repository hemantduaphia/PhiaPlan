component displayname="Question Answer" entityname="PhiaPlanQuestionAnswer" table="QuestionAnswer" persistent="true" accessors="true" output="false" extends="HibachiEntity" hb_serviceName="planService" hb_property="question.questionAnswers" {
	
	// Persistent Properties
	property name="questionAnswerID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="answerCode" ormtype="string";
	property name="answerValue" ormtype="string";
	property name="answerLabel" ormtype="string" length="4000" hb_formFieldType="textarea";
	property name="answerHint" ormtype="string" length="4000" hb_formFieldType="textarea";
	property name="planLanguage" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="answerPopulateText" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="sortOrder" ormtype="integer" sortContext="question";
	
	// Related Object Properties (Many-To-One)
	property name="question" cfc="Question" fieldtype="many-to-one" fkcolumn="questionID";	
	
	// Related Object Properties (One-To-Many)
	property name="questionAnswerTexts" singularname="questionAnswerText" cfc="QuestionAnswerText" fieldtype="one-to-many" fkcolumn="questionAnswerID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";

	// Related Entities (many-to-many - owner)
	property name="excludedQuestions" singularname="excludedQuestion" cfc="Question" type="array" fieldtype="many-to-many" linktable="QuestionAnswerExcludedQuestion" fkcolumn="questionAnswerID" inversejoincolumn="questionID" cascade="all";
	property name="excludedChecklistSections" singularname="excludedChecklistSection" cfc="ChecklistSection" type="array" fieldtype="many-to-many" linktable="QuestionAnswerExcludedChecklistSection" fkcolumn="questionAnswerID" inversejoincolumn="checklistSectionID" cascade="all";

	// Related Entities (many-to-many - inverse)
	property name="dependentQuestions" singularname="dependentQuestion" cfc="Question" type="array" fieldtype="many-to-many" linktable="QuestionAnswerDependentQuestion" fkcolumn="questionAnswerID" inversejoincolumn="questionID" inverse="true" cascade="all";
	property name="dependentChecklistSections" singularname="dependentChecklistSection" cfc="ChecklistSection" type="array" fieldtype="many-to-many" linktable="QuestionAnswerDependentChecklistSection" fkcolumn="questionAnswerID" inversejoincolumn="checklistSectionID" inverse="true" cascade="all";

	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	property name="extendedSimpleRepresentation" persistent="false" ;	
	
	
	public string function getAnswerLabel() {
		if(structkeyExists(variables,"answerLabel")) {
			return variables["answerLabel"];
		} else {
			return htmlEditFormat( getAnswerValue() );
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================

	public string function getExtendedSimpleRepresentation() {
		return variables.question.getChecklistSection().getChecklistSectionName() & " - " & variables.question.getQuestionCode() & " : " & variables.question.getQuestionText() & " - " & variables.answerLabel;
	}

	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Question (many-to-one)    
	public void function setQuestion(required any question) {    
		variables.question = arguments.question;    
		if(isNew() or !arguments.question.hasQuestionAnswer( this )) {    
			arrayAppend(arguments.question.getQuestionAnswers(), this);    
		}    
	}    
	public void function removeQuestion(any question) {    
		if(!structKeyExists(arguments, "question")) {    
			arguments.question = variables.question;    
		}    
		var index = arrayFind(arguments.question.getQuestionAnswers(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.question.getQuestionAnswers(), index);    
		}    
		structDelete(variables, "question");    
	}
	
	// Question Answer Texts (one-to-many)    
	public void function addQuestionAnswerText(required any questionAnswerText) {    
		arguments.questionAnswerText.setQuestionAnswer( this );    
	}    
	public void function removeQuestionAnswerText(required any questionAnswerText) {    
		arguments.questionAnswerText.removeQuestionAnswer( this );    
	}

	// question dependency (many-to-many - inverse)
	public void function addDependentQuestion(required any dependentQuestion) {
		arguments.dependentQuestion.addQuestionAnswerDependency( this );
	}
	public void function removeDependentQuestion(required any dependentQuestion) {
		arguments.dependentQuestion.removeQuestionAnswerDependency( this );
	}
	
	// Checklist section dependency (many-to-many - inverse)
	public void function addDependentChecklistSection(required any dependentChecklistSection) {
		arguments.dependentChecklistSection.addQuestionAnswerDependency( this );
	}
	public void function removeDependentChecklistSection(required any dependentChecklistSection) {
		arguments.dependentChecklistSection.removeQuestionAnswerDependency( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		return variables.question.getQuestionText() & " - " & variables.answerLabel;
	}

	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
