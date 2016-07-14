component displayname="EmailTemplate" entityname="PhiaPlanEmailTemplate" table="EmailTemplate" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="hibachiService" hb_permission="this" {
	
	// Persistent Properties
	property name="emailTemplateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="emailTemplateName" ormtype="string";
	property name="emailTemplateCode" ormtype="string";
	property name="emailTo" ormtype="string";
	property name="emailFrom" ormtype="string";
	property name="emailCC" ormtype="string";
	property name="emailBCC" ormtype="string";
	property name="emailSubject" ormtype="string";
	property name="emailBodyHTML" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="emailBodyText" ormtype="string" length="4000" hb_formFieldType="textArea";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	property name="clients" singularname="client" cfc="Client" type="array" fieldtype="many-to-many" linktable="ClientEmailTemplate" fkcolumn="emailTemplateID" inversejoincolumn="clientID" cascade="all";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="isDefault" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getIsDefault() {
		return arrayLen(getClients()) EQ 0;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// clients (many-to-many - owner)    
	public void function addClient(required any client) {    
		if(arguments.client.isNew() or !hasClient(arguments.client)) {    
			arrayAppend(variables.clients, arguments.client);    
		}    
		if(isNew() or !arguments.client.hasEmailTemplate( this )) {    
			arrayAppend(arguments.client.getEmailTemplates(), this);    
		}    
	}    
	public void function removeClient(required any client) {    
		var thisIndex = arrayFind(variables.clients, arguments.client);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.clients, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.client.getEmailTemplates(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.client.getEmailTemplates(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public any function getEmailBodyHTML() {
		if(!structKeyExists(variables, "emailBodyHTML")) {
			variables.emailBodyHTML = "";
		}
		return variables.emailBodyHTML;
	}
	
	public any function getEmailBodyText() {
		if(!structKeyExists(variables, "emailBodyText")) {
			variables.emailBodyText = "";
		}
		return variables.emailBodyText;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
