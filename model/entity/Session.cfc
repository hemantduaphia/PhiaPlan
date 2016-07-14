component entityname="PhiaPlanSession" table="Session" persistent=true output=false accessors=true extends="HibachiEntity" hb_serviceName="hibachiSessionService" {
	
	// Persistent Properties
	property name="sessionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="lastRequestDateTime" ormtype="timestamp";
	property name="lastRequestIPAddress" ormtype="string";
	property name="userAgent" ormtype="string" length="4000" ;
	
	// Related Entities
	property name="account" type="any" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountAuthentication" cfc="AccountAuthentication" fieldtype="many-to-one" fkcolumn="accountAuthenticationID";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	
	// Non-Persistent Properties
	property name="requestAccount" type="any" persistent="false";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	public any function getAccount() {
		if(structKeyExists(variables, "account")) {
			return variables.account;
		} else if (!structKeyExists(variables, "requestAccount")) {
			variables.requestAccount = getService("accountService").newAccount();
		}
		return variables.requestAccount;
	}
	
	public void function removeAccount() {
		if(structKeyExists(variables, "account")) {
			structDelete(variables, "account");	
		}
	}
	
	public void function removeAccountAuthentication() {
		if(structKeyExists(variables, "accountAuthentication")) {
			structDelete(variables, "accountAuthentication");	
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}