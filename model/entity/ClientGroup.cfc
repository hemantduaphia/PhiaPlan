component entityname="PhiaPlanClientGroup" table="ClientGroup" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="this" {
	
	// Persistent Properties
	property name="clientGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="clientGroupName" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID";
	
	// Related Object Properties (one-to-many)
	property name="clientGroupChecklists" singularname="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="one-to-many" type="array" fkcolumn="clientGroupID" cascade="all-delete-orphan" inverse="true";
	property name="documents" singularname="document" cfc="Document" type="array" fieldtype="one-to-many" fkcolumn="clientGroupID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	public any function init() {
		
		return super.init();
	}

	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Client (many-to-one)    
	public void function setClient(required any client) {    
		variables.client = arguments.client;    
		if(isNew() or !arguments.client.hasClientGroup( this )) {    
			arrayAppend(arguments.client.getClientGroups(), this);    
		}    
	}    
	public void function removeClient(any client) {    
		if(!structKeyExists(arguments, "client")) {    
			arguments.client = variables.client;    
		}    
		var index = arrayFind(arguments.client.getClientGroups(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.client.getClientGroups(), index);    
		}    
		structDelete(variables, "client");    
	}
	
	// ClientGroup Checklists (one-to-many)    
	public void function addClientGroupChecklists(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.setClientGroup( this );    
	}    
	public void function removeClientGroupChecklist(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.removeClientGroup( this );    
	}
	
	// Documents (one-to-many)    
	public void function addDocument(required any document) {    
		arguments.document.setClientGroup( this );    
	}    
	public void function removeDocument(required any document) {    
		arguments.document.removeClientGroup( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}