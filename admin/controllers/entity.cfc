component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiControllerEntity" {
	
	public void function savePlanDocumentChecklistSection( required struct rc ) {
		if(!structKeyExists(rc,"checklistSectionCode") && structKeyExists(rc,"checklistSectionID")) {
			var checklistSection = getHibachiScope().getService("planService").getChecklistSection(rc.checklistSectionID);
			rc.checklistSectionName = checklistSection.getChecklistSectionName();
			rc.checklistSectionCode = checklistSection.getChecklistSectionCode();
		}
		super.genericSaveMethod('planDocumentChecklistSection', arguments.rc);
	} 
	
	public void function listalltrackedanswer( required struct rc ) {
		
	} 
	
	public void function exportalltrackedanswer( required struct rc ) {
		getService("planService").exportTrackedAnswer();
	} 
	
}