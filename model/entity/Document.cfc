component displayname="Document" entityname="PhiaPlanDocument" table="Document" persistent="true" extends="HibachiEntity" hb_serviceName="hibachiService" hb_permission="this" {
			
	// Persistent Properties
	property name="documentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="documentName" ormtype="string";
	property name="documentDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="documentFile" ormtype="string" hb_formFieldType="file" hb_fileUpload="true" hb_fileAcceptMIMEType="image/gif,image/jpeg,image/pjpeg,image/png,image/x-png,application/pdf,application/msword,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" hb_fileAcceptExtension=".jpeg,.jpg,.png,.gif,.pdf,.doc,.docx,.xls,.xlsx";
	property name="directory" ormtype="string";
	
	// Related entity properties (many-to-one)
	property name="documentType" cfc="Type" fieldtype="many-to-one" fkcolumn="documentTypeID" hb_optionsSmartListData="f:parentType.systemCode=documentType";
	
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID";
	property name="clientGroup" cfc="ClientGroup" fieldtype="many-to-one" fkcolumn="clientGroupID";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	public string function getDocumentFileUploadDirectory() {
		return expandPath("/") & "assets/documents";
	}
	
	public string function getDocumentExtension() {
		return listLast(getDocumentFile(), ".");
	}
	
	public string function getDocumentPath() {
		return "#getApplicationValue('baseURL')#/assets/documents/#getDocumentFile()#";
	}
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Client (many-to-one)
	public void function setClient(required any client) {
		variables.client = arguments.client;
		if(isNew() or !arguments.client.hasDocument( this )) {
			arrayAppend(arguments.client.getDocuments(), this);
		}
	}
	public void function removeClient(any client) {
		if(!structKeyExists(arguments, "client")) {
			arguments.client = variables.client;
		}
		var index = arrayFind(arguments.client.getDocuments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.client.getDocuments(), index);
		}
		structDelete(variables, "client");
	}
	
	// ClientGroup (many-to-one)
	public void function setClientGroup(required any clientGroup) {
		variables.clientGroup = arguments.clientGroup;
		if(isNew() or !arguments.clientGroup.hasDocument( this )) {
			arrayAppend(arguments.clientGroup.getDocuments(), this);
		}
	}
	public void function removeClientGroup(any clientGroup) {
		if(!structKeyExists(arguments, "clientGroup")) {
			arguments.clientGroup = variables.clientGroup;
		}
		var index = arrayFind(arguments.clientGroup.getDocuments(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.clientGroup.getDocuments(), index);
		}
		structDelete(variables, "clientGroup");
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}