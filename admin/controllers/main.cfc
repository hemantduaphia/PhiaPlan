component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiController" {

	// fw1 Auto-Injected Service Properties
	property name="accountService" type="any";
	property name="planService" type="any";
	property name="hibachiSessionService" type="any";
	
	this.publicMethods='';
	this.publicMethods=listAppend(this.publicMethods, 'login');
	this.publicMethods=listAppend(this.publicMethods, 'authorizeLogin');
	this.publicMethods=listAppend(this.publicMethods, 'logout');
	this.publicMethods=listAppend(this.publicMethods, 'noaccess');
	this.publicMethods=listAppend(this.publicMethods, 'error');
	this.publicMethods=listAppend(this.publicMethods, 'resetPassword');
	this.publicMethods=listAppend(this.publicMethods, 'updatePassword');
	
	this.anyAdminMethods='';
	
	this.secureMethods='';
	this.secureMethods=listAppend(this.secureMethods, 'default');
	this.secureMethods=listAppend(this.secureMethods, 'unlockAccount');
	
	
	public void function before(required struct rc) {
		rc.pagetitle = rbKey(replace(arguments.rc[ getFW().getAction() ], ':', '.'));
	}

	public void function default(required struct rc) {
		rc.commentSmartList = getPlanService().getCommentSmartList();
		rc.commentSmartList.addOrder("createdDateTime|DESC");
		rc.commentSmartList.setPageRecordsShow(10);

		rc.questionSmartList = getPlanService().getQuestionSmartList();
		rc.questionSmartList.addOrder("createdDateTime|DESC");
		rc.questionSmartList.addFilter("clientApprovedFlag",1);
		rc.questionSmartList.setPageRecordsShow(10);
		
		rc.clientGroupChecklistSmartList = getPlanService().getClientGroupChecklistSmartList();
		rc.clientGroupChecklistSmartList.addOrder("createdDateTime|DESC");
		rc.clientGroupChecklistSmartList.setPageRecordsShow(10);
		
		rc.clientGroupSmartList = getPlanService().getClientGroupSmartList();
		rc.clientGroupSmartList.addOrder("createdDateTime|DESC");
		rc.clientGroupSmartList.setPageRecordsShow(10);
		
	}
	
	public void function login(required struct rc) {
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
	}
	
	public void function authorizeLogin(required struct rc) {
		getAccountService().processAccount(getHibachiScope().getAccount(), rc, "login");	
		
		if(getHibachiScope().getLoggedInFlag()) {
			getFW().redirect(action="admin:main.default", queryString="s=1");
		}
		
		getFW().setView("admin:main.login");
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
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
	
	public void function logout(required struct rc) {
		getHibachiSessionService().logoutAccount();
		
		getFW().redirect('admin:main.login');
	}
	
	public void function unlockAccount(){
		
		var account = getService("HibachiService").getAccountByAccountID(url.accountid);
		
		account = getAccountService().processAccount(account, "unlock");
		
		rc.$.PhiaPlan.showMessageKey( 'admin.main.unlockAccount_info' );
		
		getFW().redirect(action="entity.detailaccount", queryString="accountID=#arguments.rc.accountid#", preserve="messages");

	}
	
	public void function updatePassword(required struct rc){
		getAccountService().processAccount(rc.$.PhiaPlan.getAccount(), rc, "updatePassword");
		
		if(!rc.$.PhiaPlan.getAccount().hasErrors()) {
			rc.$.PhiaPlan.showMessageKey("admin.main.updatePassword_success");
			getFW().redirect(action="admin:main.default", preserve="messages");
		}
	
		getFW().setView("admin:main.login");
		rc.accountAuthenticationExists = getAccountService().getAccountAuthenticationExists();
	}
}
