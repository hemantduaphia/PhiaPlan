component extends="PhiaPlan.org.Hibachi.HibachiController" persistent="false" accessors="true" output="false" {

	property name="accountService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiTagService" type="any";
	
	this.anyLoginMethods = '';
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'updateListingDisplay');
	
	public void function before(required struct rc) {
		getFW().setView("public:ajax.default");
	}
	
	public void function updateListingDisplay(required struct rc) {
		param name="arguments.rc.processObjectProperties" default="";
		param name="arguments.rc.propertyIdentifiers" default="";
		param name="arguments.rc.adminAttributes" default="";
	
		var smartList = getHibachiService().getServiceByEntityName( entityName=rc.entityName ).invokeMethod( "get#getHibachiService().getProperlyCasedShortEntityName( rc.entityName )#SmartList", {1=rc} );
		
		var smartListPageRecords = smartList.getPageRecords();
		var piArray = listToArray(rc.propertyIdentifiers);
		var popArray = listToArray(rc.processObjectProperties);
		
		var admin = {};
		if(len(arguments.rc.adminAttributes) && isJSON(arguments.rc.adminAttributes) && arguments.rc.adminAttributes != "null") {
			admin = deserializeJSON(arguments.rc.adminAttributes);
		}
		
		rc.ajaxResponse[ "recordsCount" ] = smartList.getRecordsCount();
		rc.ajaxResponse[ "pageRecords" ] = [];
		rc.ajaxResponse[ "pageRecordsCount" ] = arrayLen(smartList.getPageRecords());
		rc.ajaxResponse[ "pageRecordsShow"] = smartList.getPageRecordsShow();
		rc.ajaxResponse[ "pageRecordsStart" ] = smartList.getPageRecordsStart();
		rc.ajaxResponse[ "pageRecordsEnd" ] = smartList.getPageRecordsEnd();
		rc.ajaxResponse[ "currentPage" ] = smartList.getCurrentPage();
		rc.ajaxResponse[ "totalPages" ] = smartList.getTotalPages();
		rc.ajaxResponse[ "savedStateID" ] = smartList.getSavedStateID();
		
		if(arrayLen(popArray)) {
			var processEntity = getHibachiService().getServiceByEntityName( entityName=rc.processEntity ).invokeMethod( "get#getHibachiService().getProperlyCasedShortEntityName( rc.processEntity )#", {1=rc.processEntityID} );
		}
		
		for(var i=1; i<=arrayLen(smartListPageRecords); i++) {
			
			var record = smartListPageRecords[i];
			
			// Create a record JSON container
			var thisRecord = {};
			
			// Add the simple values from property identifiers
			for(var p=1; p<=arrayLen(piArray); p++) {
				var value = record.getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
				if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
					thisRecord[ piArray[p] ] = value & " ";
				} else {
					thisRecord[ piArray[p] ] = value;
				}
			}
			
			// Add any process object values
			if(arrayLen(popArray)) {
				var processObject = getTransient("#arguments.rc.processEntity#_#arguments.rc.processContext#");
				processObject.invokeMethod("set#record.getClassName()#", {1=record});
				processObject.invokeMethod("set#record.getPrimaryIDPropertyName()#", {1=record.getPrimaryIDValue()});
				processObject.invokeMethod("set#rc.processEntity#", {1=processEntity});
				for(var p=1; p<=arrayLen(popArray); p++) {
					var attributes = {
						object=processObject,
						property=popArray[p],
						edit=true,
						displayType='plain'
					};
					thisRecord[ popArray[p] ] = getHibachiTagService().cfmodule(name="HibachiPropertyDisplay", attributeCollection=attributes);
				}
			}
			
			thisRecord[ "admin" ] = "";
			
			// Add the admin buttons
			if(structKeyExists(admin, "detailAction")) {
				var attributes = {
					action=admin.detailAction,
					queryString="#listPrepend(admin.detailQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#",
					class="btn btn-mini",
					icon="eye-open",
					iconOnly="true",
					modal=admin.detailModal
				};
				thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(name="HibachiActionCaller", attributeCollection=attributes);
			}
			if(structKeyExists(admin, "editAction")) {
				var attributes = {
					action=admin.editAction,
					queryString="#listPrepend(admin.editQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#",
					class="btn btn-mini",
					icon="pencil",
					iconOnly="true",
					modal=admin.editModal,
					disabled=record.isNotEditable()
				};
				thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(name="HibachiActionCaller", attributeCollection=attributes);
			}
			if(structKeyExists(admin, "deleteAction")) {
				var deleteErrors = record.validate(context="delete");
				var attributes = {
					action=admin.deleteAction,
					queryString="#listPrepend(admin.deleteQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#",
					class="btn btn-mini",
					icon="trash",
					iconOnly="true",
					disabled=deleteErrors.hasErrors(),
					disabledText=deleteErrors.getAllErrorsHTML(),
					confirm=true
				};
				thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(name="HibachiActionCaller", attributeCollection=attributes);
			}
			if(structKeyExists(admin, "processAction")) {
				var attributes = {
					action=admin.processAction,
					entity=processEntity,
					processContext=admin.processContext,
					queryString="#listPrepend(admin.processQueryString, '#record.getPrimaryIDPropertyName()#=#record.getPrimaryIDValue()#', '&')#",
					class="btn hibachi-ajax-submit"
				};
				thisRecord[ "admin" ] &= getHibachiTagService().cfmodule(name="HibachiProcessCaller", attributeCollection=attributes);
			}
			
			arrayAppend(rc.ajaxResponse[ "pageRecords" ], thisRecord);
		}
	}
	
}