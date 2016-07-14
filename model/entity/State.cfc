component entityname="PhiaPlanState" table="State" persistent="true" extends="HibachiEntity" hb_serviceName="hibachiService" {
	
	// Persistent Properties
	property name="stateCode" length="40" ormtype="string" fieldtype="id";
	property name="countryCode" length="2" ormtype="string" fieldtype="id";
	
	property name="stateName" ormtype="string";
	
	// Related Object Properties
	property name="country" cfc="Country" fieldtype="many-to-one" fkcolumn="countryCode" insert="false" update="false";


	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
