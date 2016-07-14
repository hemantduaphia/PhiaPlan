component entityname="PhiaPlanClientGroupChecklist" table="ClientGroupChecklist" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="PlanService" hb_permission="this" {
	
	// Persistent Properties
	property name="clientGroupChecklistID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="clientGroupChecklistName" ormtype="string";
	property name="approvedFlag" ormtype="boolean" default="0";
	property name="flaggedQuestionIDs" ormtype="string" length="4000" ;
	
	// Related Object Properties (many-to-one)
	property name="checklist" cfc="Checklist" fieldtype="many-to-one" fkcolumn="checklistID";
	property name="planDocumentTemplate" cfc="PlanDocumentTemplate" fieldtype="many-to-one" fkcolumn="planDocumentTemplateID";
	property name="clientGroup" cfc="ClientGroup" fieldtype="many-to-one" fkcolumn="clientGroupID";
	property name="checklistStatus" cfc="Type" fieldtype="many-to-one" fkcolumn="checklistStatusID" hb_optionsSmartListData="f:parentType.systemCode=CGCStatus";
	
	// Related Object Properties (one-to-many)
	property name="clientGroupChecklistAnswers" singularname="clientGroupChecklistAnswer" cfc="ClientGroupChecklistAnswer" fieldtype="one-to-many" type="array" fkcolumn="clientGroupChecklistID" cascade="all-delete-orphan" inverse="true";
	property name="clientGroupChecklistDisclaimerAcceptances" singularname="clientGroupChecklistDisclaimerAcceptance" cfc="ClientGroupChecklistDisclaimerAcceptance" fieldtype="one-to-many" type="array" fkcolumn="clientGroupChecklistID" cascade="all-delete-orphan" inverse="true";
	property name="commentRelationships" singularname="commentRelationship" cfc="CommentRelationship" fieldtype="one-to-many" type="array" fkcolumn="clientGroupChecklistID" cascade="all-delete-orphan" inverse="true";
	 
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
		
	// Non Persistent
	property name="checklistLimitReachedFlag"; 
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getChecklistOptions() {
		if(!structKeyExists(variables, "checklistOptions")) {
			var smartList = getService("planService").getChecklistSmartList();
			smartList.addSelect(propertyIdentifier="checklistName", alias="name");
			smartList.addSelect(propertyIdentifier="checklistID", alias="value");
			smartList.addFilter(propertyIdentifier="activeFlag", value="1"); 
			smartList.addFilter(propertyIdentifier="client.clientID", value="#request.context.client.getClientID()#"); 
			variables.checklistOptions = smartList.getRecords();
		}
		return variables.checklistOptions;
    }
   
	public array function getPlanDocumentTemplateOptions() {
		if(!structKeyExists(variables, "planDocumentTemplateOptions")) {
			var smartList = getService("planService").getPlanDocumentTemplateSmartList();
			smartList.addSelect(propertyIdentifier="planDocumentTemplateName", alias="name");
			smartList.addSelect(propertyIdentifier="planDocumentTemplateID", alias="value");
			smartList.addFilter(propertyIdentifier="activeFlag", value="1"); 
			smartList.addFilter(propertyIdentifier="client.clientID", value="#request.context.client.getClientID()#"); 
			variables.planDocumentTemplateOptions = smartList.getRecords();
		}
		return variables.planDocumentTemplateOptions;
    }
    
    public array function getDisclaimerAcceptanceByAccount( required any account ) {
		var smartList = getService("planService").getClientGroupChecklistDisclaimerAcceptanceSmartList();
		smartList.addFilter(propertyIdentifier="clientGroupChecklist.clientGroupChecklistID", value="#getClientGroupChecklistID()#"); 
		smartList.addFilter(propertyIdentifier="createdByAccount.accountID", value="#arguments.account.getAccountID()#"); 
		return smartList.getRecords();
    }
   
    public boolean function getDisclaimerAcceptedByLoggedInAccountFlag( ) {
		var smartList = getService("planService").getClientGroupChecklistDisclaimerAcceptanceSmartList();
		smartList.addFilter(propertyIdentifier="clientGroupChecklist.clientGroupChecklistID", value="#getClientGroupChecklistID()#"); 
		smartList.addFilter(propertyIdentifier="createdByAccount.accountID", value="#getHibachiScope().getAccount().getAccountID()#"); 
		return smartList.getRecordsCount() GT 0;
    }
    
    public boolean function getChecklistLimitReachedFlag() {
    	return variables.planDocumentTemplate.getChecklistLimitReachedFlag();
    }
   
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// checklist (many-to-one)
	public void function setChecklist(required any checklist) {    
		variables.checklist = arguments.checklist;
		if(isNew() or !arguments.checklist.hasClientGroupChecklist( this )) {
			arrayAppend(arguments.checklist.getClientGroupChecklists(), this);
		}
	}
	public void function removeChecklist(any checklist) {    
		if(!structKeyExists(arguments, "checklist")) {    
			arguments.checklist = variables.checklist;    
		}    
		var index = arrayFind(arguments.checklist.getClientGroupChecklists(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.checklist.getClientGroupChecklists(), index);    
		}    
		structDelete(variables, "checklist");    
	}
    
	// planDocumentTemplate (many-to-one)
	public void function setPlanDocumentTemplate(required any planDocumentTemplate) {    
		variables.planDocumentTemplate = arguments.planDocumentTemplate;
		if(isNew() or !arguments.planDocumentTemplate.hasClientGroupChecklist( this )) {
			arrayAppend(arguments.planDocumentTemplate.getClientGroupChecklists(), this);
		}
	}
	public void function removePlanDocumentTemplate(any planDocumentTemplate) {    
		if(!structKeyExists(arguments, "planDocumentTemplate")) {    
			arguments.planDocumentTemplate = variables.planDocumentTemplate;    
		}    
		var index = arrayFind(arguments.planDocumentTemplate.getClientGroupChecklists(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.planDocumentTemplate.getClientGroupChecklists(), index);    
		}    
		structDelete(variables, "planDocumentTemplate");    
	}
    
	// ClientGroup (many-to-one)
	public void function setCilentGroup(required any clientGroup) {    
		variables.clientGroup = arguments.clientGroup;
		if(isNew() or !arguments.clientGroup.hasClientGroupChecklist( this )) {
			arrayAppend(arguments.clientGroup.getClientGroupChecklists(), this);
		}
	}
	public void function removeClientGroup(any clientGroup) {    
		if(!structKeyExists(arguments, "clientGroup")) {    
			arguments.clientGroup = variables.clientGroup;    
		}    
		var index = arrayFind(arguments.clientGroup.getClientGroupChecklists(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.clientGroup.getClientGroupChecklists(), index);    
		}    
		structDelete(variables, "clientGroup");    
	}
    
	// ClientGroupChecklistAnswer (one-to-many)    
	public void function addClientGroupChecklistAnswers(required any clientGroupChecklistAnswer) {    
		arguments.clientGroupChecklistAnswer.setClientGroupChecklist( this );    
	}    
	public void function removeClientGroupChecklistAnswer(required any clientGroupChecklistAnswer) {    
		arguments.clientGroupChecklistAnswer.removeClientGroupChecklist( this );    
	}
	
	// ClientGroupChecklistAnswer (one-to-many)    
	public void function addClientGroupChecklistDisclaimerAcceptances(required any clientGroupChecklistDisclaimerAcceptance) {    
		arguments.clientGroupChecklistDisclaimerAcceptance.setClientGroupChecklist( this );    
	}    
	public void function removeClientGroupChecklistDisclaimerAcceptance(required any clientGroupChecklistDisclaimerAcceptance) {    
		arguments.clientGroupChecklistDisclaimerAcceptance.removeClientGroupChecklist( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
