component entityname="PhiaPlanPlanDocumentChecklistSection" table="PlanDocumentChecklistSection" persistent="true" output="false" accessors="true" extends="HibachiEntity" hb_serviceName="planService" hb_permission="this" {
	
	// Persistent Properties
	property name="planDocumentChecklistSectionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="planDocumentChecklistSectionDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg" ;
	property name="checklistSectionName" ormtype="string";
	property name="checklistSectionCode" ormtype="string";
	property name="sortOrder" ormtype="integer" sortContext="planDocumentTemplate";
	property name="phiaApprovedFlag" ormtype="boolean" default="false";
	property name="clientApprovedFlag" ormtype="boolean" default="false";
	property name="activeFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	//property name="checklistSection" cfc="ChecklistSection" fieldtype="many-to-one" fkcolumn="checklistSectionID";
	property name="planDocumentTemplate" cfc="PlanDocumentTemplate" fieldtype="many-to-one" fkcolumn="planDocumentTemplateID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	property name="planDocumentChecklistSectionName" persistent="false" ; 
	property name="loopingCodeFlag" persistent="false" ; 
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getPlanDocumentChecklistSectionName() {
		return variables.planDocumentTemplate.getplanDocumentTemplateName() & " - " & variables.checklistSectionName;
	}

	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// ChecklistSection (many-to-one)
	/*    
	public void function setChecklistSection(required any checklistSection) {    
		variables.checklistSection = arguments.checklistSection;    
		if(isNew() or !arguments.checklistSection.hasPlanDocumentChecklistSection( this )) {    
			arrayAppend(arguments.checklistSection.getPlanDocumentChecklistSections(), this);    
		}    
	}    
	public void function removeChecklistSection(any checklistSection) {    
		if(!structKeyExists(arguments, "checklistSection")) {    
			arguments.checklistSection = variables.checklistSection;    
		}    
		var index = arrayFind(arguments.checklistSection.getPlanDocumentChecklistSections(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.checklistSection.getPlanDocumentChecklistSections(), index);    
		}    
		structDelete(variables, "checklistSection");    
	}
	*/
	
	// PlanDocumentTemplate (many-to-one)    
	public void function setPlanDocumentTemplate(required any planDocumentTemplate) {    
		variables.planDocumentTemplate = arguments.planDocumentTemplate;    
		if(isNew() or !arguments.planDocumentTemplate.hasPlanDocumentChecklistSection( this )) {    
			arrayAppend(arguments.planDocumentTemplate.getPlanDocumentChecklistSections(), this);    
		}    
	}    
	public void function removePlanDocumentTemplate(any planDocumentTemplate) {    
		if(!structKeyExists(arguments, "planDocumentTemplate")) {    
			arguments.planDocumentTemplate = variables.planDocumentTemplate;    
		}    
		var index = arrayFind(arguments.planDocumentTemplate.getPlanDocumentChecklistSections(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.planDocumentTemplate.getPlanDocumentChecklistSections(), index);    
		}    
		structDelete(variables, "planDocumentTemplate");    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "planDocumentChecklistSectionName";
	}
	
	public boolean function hasLoopingCode() {
		request.context.nestedcode = getService("planService").validatePlanDocumentChecklistSectionLoopingCode(this);
		if(len(request.context.nestedcode)) {
			return true;	
		} else {
			return false;	
		}
	}
	
	public boolean function hasNoLoopingCode() {
		return !hasLoopingCode();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================

}
