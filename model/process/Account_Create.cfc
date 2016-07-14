component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="account";
	property name="client";
	property name="permissionGroup";

	// Data Properties
	property name="firstName" hb_rbKey="entity.account.firstName";
	property name="lastName" hb_rbKey="entity.account.lastName";
	property name="company" hb_rbKey="entity.account.company";
	property name="phoneNumber";
	property name="emailAddress";
	property name="emailAddressConfirm";
	property name="createAuthenticationFlag" hb_sessionDefault="1";
	property name="password";
	property name="passwordConfirm";
	
	property name="clientID"; 
	property name="permissionGroupID";
	
	public boolean function getCreateAuthenticationFlag() {
		if(!structKeyExists(variables, "createAuthenticationFlag")) {
			variables.createAuthenticationFlag = true;
		}
		return variables.createAuthenticationFlag;
	}
	
	public any function getClient() {
		if(!structKeyExists(variables, "client") && !isNull(getClientID())) {
			variables.client = getService("PlanService").getClient(getClientID());
		}
		if(structKeyExists(variables, "client")) {
			return variables.client;
		}
	}
	
	public any function getPermissionGroup() {
		if(!structKeyExists(variables, "permissionGroup") && !isNull(getPermissionGroupID())) {
			variables.permissionGroup = getService("PlanService").getPermissionGroup(getPermissionGroupID());
		}
		if(structKeyExists(variables, "permissionGroup")) {
			return variables.permissionGroup;
		}
	}
	
}