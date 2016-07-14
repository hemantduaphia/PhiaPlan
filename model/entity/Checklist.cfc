component entityname="PhiaPlanChecklist" table="Checklist" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="planService" hb_permission="this" {
	
	// Persistent Properties
	property name="checklistID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="checklistName" ormtype="string";
	property name="checklistCode" ormtype="string";
	property name="checklistDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="activeFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID" hb_optionsNullRBKey="define.select";
	
	// Related Object Properties (one-to-many)
	property name="checklistSections" singularname="ChecklistSection" cfc="ChecklistSection" fieldtype="one-to-many" type="array" fkcolumn="checklistID" cascade="all-delete-orphan" inverse="true";
	property name="planDocumentTemplates" singularname="planDocumentTemplate" cfc="PlanDocumentTemplate" fieldtype="one-to-many" type="array" fkcolumn="checklistID" cascade="all-delete-orphan" inverse="true";
	property name="clientGroupChecklists" singularname="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="one-to-many" type="array" fkcolumn="checklistID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Client (many-to-one)    
	public void function setClient(required any client) {    
		variables.client = arguments.client;    
		if(isNew() or !arguments.client.hasChecklist( this )) {    
			arrayAppend(arguments.client.getChecklists(), this);    
		}    
	}    
	public void function removeClient(any client) {    
		if(!structKeyExists(arguments, "client")) {    
			arguments.client = variables.client;    
		}    
		var index = arrayFind(arguments.client.getChecklists(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.client.getChecklists(), index);    
		}    
		structDelete(variables, "client");    
	}
	
	// Sections (one-to-many)    
	public void function addChecklistSections(required any checklistSection) {    
		arguments.checklistSection.setChecklist( this );    
	}    
	public void function removeChecklistSection(required any checklistSection) {    
		arguments.checklistSection.removeChecklist( this );    
	}
	
	// PlanDocumentTemplate (one-to-many)    
	public void function addPlanDocumentTemplates(required any planDocumentTemplate) {    
		arguments.planDocumentTemplate.setChecklist( this );    
	}    
	public void function removePlanDocumentTemplate(required any planDocumentTemplate) {    
		arguments.planDocumentTemplate.removeChecklist( this );    
	}
	
	// ClientGroup Checklists (one-to-many)    
	public void function addClientGroupChecklists(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.setChecklist( this );    
	}    
	public void function removeClientGroupChecklist(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.removeChecklist( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
