component displayname="Client Checklist Answer" entityname="PhiaPlanClientGroupChecklistAnswer" table="ClientGroupChecklistAnswer" persistent="true" accessors="true" output="false" extends="HibachiEntity" hb_serviceName="planService" hb_permission="this" {
	
	// Persistent Properties
	property name="clientGroupChecklistAnswerID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="answerValue" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="question" cfc="Question" fieldtype="many-to-one" fkcolumn="questionID";	
	property name="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="many-to-one" fkcolumn="clientGroupChecklistID";	
	
	// Related Object Properties (One-To-Many)

	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Question (many-to-one)    
	public void function setQuestion(required any question) {    
		variables.question = arguments.question;    
		if(isNew() or !arguments.question.hasClientGroupChecklistAnswer( this )) {    
			arrayAppend(arguments.question.getClientGroupChecklistAnswers(), this);    
		}    
	}    
	public void function removeQuestion(any question) {    
		if(!structKeyExists(arguments, "question")) {    
			arguments.question = variables.question;    
		}    
		var index = arrayFind(arguments.question.getClientGroupChecklistAnswers(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.question.getClientGroupChecklistAnswers(), index);    
		}    
		structDelete(variables, "question");    
	}
	
	// ClientGroup Checklist (many-to-one)    
	public void function setClientGroupChecklist(required any clientGroupChecklist) {    
		variables.clientGroupChecklist = arguments.clientGroupChecklist;    
		if(isNew() or !arguments.clientGroupChecklist.hasClientGroupChecklistAnswer( this )) {    
			arrayAppend(arguments.clientGroupChecklist.getClientGroupChecklistAnswers(), this);    
		}    
	}    
	public void function removeClientGroupChecklist(any clientGroupChecklist) {    
		if(!structKeyExists(arguments, "clientGroupChecklist")) {    
			arguments.clientGroupChecklist = variables.clientGroupChecklist;    
		}    
		var index = arrayFind(arguments.clientGroupChecklist.getClientGroupChecklistAnswers(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.clientGroupChecklist.getClientGroupChecklistAnswers(), index);    
		}    
		structDelete(variables, "clientGroupChecklist");    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		return variables.answerLabel;
	}

	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
