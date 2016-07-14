component displayname="PhiaPlanQuestion" entityname="PhiaPlanQuestion" table="Question" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="planService" {
	
	// Persistent Properties
	property name="questionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="questionText" ormtype="string";
	property name="questionCode" ormtype="string";
	property name="questionNumber" ormtype="string";
	property name="questionNumberLabel" ormtype="string";
	property name="questionHint" ormtype="string" length="4000" hb_formFieldType="textarea";
	property name="planLanguage" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="defaultAnswerValue" ormtype="string";
	property name="requiredFlag" ormtype="boolean" default="false";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="phiaApprovedFlag" ormtype="boolean" default="false";
	property name="clientApprovedFlag" ormtype="boolean" default="false";
	property name="trackAnswerFlag" ormtype="boolean" default="false";
	property name="sortOrder" ormtype="integer" sortContext="ChecklistSection";
	
	// Related Object Properties (Many-To-One)
	property name="checklistSection" cfc="ChecklistSection" fieldtype="many-to-one" fkcolumn="checklistSectionID" hb_optionsNullRBKey="define.select";
	property name="answerType" cfc="Type" fieldtype="many-to-one" fkcolumn="answerTypeID" hb_optionsSmartListData="f:parentType.systemCode=answerType";

	// Related Object Properties (One-To-Many)
	property name="questionAnswers" singularname="questionAnswer" cfc="QuestionAnswer" fieldtype="one-to-many" fkcolumn="questionID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	property name="clientGroupChecklistAnswers" singularname="clientGroupChecklistAnswer" cfc="ClientGroupChecklistAnswer" fieldtype="one-to-many" type="array" fkcolumn="questionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Entities (many-to-many - owner)
	property name="questionAnswerDependencies" singularname="questionAnswerDependency" cfc="QuestionAnswer" type="array" fieldtype="many-to-many" linktable="QuestionAnswerDependentQuestion" fkcolumn="questionID" inversejoincolumn="questionAnswerID" cascade="all";
	property name="questionAnswerExclusions" singularname="questionAnswerExclusion" cfc="QuestionAnswer" type="array" fieldtype="many-to-many" linktable="QuestionAnswerExcludedQuestion" fkcolumn="questionID" inversejoincolumn="questionAnswerID" inverse="true" cascade="all";

	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="answerTypeOptions" persistent="false";
	
	
	public array function getQuestionAnswers(string orderby, string sortType="text", string direction="asc") {
		if(!structKeyExists(arguments,"orderby")) {
			return variables.QuestionAnswers;
		} else {
			return getService("hibachiUtilityService").sortObjectArray(variables.QuestionAnswers,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}

    // ============ START: Non-Persistent Property Methods =================
	
	public array function getAnswerTypeOptions() {
		if(!structKeyExists(variables, "answerTypeOptions")) {
			var smartList = getService("planService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="answerType"); 
			smartList.addOrder("type|ASC");
			variables.answerTypeOptions = smartList.getRecords();
			arrayPrepend(variables.answerTypeOptions, {value="", name=rbKey('define.select')});
		}
		return variables.answerTypeOptions;
    }
   
	public array function getQuestionAnswersOptions() {
		if(!structKeyExists(variables, "questionAnswersOptions")) {
			var smartList = getService("planService").getQuestionAnswerSmartList();
			smartList.addSelect(propertyIdentifier="answerLabel", alias="name");
			smartList.addSelect(propertyIdentifier="answerValue", alias="value");
			smartList.addSelect(propertyIdentifier="questionAnswerID", alias="questionAnswerID"); 
			smartList.addSelect(propertyIdentifier="answerHint", alias="answerHint"); 
			smartList.addSelect(propertyIdentifier="sortOrder", alias="sortOrder"); 
			smartList.addFilter(propertyIdentifier="question_questionID", value="#variables.questionID#"); 
			smartList.addOrder("sortOrder|ASC");
			variables.questionAnswersOptions = smartList.getRecords();
			if(variables.answerType.getSystemCode() == "atSelect") {
				arrayPrepend(variables.questionAnswersOptions, {value="", name=rbKey('define.select')});
			}
		}
		return variables.questionAnswersOptions;
    }
   
	// ============  END:  Non-Persistent Property Methods =================
	
    // ============= START: Bidirectional Helper Methods ===================
    
	// Question Set (many-to-one)    
	public void function setChecklistSection(required any ChecklistSection) {    
		variables.ChecklistSection = arguments.ChecklistSection;
		if(isNew() or !arguments.ChecklistSection.hasQuestion( this )) {
			arrayAppend(arguments.ChecklistSection.getQuestions(), this);
		}
	}
	public void function removeChecklistSection(any ChecklistSection) {    
		if(!structKeyExists(arguments, "ChecklistSection")) {    
			arguments.ChecklistSection = variables.ChecklistSection;    
		}    
		var index = arrayFind(arguments.ChecklistSection.getQuestions(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.ChecklistSection.getQuestions(), index);    
		}    
		structDelete(variables, "ChecklistSection");    
	}
    
	// Question Answers (one-to-many)    
	public void function addQuestionAnswer(required any questionAnswer) {    
		arguments.questionAnswer.setQuestion( this );    
	}    
	public void function removeQuestionAnswer(required any questionAnswer) {    
		arguments.questionAnswer.removeQuestion( this );    
	}

	// ClientGroup Checklist Answers (one-to-many)    
	public void function addClientGroupChecklistAnswer(required any clientGroupChecklistAnswer) {    
		arguments.clientGroupChecklistAnswer.setQuestion( this );    
	}    
	public void function removeClientGroupChecklistAnswer(required any clientGroupChecklistAnswer) {    
		arguments.clientGroupChecklistAnswer.removeQuestion( this );    
	}

	// QuestionAnswerDependencies (many-to-many - owner)    
	public void function addQuestionAnswerDependency(required any questionAnswerDependency) {    
		if(arguments.questionAnswerDependency.isNew() or !hasQuestionAnswerDependency(arguments.questionAnswerDependency)) {    
			arrayAppend(variables.questionAnswerDependencies, arguments.questionAnswerDependency);    
		}    
		if(isNew() or !arguments.questionAnswerDependency.hasDependentQuestion( this )) {    
			arrayAppend(arguments.questionAnswerDependency.getDependentQuestions(), this);    
		}    
	}    
	public void function removeQuestionAnswerDependency(required any questionAnswerDependency) {    
		var thisIndex = arrayFind(variables.questionAnswerDependencies, arguments.questionAnswerDependency);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.questionAnswerDependencies, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.questionAnswerDependency.getDependentQuestions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.questionAnswerDependency.getDependentQuestions(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
		return "questionText";
	}

	public string function getSimpleRepresentation() {
		return getQuestionCode() & " : " & getQuestionText();
	}

	public any function getQuestionAnswersSmartlist() {
		return getPropertySmartList( "questionAnswers" );
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
