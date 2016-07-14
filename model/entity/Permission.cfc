component entityname="PhiaPlanPermission" table="Permission" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="permissionGroup.permissions" {
	
	// Persistent Properties
	property name="permissionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accessType" ormtype="string";
	property name="subsystem" ormtype="string";
	property name="section" ormtype="string";
	property name="item" ormtype="string";
	property name="allowActionFlag" ormtype="boolean";
	property name="allowCreateFlag" ormtype="boolean";
	property name="allowReadFlag" ormtype="boolean";
	property name="allowUpdateFlag" ormtype="boolean";
	property name="allowDeleteFlag" ormtype="boolean";
	property name="allowProcessFlag" ormtype="boolean";
	property name="entityClassName" ormtype="string";
	property name="propertyName" ormtype="string";
	property name="processContext" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="permissionGroup" cfc="PermissionGroup" fieldtype="many-to-one" fkcolumn="permissionGroupID";
	
	// Related Object Properties (one-to-many)
	
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
	
	// Permission Group (many-to-one)    
	public void function setPermissionGroup(required any permissionGroup) {    
		variables.permissionGroup = arguments.permissionGroup;    
		if(isNew() or !arguments.permissionGroup.hasPermission( this )) {    
			arrayAppend(arguments.permissionGroup.getPermissions(), this);    
		}    
	}    
	public void function removePermissionGroup(any permissionGroup) {    
		if(!structKeyExists(arguments, "permissionGroup")) {    
			arguments.permissionGroup = variables.permissionGroup;    
		}    
		var index = arrayFind(arguments.permissionGroup.getPermissions(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.permissionGroup.getPermissions(), index);    
		}    
		structDelete(variables, "permissionGroup");    
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