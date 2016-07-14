component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiController" {

	// fw1 Auto-Injected Service Properties
	property name="accountService" type="any";
	property name="hibachiSessionService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'login');
	this.publicMethods=listAppend(this.publicMethods, 'authorizeLogin');
	this.publicMethods=listAppend(this.publicMethods, 'logout');
	this.publicMethods=listAppend(this.publicMethods, 'noaccess');
	this.publicMethods=listAppend(this.publicMethods, 'error');
	this.publicMethods=listAppend(this.publicMethods, 'resetPassword');
	this.publicMethods=listAppend(this.publicMethods, 'updatePassword');
	
	this.secureMethods='';
	
	this.anyLoginMethods="*";
	
	public void function before(required struct rc) {
		rc.pagetitle = rbKey(replace(arguments.rc[ getFW().getAction() ], ':', '.'));
		
		// clear out current editor for checklist
		if(hasApplicationValue("currentEditors_checklists")) {
			
			for(var key in getApplicationValue("currentEditors_checklists")) {
				var currentEditorIndex = arrayFind(getApplicationValue("currentEditors_checklists")[key],getHibachiScope().getAccount().getFullName());
				if(currentEditorIndex) {
					arrayDeleteAt(getApplicationValue("currentEditors_checklists")[key],currentEditorIndex);
				}
			}
		}
		
	}

	public void function login(required struct rc) {
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
	}
	
	public void function authorizeLogin(required struct rc) {

		getAccountService().processAccount(getHibachiScope().getAccount(), rc, "login");	

		if(getHibachiScope().getLoggedInFlag()) {
			getFW().redirect(action="main.default", queryString="s=1");
		}
		
		getFW().setView("main.login");
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
	}
	
	public void function logout(required struct rc) {
		getHibachiSessionService().logoutAccount();
		
		getFW().redirect('main.login');
	}
	
	public void function resetPassword(required struct rc) {
		param name="rc.accountID" default="";
		
		var account = getAccountService().getAccount( rc.accountID );
		
		if(!isNull(account)) {
			var account = getAccountService().processAccount(account, rc, "resetPassword");
			
			if(!account.hasErrors()) {
				rc.emailAddress = account.getEmailAddress();
				authorizeLogin( rc );
			}
		}
		
		login( rc );
	}
	
	public void function updatePassword(required struct rc){
		getAccountService().processAccount(rc.$.PhiaPlan.getAccount(), rc, "updatePassword");
		
		if(!rc.$.PhiaPlan.getAccount().hasErrors()) {
			rc.$.PhiaPlan.showMessageKey("admin.main.updatePassword_success");
			getFW().redirect(action="main.default", preserve="messages");
		}
	
		getFW().setView("main.login");
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
	}
}
