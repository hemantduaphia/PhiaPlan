component entityname="PhiaPlanAccount" table="Account" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="accountService" hb_permission="this" {
	
	// Persistent Properties
	property name="accountID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="superUserFlag" ormtype="boolean";
	property name="firstName" ormtype="string";
	property name="lastName" ormtype="string";
	property name="company" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	property name="loginLockExpiresDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="failedLoginAttemptCount" hb_populateEnabled="false" ormtype="integer" hb_auditable="false"; 
	
	// Related Object Properties (many-to-one)
	property name="primaryEmailAddress" cfc="AccountEmailAddress" fieldtype="many-to-one" fkcolumn="primaryEmailAddressID";
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID" hb_optionsNullRBKey="define.select";
	
	// Related Object Properties (one-to-many)
	property name="accountAuthentications" singularname="accountAuthentication" cfc="AccountAuthentication" type="array" fieldtype="one-to-many" fkcolumn="accountID" cascade="all-delete-orphan" inverse="true";
	property name="accountEmailAddresses" singularname="accountEmailAddress" type="array" fieldtype="one-to-many" fkcolumn="accountID" cfc="AccountEmailAddress" cascade="all-delete-orphan" inverse="true";
	property name="clientGroupChecklistDisclaimerAcceptances" singularname="clientGroupChecklistDisclaimerAcceptance" type="array" fieldtype="one-to-many" fkcolumn="createdByAccountID" cfc="ClientGroupChecklistDisclaimerAcceptance" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="permissionGroups" singularname="permissionGroup" cfc="PermissionGroup" fieldtype="many-to-many" linktable="AccountPermissionGroup" fkcolumn="accountID" inversejoincolumn="permissionGroupID";
	property name="allowedClientGroupChecklists" singularname="allowedClientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="many-to-many" linktable="AllowedAccountClientGroupChecklist" fkcolumn="accountID" inversejoincolumn="clientGroupChecklistID";

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	property name="adminIcon" persistent="false";
	property name="adminAccountFlag" persistent="false" formatType="yesno";
	property name="emailAddress" persistent="false"; 
	property name="gravatarURL" persistent="false";
	property name="fullName" persistent="false";
	property name="passwordResetID" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getEmailAddress() {
		return getPrimaryEmailAddress().getEmailAddress();
	}
	
	public boolean function getAdminAccountFlag() {
		if(getSuperUserFlag() || arrayLen(variables.permissionGroups)) {
			return true;
		}
		return false;
	}
	
	public boolean function getSuperUserFlag() {
		if(isNull(variables.superUserFlag)) {
			variables.superUserFlag = false;
		}
		return variables.superUserFlag;
	}
	
	public string function getAdminIcon() {
		return '<img src="#getGravatarURL(55)#" style="width:55px;" />';
	}
	
	public string function getGravatarURL(numeric size=80) {
		if(cgi.server_port eq 443) {
			return "https://secure.gravatar.com/avatar/#lcase(hash(lcase(getEmailAddress()), "MD5" ))#?s=#arguments.size#";
		} else {
			return "http://www.gravatar.com/avatar/#lcase(hash(lcase(getEmailAddress()), "MD5" ))#?s=#arguments.size#";	
		}
	}
	
	public string function getFullName() {
		return "#getFirstName()# #getLastName()#";
	}
	
	public string function getallowedClientGroupChecklistIDs() {
		var IDs = "";
		for(var allowedClientGroupChecklist in variables.allowedClientGroupChecklists) {
			IDs = listAppend(IDs,allowedClientGroupChecklist.getClientGroupChecklistID());
		}
		return IDs;
	}
	
	public string function getPasswordResetID() {
		if(!structKeyExists(variables, "passwordResetID")) {
			variables.passwordResetID = getService("accountService").getPasswordResetID(account=this);
		}
		return variables.passwordResetID;
	}
	
	public array function getClientOptions() {
		if(!structKeyExists(variables, "clientOptions")) {
			var smartList = getService("planService").getClientSmartList();
			smartList.addSelect(propertyIdentifier="clientName", alias="name");
			smartList.addSelect(propertyIdentifier="clientID", alias="value");
			smartList.addOrder("clientName|ASC"); 
			variables.clientOptions = smartList.getRecords();
		}
		return variables.clientOptions;
    }
   
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Primary Email Address (many-to-one | circular)
	public void function setPrimaryEmailAddress(required any primaryEmailAddress) {    
		variables.primaryEmailAddress = arguments.primaryEmailAddress;
		arguments.primaryEmailAddress.setAccount( this );    
	}
	
	// Client (many-to-one)
	public void function setClient(required any client) {    
		variables.client = arguments.client;    
		if(isNew() or !arguments.client.hasAccount( this )) {    
			arrayAppend(arguments.client.getAccounts(), this);    
		}    
	}    
	public void function removeClient(any client) {    
		if(!structKeyExists(arguments, "client")) {    
			arguments.client = variables.client;    
		}    
		var index = arrayFind(arguments.client.getAccounts(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.client.getAccounts(), index);    
		}    
		structDelete(variables, "client");    
	}
	
	// Account Authentications (one-to-many)    
	public void function addAccountAuthentication(required any accountAuthentication) {    
		arguments.accountAuthentication.setAccount( this );    
	}    
	public void function removeAccountAuthentication(required any accountAuthentication) {    
		arguments.accountAuthentication.removeAccount( this );    
	}
	
	// Account Email Addresses (one-to-many)
	public void function addAccountEmailAddress(required any accountEmailAddress) {    
		arguments.accountEmailAddress.setAccount( this );    
	}    
	public void function removeAccountEmailAddress(required any accountEmailAddress) {    
		arguments.accountEmailAddress.removeAccount( this );    
	}
	
	// Account Checklist (one-to-many)
	public void function addAccountChecklist(required any accountChecklist) {    
		arguments.accountChecklist.setAccount( this );    
	}    
	public void function removeAccountChecklist(required any accountChecklist) {    
		arguments.accountChecklist.removeAccount( this );    
	}
	
	// Permission Groups (many-to-many - owner)
	public void function addPermissionGroup(required any permissionGroup) {
		if(arguments.permissionGroup.isNew() or !hasPermissionGroup(arguments.permissionGroup)) {
			arrayAppend(variables.permissionGroups, arguments.permissionGroup);
		}
		if(isNew() or !arguments.permissionGroup.hasAccount( this )) {
			arrayAppend(arguments.permissionGroup.getAccounts(), this);
		}
	}
	public void function removePermissionGroup(required any permissionGroup) {
		var thisIndex = arrayFind(variables.permissionGroups, arguments.permissionGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.permissionGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.permissionGroup.getAccounts(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.permissionGroup.getAccounts(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "fullName";
	}
	
	public any function getPrimaryEmailAddress() {
		if(!isNull(variables.primaryEmailAddress)) {
			return variables.primaryEmailAddress;
		} else if (arrayLen(getAccountEmailAddresses())) {
			return getAccountEmailAddresses()[1];
		} else {
			return getService("accountService").newAccountEmailAddress();
		}
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
