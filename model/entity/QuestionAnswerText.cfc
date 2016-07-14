component displayname="Question Answer Text" entityname="PhiaPlanQuestionAnswerText" table="QuestionAnswerText" persistent="true" accessors="true" output="false" extends="HibachiEntity" hb_serviceName="planService" hb_property="questionAnswer.questionAnswerTexts" {
	
	// Persistent Properties
	property name="questionAnswerTextID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="answerText" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="sortOrder" ormtype="integer" sortContext="questionAnswer";
	property name="extension" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="questionAnswer" cfc="QuestionAnswer" fieldtype="many-to-one" fkcolumn="questionAnswerID";	
	
	// Related Object Properties (One-To-Many)

	// Related Entities (many-to-many - owner)

	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="shortAnswerText" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getShortAnswerText() {
		return left(getService("hibachiUtilityService").stripHTML(variables.answerText),500);
	}

	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Question (many-to-one)    
	public void function setQuestionAnswer(required any questionAnswer) {    
		variables.questionAnswer = arguments.questionAnswer;    
		if(isNew() or !arguments.questionAnswer.hasQuestionAnswerText( this )) {    
			arrayAppend(arguments.questionAnswer.getQuestionAnswerTexts(), this);    
		}    
	}    
	public void function removeQuestionAnswer(any questionAnswer) {    
		if(!structKeyExists(arguments, "questionAnswer")) {    
			arguments.questionAnswer = variables.questionAnswer;    
		}    
		var index = arrayFind(arguments.questionAnswer.getQuestionAnswerTexts(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.questionAnswer.getQuestionAnswerTexts(), index);    
		}    
		structDelete(variables, "questionAnswer");    
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		return "Answer Text - " & variables.sortorder;
	}

	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
