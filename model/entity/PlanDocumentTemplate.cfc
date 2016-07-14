component entityname="PhiaPlanPlanDocumentTemplate" table="PlanDocumentTemplate" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="planService" hb_permission="this" {
	
	// Persistent Properties
	property name="planDocumentTemplateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="planDocumentTemplateName" ormtype="string";
	property name="planDocumentTemplateCode" ormtype="string";
	property name="planDocumentTemplateDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="planDocumentFooterText" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="planDocumentHeaderText" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="orientation" ormtype="string" hb_formFieldType="select";
	property name="marginTop" ormtype="string" hb_formFieldType="select";
	property name="marginBottom" ormtype="string" hb_formFieldType="select";
	property name="marginRight" ormtype="string" hb_formFieldType="select";
	property name="marginLeft" ormtype="string" hb_formFieldType="select";
	property name="paragraphSpacing" ormtype="string" hb_formFieldType="select";
	property name="defaultFont" ormtype="string" hb_formFieldType="select";
	property name="defaultFontSize" ormtype="string" hb_formFieldType="select";
	property name="listMarginAlignment" ormtype="string" hb_formFieldType="select";
	property name="checklistLimit" ormtype="integer" ;
	property name="activeFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID" hb_optionsNullRBKey="define.select";
	property name="checklist" cfc="Checklist" fieldtype="many-to-one" fkcolumn="checklistID" hb_optionsNullRBKey="define.select";
	
	// Related Object Properties (one-to-many)
	property name="planDocumentChecklistSections" singularname="planDocumentChecklistSection" cfc="PlanDocumentChecklistSection" fieldtype="one-to-many" type="array" fkcolumn="planDocumentTemplateID" cascade="all-delete-orphan" inverse="true";
	property name="clientGroupChecklists" singularname="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="one-to-many" type="array" fkcolumn="planDocumentTemplateID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getOrientationOptions() {
		return [
			{name="Portrait", value="portrait"},
			{name="Landscape", value="landscape"}
		];
	}

	public array function getMarginTopOptions() {
		return getMarginOptions();
	}

	public array function getMarginBottomOptions() {
		return getMarginOptions();
	}

	public array function getMarginRightOptions() {
		return getMarginOptions();
	}

	public array function getMarginLeftOptions() {
		return getMarginOptions();
	}

	public boolean function getChecklistLimitReachedFlag() {
    	var result = false;
    	
    	if(!isNull(getChecklistLimit()) && !isNull(getClient())) {
    		if(getChecklistLimit() <= getService("planDAO").getClientChecklistCount(getClient().getClientID(),getPlanDocumentTemplateID())) {
    			result = true;
    		}
    	}

    	return result;
    }

	public array function getMarginOptions() {
		return [
			{name="1 Inch", value="1"},
			{name=".7 Inch", value=".7"},
			{name=".75 Inch", value=".75"},
			{name=".50 Inch", value=".50"},
			{name=".25 Inch", value=".25"},
			{name="2 Inch", value="2"},
			{name="1.75 Inch", value="1.75"},
			{name="1.50 Inch", value="1.50"},
			{name="1.25 Inch", value="1.25"}
		];
	}

	public array function getParagraphSpacingOptions() {
		return [
			{name="#rbKey('define.select')#", value=""},
			{name="0", value="0"},
			{name="1", value="1"},
			{name="2", value="2"}
		];
	}

	public array function getDefaultFontOptions() {
		return [
			{name="Arial", value="Arial"},
			{name="Arial Narrow", value="Arial Narrow"},
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

	public array function getListMarginAlignmentOptions() {
		return [
			{name="Normal", value="Normal"},
			{name="Left Aligned", value="Left Aligned"}
		];
	}

	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Client (many-to-one)    
	public void function setClient(required any client) {    
		variables.client = arguments.client;    
		if(isNew() or !arguments.client.hasPlanDocumentTemplate( this )) {    
			arrayAppend(arguments.client.getPlanDocumentTemplates(), this);    
		}    
	}    
	public void function removeClient(any client) {    
		if(!structKeyExists(arguments, "client")) {    
			arguments.client = variables.client;    
		}    
		var index = arrayFind(arguments.client.getPlanDocumentTemplates(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.client.getPlanDocumentTemplates(), index);    
		}    
		structDelete(variables, "client");    
	}
	
	// Checklist (many-to-one)    
	public void function setChecklist(required any checklist) {    
		variables.checklist = arguments.checklist;    
		if(isNew() or !arguments.checklist.hasPlanDocumentTemplate( this )) {    
			arrayAppend(arguments.checklist.getPlanDocumentTemplates(), this);    
		}    
	}    
	public void function removeChecklist(any checklist) {    
		if(!structKeyExists(arguments, "checklist")) {    
			arguments.checklist = variables.checklist;    
		}    
		var index = arrayFind(arguments.checklist.getPlanDocumentTemplates(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.checklist.getPlanDocumentTemplates(), index);    
		}    
		structDelete(variables, "checklist");    
	}
	
	// planDocumentChecklistSection (one-to-many)    
	public void function addPlanDocumentChecklistSections(required any planDocumentChecklistSection) {    
		arguments.planDocumentChecklistSection.setPlanDocumentTemplate( this );    
	}    
	public void function removePlanDocumentChecklistSection(required any planDocumentChecklistSection) {    
		arguments.planDocumentChecklistSection.removePlanDocumentTemplate( this );    
	}
	
	// clientGroupChecklist (one-to-many)    
	public void function addClientGroupChecklists(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.setPlanDocumentTemplate( this );    
	}    
	public void function removeClientGroupChecklist(required any clientGroupChecklist) {    
		arguments.clientGroupChecklist.removePlanDocumentTemplate( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
