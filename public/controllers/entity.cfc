component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiControllerEntity" {
	property name="emailService" type="any";
	
	this.anyLoginMethods='';
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'listclientgroupchecklistanswer');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'listcomment');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'searchchecklist');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'searchchecklistresults');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'saveClientGroupChecklistAnswers');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'printclientgroupchecklist');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'approve');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'markChecklistComplete');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'stringReplaceOptions');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'accountOverview');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'memberresources');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'questionDetails');
	this.anyLoginMethods=listAppend(this.anyLoginMethods, 'flagClientGroupChecklistQuestion');

	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'listchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'detailplanDocumentTemplate');
	this.secureMethods=listAppend(this.secureMethods, 'detailchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'createclientgroup');
	this.secureMethods=listAppend(this.secureMethods, 'editclientgroup');
	this.secureMethods=listAppend(this.secureMethods, 'createclientgroupchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'detailclientgroupchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'editclientgroupchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'listAccount');
	this.secureMethods=listAppend(this.secureMethods, 'editAccount');
	this.secureMethods=listAppend(this.secureMethods, 'createAccount');
	this.secureMethods=listAppend(this.secureMethods, 'preprocessclientgroupchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'processclientgroupchecklist');
	this.secureMethods=listAppend(this.secureMethods, 'downloadclientgroupchecklist');
	
	
	public void function before( required any rc ) {
		super.before(rc);
		if(!isNull(getHibachiScope().getAccount()) && !structKeyExists(rc,"client")) {
			rc.client = getHibachiScope().getAccount().getClient();
		}
	}
	
	public void function createclientgroup( required struct rc ) {
		super.genericCreateMethod('clientGroup', arguments.rc);
		getFW().setview('entity.editclientgroup');
	} 
	
	public void function createclientgroupchecklist( required struct rc ) {
		super.genericCreateMethod('clientGroupChecklist', arguments.rc);
		getFW().setview('entity.editclientgroupchecklist');
	} 
	
	public void function approve( required struct rc ) {
		var entity = getHibachiScope().getService("planService").get(entityName=rc.entityName, idOrFilter=rc.id);
		getHibachiScope().getService("planService").approve(entity=entity);
		renderOrRedirectSuccess( defaultAction="", maintainQueryString=true, rc=arguments.rc);
	}
	
	public void function flagClientGroupChecklistQuestion( required struct rc ) {
		param name="rc.questionID" default="";
		param name="rc.context" default="add";
		  
		getHibachiScope().getService("planService").flagClientGroupChecklistQuestion(clientGroupChecklistID=rc.clientGroupChecklistID, questionID=rc.questionID, context=rc.context);
		
	}
	
	public void function markChecklistComplete( required struct rc ) {
		var clientGroupChecklist = getHibachiScope().getService("planService").get(entityName="clientgroupchecklist", idOrFilter=rc.clientGroupChecklistID);
		var statusTypeClosed = getHibachiScope().getService("planService").get(entityName="type", idOrFilter="5c18b64af183dcccdf52ce5807284c1a");
		clientGroupChecklist.setChecklistStatus(statusTypeClosed);
		getEmailService().sendEmail('ChecklistCompleteConfirmation',clientGroupChecklist.getModifiedByAccount().getEmailAddress(),clientGroupChecklist.getClientGroup().getClient().getClientID());
		rc.clientGroupID = clientGroupChecklist.getClientGroup().getClientGroupID();
		renderOrRedirectSuccess( defaultAction="entity.detailclientgroup&clientGroupID=#rc.clientGroupID#", maintainQueryString=false, rc=arguments.rc);
	}
	
	public function stringReplaceOptions( required struct rc ) {
		var data = {};
		data.replaceVariable = arguments.rc.replaceVariable;
		if(structKeyExists(arguments.rc,'checklistID')){
			data.checklistID = arguments.rc.checklistID;
		}
		var response = getHibachiScope().getService("hibachiUtilityService").getStringReplaceOptions(argumentcollection=data);
		rc.ajaxResponse[ "data" ] = response;
		
		request.layout = false;
		getFW().setLayout('public:modal');
		
		rc.data = response;
	} 
	
	public function questionDetails( required struct rc ) {
		param name="rc.questionCode" default="";
		param name="rc.checklistID" default="";
		
		rc.ajaxResponse[ "data" ] = {};
		var question = getHibachiScope().getService("planService").getChecklistQuestionByQuestionCode(rc.questionCode, rc.checklistID);
		if(!isNull(question)) {
			rc.ajaxResponse[ "data" ]["questionID"] = question.getQuestionID();
			rc.ajaxResponse[ "data" ]["checklistSectionID"] = question.getChecklistSection().getChecklistSectionID();
		}
		request.layout = false;
		getFW().setLayout('public:modal');
		
		rc.data = rc.ajaxResponse[ "data" ];
	} 
	
	public any function saveClientGroupChecklistAnswers( required struct rc ) {
		var clientGroupChecklist = getHibachiScope().getService("planService").get(entityName="clientgroupchecklist", idOrFilter=rc.clientGroupChecklistID);
		if(clientGroupChecklist.getChecklistStatus().getSystemCode() != "cgcsClosed"){
			var response = getHibachiScope().getService("planService").saveClientGroupChecklistAnswers(arguments.rc.answer,arguments.rc.clientGroupChecklistID);
		}
		super.genericDetailMethod('clientGroupChecklist', arguments.rc);
		getFW().setview('entity.detailclientgroupchecklist');
	}
	
	public void function accountOverview( required struct rc ) {
		rc.account = getHibachiScope().getAccount();
		getFW().setview('entity.accountoverview');
	} 
	
	public void function editAccount( required struct rc ) {
		param name="rc.accountID" default="#getHibachiScope().getAccount().getAccountID()#";
		super.genericEditMethod('account', arguments.rc);
	} 
	
	public void function processAccount( required struct rc ) {
		if(rc.processContext == "create") {
			rc.permissionGroupID = "2c909b36487f5a1801489b5040c30395";
			rc.clientID = getHibachiScope().getAccount().getClient().getClientID();
		}
		super.genericProcessMethod('account', arguments.rc);
	} 
	
	public void function after( required struct rc) {

		if( getHibachiScope().getAccount().getSuperUserFlag() NEQ 1
			&&
			(
			(structkeyexists(rc,"clientgroup")
				&& isObject("clientgroup") 
				&& !rc.clientgroup.isNew()
				&& !rc.clientgroup.getClient().hasAccount(getHibachiScope().getAccount()))
			||
			(structkeyexists(rc,"client")
				&& isObject("client")  
				&& !rc.client.hasAccount(getHibachiScope().getAccount()))
				)
			) {
			location("/","false");
		}
		
		// clear out current editor for checklist
		if(arguments.rc.entityActionDetails.thisAction != "entity.detailclientgroupchecklist" && hasApplicationValue("currentEditors_checklists")) {
			
			for(var key in getApplicationValue("currentEditors_checklists")) {
				var currentEditorIndex = arrayFind(getApplicationValue("currentEditors_checklists")[key],getHibachiScope().getAccount().getFullName());
				if(currentEditorIndex) {
					arrayDeleteAt(getApplicationValue("currentEditors_checklists")[key],currentEditorIndex);
				}
			}
		}
		
	}
	
}