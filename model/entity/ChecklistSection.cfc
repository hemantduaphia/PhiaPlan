component entityname="PhiaPlanChecklistSection" table="ChecklistSection" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="planService" hb_permission="this" {
	
	// Persistent Properties
	property name="checklistSectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="checklistSectionName" ormtype="string";
	property name="checklistSectionCode" ormtype="string";
	property name="checklistSectionDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="activeFlag" ormtype="boolean";
	property name="sortOrder" ormtype="int";
	
	// Related Object Properties (many-to-one)
	property name="checklist" cfc="Checklist" fieldtype="many-to-one" fkcolumn="checklistID" fetch="join" ;
	
	// Related Object Properties (one-to-many)
	property name="questions" singularname="question" cfc="Question" fieldtype="one-to-many" type="array" fkcolumn="checklistSectionID" cascade="all-delete-orphan" inverse="true";
	//property name="planDocumentChecklistSections" singularname="planDocumentChecklistSection" cfc="PlanDocumentChecklistSection" fieldtype="one-to-many" type="array" fkcolumn="checklistSectionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Entities (many-to-many - owner)
	property name="questionAnswerDependencies" singularname="questionAnswerDependency" cfc="QuestionAnswer" type="array" fieldtype="many-to-many" linktable="QuestionAnswerDependentChecklistSection" fkcolumn="checklistSectionID" inversejoincolumn="questionAnswerID";

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	
	public boolean function getAllQuestionClientApprovedFlag() {
		var allApproved = true;
		for (var question in getQuestions()) {
			if(isNull(question.getClientApprovedFlag()) || !question.getClientApprovedFlag()) {
				allApproved = false;
				break;
			}
		}
		
		return allApproved;
	}
	
	public boolean function getAllQuestionPhiaApprovedFlag() {
		var allApproved = true;
		for (var question in getQuestions()) {
			if(isNull(question.getPhiaApprovedFlag()) || !question.getPhiaApprovedFlag()) {
				allApproved = false;
				break;
			}
		}
		
		return allApproved;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Checklist (many-to-one)
	public void function setChecklist(required any Checklist) {    
		variables.Checklist = arguments.Checklist;    
		if(isNew() or !arguments.Checklist.hasChecklistSection( this )) {    
			arrayAppend(arguments.Checklist.getChecklistSections(), this);    
		}    
	}    
	public void function removeChecklist(any Checklist) {    
		if(!structKeyExists(arguments, "Checklist")) {    
			arguments.Checklist = variables.Checklist;    
		}    
		var index = arrayFind(arguments.Checklist.getChecklistSections(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.Checklist.getChecklistSections(), index);    
		}    
		structDelete(variables, "Checklist");    
	}
	
	
	// questions (one-to-many)    
	public void function addQuestions(required any question) {    
		arguments.question.setChecklistSection( this );    
	}    
	public void function removeQuestion(required any question) {    
		arguments.question.removeChecklistSection( this );    
	}
	
	// planDocumentChecklistSection (one-to-many)    
	/*
	public void function addPlanDocumentChecklistSections(required any planDocumentChecklistSection) {    
		arguments.planDocumentChecklistSection.setChecklistSection( this );    
	}    
	public void function removePlanDocumentChecklistSection(required any planDocumentChecklistSection) {    
		arguments.planDocumentChecklistSection.removeChecklistSection( this );    
	}
	*/
	// QuestionAnswerDependencies (many-to-many - owner)    
	public void function addQuestionAnswerDependency(required any questionAnswerDependency) {    
		if(arguments.questionAnswerDependency.isNew() or !hasQuestionAnswerDependency(arguments.questionAnswerDependency)) {    
			arrayAppend(variables.questionAnswerDependencies, arguments.questionAnswerDependency);    
		}    
		if(isNew() or !arguments.questionAnswerDependency.hasDependentChecklistSection( this )) {    
			arrayAppend(arguments.questionAnswerDependency.getDependentChecklistSections(), this);    
		}    
	}    
	public void function removeQuestionAnswerDependency(required any questionAnswerDependency) {    
		var thisIndex = arrayFind(variables.questionAnswerDependencies, arguments.questionAnswerDependency);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.questionAnswerDependencies, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.questionAnswerDependency.getDependentChecklistSections(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.questionAnswerDependency.getDependentChecklistSections(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
