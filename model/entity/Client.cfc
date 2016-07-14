component entityname="PhiaPlanClient" table="Client" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="this" {
	
	// Persistent Properties
	property name="clientID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="clientName" ormtype="string";
	property name="logo" ormtype="string" hb_formFieldType="file" hb_fileUpload="true" hb_fileAcceptMIMEType="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png" hb_fileAcceptExtension=".jpeg,.jpg,.png,.gif";
	property name="dashboardCopy" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="allowDownloadWithoutApprovalFlag" ormtype="boolean" ;
	property name="allowDownloadFlag" ormtype="boolean" ;
	property name="defaultFont" ormtype="string" hb_formFieldType="select";
	property name="defaultFontSize" ormtype="string" hb_formFieldType="select";
	property name="disableCommentFlag" ormtype="boolean" ;
		
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="clientGroups" singularname="clientGroup" cfc="ClientGroup" type="array" fieldtype="one-to-many" fkcolumn="clientID" cascade="all-delete-orphan" inverse="true";
	property name="accounts" singularname="account" cfc="Account" type="array" fieldtype="one-to-many" fkcolumn="clientID" cascade="all-delete-orphan" inverse="true";
	property name="checklists" singularname="checklist" cfc="Checklist" type="array" fieldtype="one-to-many" fkcolumn="clientID" cascade="all-delete-orphan" inverse="true";
	property name="planDocumentTemplates" singularname="planDocumentTemplate" cfc="PlanDocumentTemplate" type="array" fieldtype="one-to-many" fkcolumn="clientID" cascade="all-delete-orphan" inverse="true";
	property name="documents" singularname="document" cfc="Document" type="array" fieldtype="one-to-many" fkcolumn="clientID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="emailTemplates" singularname="emailTemplate" cfc="EmailTemplate" type="array" fieldtype="many-to-many" linktable="ClientEmailTemplate" fkcolumn="clientID" inversejoincolumn="emailTemplateID" inverse="true" cascade="all";

	// Related Object Properties (many-to-many - inverse)
	
	// Remote Properties
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	
	public array function getDefaultFontOptions() {
		return [
			{name="Arial", value="Arial"},
			{name="Times New Roman", value="Times New Roman"},
			{name="Courier New", value="Courier New"}
		];
	}

	public array function getDefaultFontSizeOptions() {
		return [
			{name="10", value="10"},
			{name="11", value="11"},
			{name="12", value="12"}
		];
	}

	public string function getLogoUploadDirectory() {
		return expandPath("/") & "assets/logo";
	}
	
	public any function getTotalClientGroupChecklists() {
		var clientGroupChecklistSmartList = getService("planService").getClientGroupChecklistSmartList();
		clientGroupChecklistSmartList.addFilter("clientGroup.client.clientID", this.getClientID());
		return clientGroupChecklistSmartList.getRecordscount();
	}
	
	public any function getTotalComments() {
		var commentRelationshipSmartList = getService("planService").getCommentRelationshipSmartList();
		commentRelationshipSmartList.addFilter("clientGroupChecklist.clientGroup.client.clientID", this.getClientID());
		return commentRelationshipSmartList.getRecordscount();
	}
	
	public any function getTotalFlaggedQuestions() {
		var flaggedQuestionSmartList = getService("planService").getViewClientGroupChecklistFlaggedQuestionSmartList();
		flaggedQuestionSmartList.addFilter("clientID", this.getClientID());
		return flaggedQuestionSmartList.getRecordscount();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// ClientGroups (one-to-many)    
	public void function addClientGroup(required any clientGroup) {    
		arguments.clientGroup.setClient( this );    
	}    
	public void function removeClientGroup(required any clientGroup) {    
		arguments.clientGroup.removeClient( this );    
	}
	
	// Accounts (one-to-many - inverse)
	public void function addAccount(required any account) {
		arguments.account.addClient( this );
	}
	public void function removeAccount(required any account) {
		arguments.account.removeClient( this );
	}
	
	// Checklist (one-to-many)    
	public void function addChecklist(required any checklist) {    
		arguments.checklist.setClient( this );    
	}    
	public void function removeChecklist(required any checklist) {    
		arguments.checklist.removeClient( this );    
	}
	
	// PlanDocumentTemplate (one-to-many)    
	public void function addPlanDocumentTemplate(required any planDocumentTemplate) {    
		arguments.planDocumentTemplate.setClient( this );    
	}    
	public void function removePlanDocumentTemplate(required any planDocumentTemplate) {    
		arguments.planDocumentTemplate.removeClient( this );    
	}
	
	// Documents (one-to-many)    
	public void function addDocument(required any document) {    
		arguments.document.setClient( this );    
	}    
	public void function removeDocument(required any document) {    
		arguments.document.removeClient( this );    
	}
	
	// emailTemplates (many-to-many - inverse)
	public void function addEmailTemplate(required any emailTemplate) {
		arguments.emailTemplate.addClient( this );
	}
	public void function removeEmailTemplate(required any emailTemplate) {
		arguments.emailTemplate.removeClient( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
}
