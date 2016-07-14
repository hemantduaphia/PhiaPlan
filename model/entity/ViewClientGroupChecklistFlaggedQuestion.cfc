component entityname="PhiaPlanViewClientGroupChecklistFlaggedQuestion" table="ViewClientGroupChecklistFlaggedQuestion" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="PlanService" hb_permission="this" {
	
	// Persistent Properties
	property name="ID" ormtype="string" length="32" fieldtype="id" generator="assigned";
	property name="clientGroupChecklistID" ormtype="string";
	property name="clientGroupChecklistName" ormtype="string";
	property name="approvedFlag" ormtype="boolean" default="0";
	property name="flaggedQuestionIDs" ormtype="string" length="4000" ;
	property name="clientGroupID" ormtype="string";
	property name="clientGroupName" ormtype="string";
	property name="clientID" ormtype="string";
	property name="clientName" ormtype="string";
	property name="questionCode" ormtype="string";
	property name="questionText" ormtype="string";
	
	// Related Object Properties (many-to-one)

	// Related Object Properties (one-to-many)
	 
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
		
	// Non Persistent
	
	// ============ START: Non-Persistent Property Methods =================
   
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
