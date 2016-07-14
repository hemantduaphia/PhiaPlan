component displayname="Type" entityname="PhiaPlanType" table="Type" persistent="true" accessors="true" output="true" extends="HibachiEntity" hb_serviceName="hibachiService" hb_permission="this" hb_parentPropertyName="parentType" hb_defaultOrderProperty="typeID" {
	
	// Persistent Properties
	property name="typeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="typeIDPath" ormtype="string";
	property name="type" ormtype="string";
	property name="systemCode" ormtype="string";
	
	// Related Object Properties
	property name="parentType" cfc="Type" fieldtype="many-to-one" fkcolumn="parentTypeID";
	property name="childTypes" singularname="childType" type="array" cfc="Type" fieldtype="one-to-many" fkcolumn="parentTypeID" cascade="all" inverse="true";
	
	public any function getChildTypes() {
		if(!isDefined('variables.childTypes')) {
			variables.childTypes = arraynew(1);
		}
		return variables.childTypes;
	}
	
	public any function getType() {
		if(!structKeyExists(variables, "type")) {
			variables.type = "";
		}
		return variables.type;
	}
	
	// This overrides the build in system code getter to look up to the parent if a system code doesn't exist for this type.
	/*public string function getSystemCode() {
		if(isNull(variables.systemCode) && !isNull(getParentType())) {
			return getParentType().getSystemCode();
		}
		return variables.systemCode;
	}*/
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public string function getTypeIDPath() {
		if(isNull(variables.typeIDPath)) {
			variables.typeIDPath = buildIDPathList( "parentType" );
		}
		return variables.typeIDPath;
	}
	
	// ==============  END: Overridden Implicet Getters ====================
		
	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
    	return "type";
    }
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		setTypeIDPath( buildIDPathList( "parentType" ) );
		super.preInsert();
	}
	
	public void function preUpdate(struct oldData){
		setTypeIDPath( buildIDPathList( "parentType" ) );;
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
