component output="false" accessors="true" extends="HibachiProcess" {

	// Injected Entity
	property name="clientGroupChecklist";

	// Data Properties
	property name="clientGroupChecklistName";
	property name="planDocumentTemplateID" hb_formFieldType="select";
	property name="checklistID" hb_formFieldType="select";
	
	// Lazy / Injected Objects
	property name="planDocumentTemplate";
	property name="checklist";
	
	public any function getplanDocumentTemplateIDOptions() {
		return getclientGroupChecklist().getPlanDocumentTemplateOptions();
	}
	
	public any function getchecklistIDOptions() {
		return getclientGroupChecklist().getchecklistOptions();
	}
	
	public any function getPlanDocumentTemplate() {
		if(!structKeyExists(variables, "planDocumentTemplate") && !isNull(getplanDocumentTemplateID())) {
			variables.planDocumentTemplate = getService("planService").getplanDocumentTemplate(getplanDocumentTemplateID());
		}
		if(structKeyExists(variables, "planDocumentTemplate")) {
			return variables.planDocumentTemplate;
		}
	}
	
	public any function getChecklist() {
		if(!structKeyExists(variables, "checklist") && !isNull(getChecklistID())) {
			variables.checklist = getService("planService").getChecklist(getChecklistID());
		}
		if(structKeyExists(variables, "checklist")) {
			return variables.checklist;
		}
	}
	
}