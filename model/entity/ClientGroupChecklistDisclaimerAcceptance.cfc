component entityname="PhiaPlanClientGroupChecklistDisclaimerAcceptance" table="ClientGroupChecklistDisclaimerAcceptance" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="PlanService" hb_permission="this" {
	
	// Persistent Properties
	property name="clientGroupChecklistDisclaimerAcceptanceID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	
	// Related Object Properties (many-to-one)
	property name="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="many-to-one" fkcolumn="clientGroupChecklistID";	
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
		
	// Non Persistent
	
	// ============ START: Non-Persistent Property Methods =================
	
    public boolean function getDisclaimerNotAcceptedByLoggedInAccountFlag( ) {
		return !variables.clientGroupChecklist.getDisclaimerAcceptedByLoggedInAccountFlag();
    }
   
   
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
		
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return "";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
