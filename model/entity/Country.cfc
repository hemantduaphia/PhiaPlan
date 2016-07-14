component displayname="Country" entityname="PhiaPlanCountry" table="Country" persistent="true" extends="HibachiEntity" hb_serviceName="hibachiService" hb_permission="this" {
	
	// Persistent Properties
	property name="countryCode" length="2" ormtype="string" fieldtype="id";
	property name="countryName" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	
	property name="streetAddressLabel" ormtype="string";
	property name="streetAddressShowFlag" ormtype="boolean";
	property name="streetAddressRequiredFlag" ormtype="boolean";
	
	property name="street2AddressLabel" ormtype="string";
	property name="street2AddressShowFlag" ormtype="boolean";
	property name="street2AddressRequiredFlag" ormtype="boolean";
	
	property name="localityLabel" ormtype="string";
	property name="localityShowFlag" ormtype="boolean";
	property name="localityRequiredFlag" ormtype="boolean";
	
	property name="cityLabel" ormtype="string";
	property name="cityShowFlag" ormtype="boolean";
	property name="cityRequiredFlag" ormtype="boolean";
	
	property name="stateCodeLabel" ormtype="string";
	property name="stateCodeShowFlag" ormtype="boolean";
	property name="stateCodeRequiredFlag" ormtype="boolean";
	
	property name="postalCodeLabel" ormtype="string";
	property name="postalCodeShowFlag" ormtype="boolean";
	property name="postalCodeRequiredFlag" ormtype="boolean";
	
	// Non-Persistent Properties
	property name="stateCodeOptions" persistent="false" type="array";


	// ============ START: Non-Persistent Property Methods =================
	
	public array function getStateCodeOptions() {
		if(!structKeyExists(variables, "stateCodeOptions")) {
			var smartList = getService("addressService").getStateSmartList();
			smartList.addSelect(propertyIdentifier="stateName", alias="name");
			smartList.addSelect(propertyIdentifier="stateCode", alias="value");
			smartList.addFilter("countryCode", getCountryCode()); 
			smartList.addOrder("stateName|ASC");
			variables.stateCodeOptions = smartList.getRecords();
		}
		return variables.stateCodeOptions;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}
