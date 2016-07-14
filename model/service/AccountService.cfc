component output="false" accessors="true" extends="HibachiService" {

	property name="accountDAO" type="any";	

	variables.passwordResetDays = "90";
	variables.accountLockMinutes = "30";
	variables.adminFailedLoginAttempts = "6";
	variables.publicFailedLoginAttempts = "6";

	// ===================== START: Logical Methods ===========================

	public string function getHashedAndSaltedPassword(required string password, required string salt) {
		return hash(arguments.password & arguments.salt, 'SHA-512');
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public any function getInternalAccountAuthenticationsByEmailAddress(required string emailAddress) {
		return getAccountDAO().getInternalAccountAuthenticationsByEmailAddress(argumentcollection=arguments);
	}
	
	public boolean function getAccountAuthenticationExists() {
		return getAccountDAO().getAccountAuthenticationExists();
	}
	
	public string function getPasswordResetID(required any account) {
		var passwordResetID = "";
		var accountAuthentication = getAccountDAO().getPasswordResetAccountAuthentication(accountID=arguments.account.getAccountID());
		
		if(isNull(accountAuthentication)) {
			var accountAuthentication = this.newAccountAuthentication();
			accountAuthentication.setExpirationDateTime(now() + 7);
			accountAuthentication.setAccount( arguments.account );
			
			accountAuthentication = this.saveAccountAuthentication( accountAuthentication );
		}
		
		return lcase("#arguments.account.getAccountID()##hash(accountAuthentication.getAccountAuthenticationID() & arguments.account.getAccountID())#");
	}
	
	// =====================  END: DAO Passthrough ============================	
	
	public any function processAccount_createPassword(required any account, required any processObject) {
		//change password and create password functions should be combined at some point. Work needed to do this still needs to be scoped out.
		//For now they are just calling this function that handles the actual work. 
		arguments.account = createNewAccountPassword(arguments.account, arguments.processObject);
		
		return arguments.account;
	}
	
	public any function processAccount_changePassword(required any account, required any processObject) {
		//change password and create password functions should be combined at some point. Work needed to do this still needs to be scoped out.
		//For now they are just calling this function that handles the actual work. 
		arguments.account = createNewAccountPassword(arguments.account, arguments.processObject);
		
		return arguments.account;
	}
	
	public any function processAccount_create(required any account, required any processObject) {
		
		// Populate the account with the correct values that have been previously validated
		arguments.account.setFirstName( processObject.getFirstName() );
		arguments.account.setLastName( processObject.getLastName() );
		
		// If company was passed in then set that up
		if(!isNull(processObject.getCompany())) {
			arguments.account.setCompany( processObject.getCompany() );	
		}
		
		// If phone number was passed in the add a primary phone number
		if(!isNull(processObject.getPhoneNumber())) {
			var accountPhoneNumber = this.newAccountPhoneNumber();
			accountPhoneNumber.setAccount( arguments.account );
			accountPhoneNumber.setPhoneNumber( processObject.getPhoneNumber() );
		}
		
		// If email address was passed in then add a primary email address
		if(!isNull(processObject.getEmailAddress())) {
			var accountEmailAddress = this.newAccountEmailAddress();
			accountEmailAddress.setAccount( arguments.account );
			accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );
		}
		
		// If the createAuthenticationFlag was set to true, the add the authentication
		if(processObject.getCreateAuthenticationFlag()) {
			var accountAuthentication = this.newAccountAuthentication();
			accountAuthentication.setAccount( arguments.account );
		
			// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
			getHibachiDAO().save(accountAuthentication);
		
			// Set the password
			accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );	
		}
		
		// if permission group was passed in then add to account
		if(!isNull(processObject.getPermissionGroup())) {
			arguments.account.addPermissionGroup( processObject.getPermissionGroup() );
		}
		
		// if client was passed in then add to account
		if(!isNull(processObject.getClient())) {
			arguments.account.setClient( processObject.getClient() );
		}
		
		// Call save on the account now that it is all setup
		arguments.account = this.saveAccount(arguments.account);
		
		return arguments.account;
	}
	
	public any function processAccount_login(required any account, required any processObject) {
		// Take the email address and get all of the user accounts by primary e-mail address
		var accountAuthentication = getAccountDAO().getActivePasswordByEmailAddress(emailAddress=arguments.processObject.getEmailAddress());
		var invalidLoginData = {emailAddress=arguments.processObject.getEmailAddress()};
		
		if(!isNull(accountAuthentication)) {
			if(isNull(accountAuthentication.getAccount().getLoginLockExpiresDateTime()) || DateCompare(Now(), accountAuthentication.getAccount().getLoginLockExpiresDateTime()) == 1 ){	
				// If the password matches what it should be, then set the account in the session and 
				if(!isNull(accountAuthentication.getPassword()) && len(accountAuthentication.getPassword()) && accountAuthentication.getPassword() ==  getHashedAndSaltedPassword(password=arguments.processObject.getPassword(), salt=accountAuthentication.getAccountAuthenticationID())) {							
					//Check to see if a password reset is required
					if(checkPasswordResetRequired(accountAuthentication, arguments.processObject)){
						arguments.processObject.addError('passwordUpdateRequired',  rbKey('validate.newPassword.duplicatePassword'));	
					}else{
						getHibachiSessionService().loginAccount( accountAuthentication.getAccount(), accountAuthentication);
					}
					
					accountAuthentication.getAccount().setFailedLoginAttemptCount(0); 
					accountAuthentication.getAccount().setLoginLockExpiresDateTime(javacast("null",""));
					
					return arguments.account;
				}else{
					arguments.processObject.addError('password', rbKey('validate.session_authorizeAccount.password.incorrect'));
					
					invalidLoginData.account = accountAuthentication.getAccount();

					//Log the failed attempt to account.failedLoginAttemptCount
					var failedLogins = nullReplace(invalidLoginData.account.getFailedLoginAttemptCount(), 0) + 1;
					invalidLoginData.account.setFailedLoginAttemptCount(failedLogins); 
					
					//Get the max number of failed attempts before the account is locked based on account type 
					if(accountAuthentication.getAccount().getAdminAccountFlag()){
						var maxLoginAttempts = variables.adminFailedLoginAttempts;
					}else{
						var maxLoginAttempts = variables.publicFailedLoginAttempts;
					}	
							
					//If the log attempt is greater than the failedLoginSetting, call function to lockAccount
					if (!isNull(maxLoginAttempts) && maxLoginAttempts > 0 && failedLogins >= maxLoginAttempts){
						this.processAccount(invalidLoginData.account, 'lock');
					}
				}
			}else{
				arguments.processObject.addError('password',rbKey('validate.account.loginblocked'));
			}
		} else {
			arguments.processObject.addError('emailAddress', rbKey('validate.session_authorizeAccount.emailAddress.notfound'));
		}
		
		return arguments.account;
	}
	
	public any function processAccount_setupInitialAdmin(required any account, required struct data={}, required any processObject) {
		
		// Populate the account with the correct values that have been previously validated
		arguments.account.setFirstName( processObject.getFirstName() );
		arguments.account.setLastName( processObject.getLastName() );
		if(!isNull(processObject.getCompany())) {
			arguments.account.setCompany( processObject.getCompany() );	
		}
		arguments.account.setSuperUserFlag( 1 );
		
		// Setup the email address
		var accountEmailAddress = this.newAccountEmailAddress();
		accountEmailAddress.setAccount(arguments.account);
		accountEmailAddress.setEmailAddress( processObject.getEmailAddress() );
		
		// Setup the authentication
		var accountAuthentication = this.newAccountAuthentication();
		accountAuthentication.setAccount( arguments.account );
		
		// Put the accountAuthentication into the hibernate scope so that it has an id
		getHibachiDAO().save(accountAuthentication);
		
		// Set the password
		accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.data.password, accountAuthentication.getAccountAuthenticationID()) );
		
		// Call save on the account now that it is all setup
		arguments.account = this.saveAccount(arguments.account);
		
		// Login the new account
		if(!arguments.account.hasErrors()) {
			getHibachiSessionService().loginAccount(account=arguments.account, accountAuthentication=accountAuthentication);	
		}
		
		return arguments.account;
	}
	
	public any function processAccount_resetPassword( required any account, required any processObject ) {
		var changeProcessData = {
			password = arguments.processObject.getPassword(),
			passwordConfirm = arguments.processObject.getPasswordConfirm()
		};
		arguments.account = this.processAccount(arguments.account, changeProcessData, 'changePassword');
		
		// If there are no errors
		if(!arguments.account.hasErrors()) {
			// Get the temporary accountAuth
			var tempAA = getAccountDAO().getPasswordResetAccountAuthentication(accountID=arguments.account.getAccountID());
			
			// Delete the temporary auth
			this.deleteAccountAuthentication( tempAA );
			
			// Then flush the ORM session so that an account can be logged in right away
			getHibachiDAO().flushORMSession();
		}
		
		return arguments.account;
	}
	
	public any function processAccount_lock(required any account){
		var expirationDateTime= dateAdd('n', variables.accountLockMinutes, Now());
		arguments.account.setLoginLockExpiresDateTime(expirationDateTime);
		arguments.account.setFailedLoginAttemptCount(0);

		return arguments.account;
	}
	
	public any function processAccount_unlock(required any account){
		arguments.account.setLoginLockExpiresDateTime(javacast("null",""));
		
		return arguments.account;
	}
	
	public any function processAccount_updatePassword(required any account, required any processObject){
		//This function needs to check and make sure that the old password equals is valid
		
		var accountAuthentication =getAccountDAO().getActivePasswordByEmailAddress( emailAddress= arguments.processObject.getEmailAddress() );
		
		if(!isNull(accountAuthentication)) {
			if(!isNull(accountAuthentication.getPassword()) && len(accountAuthentication.getPassword()) && accountAuthentication.getPassword() == getHashedAndSaltedPassword(password=arguments.processObject.getExistingPassword(), salt=accountAuthentication.getAccountAuthenticationID())) {	
				//create the new pasword the updated password 
				arguments.account = createNewAccountPassword(accountAuthentication.getAccount(), arguments.processObject);	
				if(!arguments.processObject.hasErrors()){
					if(isNull(accountAuthentication.getAccount().getLoginLockExpiresDateTime()) || DateCompare(Now(), accountAuthentication.getAccount().getLoginLockExpiresDateTime()) == 1 ){
						getHibachiSessionService().loginAccount( accountAuthentication.getAccount(), accountAuthentication);
					}else{
						arguments.processObject.addError('password',rbKey('validate.account.loginblocked'));
					}
					
				
				}
				
			}else{
				arguments.processObject.addError('existingPassword', rbKey('validate.account_authorizeAccount.password.incorrect'));
			}
		}else{
			arguments.processObject.addError('emailAddress', rbKey('validate.account_authorizeAccount.emailAddress.notfound'));
		}
		
		return arguments.account;
	}
	
	// ====================== START: Save Overrides ===========================
	
	public any function savePermissionGroup(required any permissionGroup, struct data={}, string context="save") {
	
		arguments.permissionGroup.setPermissionGroupName( arguments.data.permissionGroupName );
		
		// As long as permissions were passed in we can set those up
		if(structKeyExists(arguments.data, "permissions")) {
			// Loop over all of the permissions that were passed in.
			for(var i=1; i<=arrayLen(arguments.data.permissions); i++) {
				
				var pData = arguments.data.permissions[i];	
				var pEntity = this.getPermission(arguments.data.permissions[i].permissionID, true);
				pEntity.populate( pData );
				
				// Delete this permssion
				if(!pEntity.isNew() && (isNull(pEntity.getAllowCreateFlag()) || !pEntity.getAllowCreateFlag()) && (isNull(pEntity.getAllowReadFlag()) || !pEntity.getAllowReadFlag()) && (isNull(pEntity.getAllowUpdateFlag()) || !pEntity.getAllowUpdateFlag()) && (isNull(pEntity.getAllowDeleteFlag()) || !pEntity.getAllowDeleteFlag()) && (isNull(pEntity.getAllowProcessFlag()) || !pEntity.getAllowProcessFlag()) && (isNull(pEntity.getAllowActionFlag()) || !pEntity.getAllowActionFlag()) ) {
					arguments.permissionGroup.removePermission( pEntity );
					this.deletePermission( pEntity );
				// Otherwise Save This Entity
				} else if ((!isNull(pEntity.getAllowCreateFlag()) && pEntity.getAllowCreateFlag()) || (!isNull(pEntity.getAllowReadFlag()) && pEntity.getAllowReadFlag()) || (!isNull(pEntity.getAllowUpdateFlag()) && pEntity.getAllowUpdateFlag()) || (!isNull(pEntity.getAllowDeleteFlag()) && pEntity.getAllowDeleteFlag()) || (!isNull(pEntity.getAllowProcessFlag()) && pEntity.getAllowProcessFlag()) || (!isNull(pEntity.getAllowActionFlag()) && pEntity.getAllowActionFlag())) {
					getAccountDAO().save( pEntity );
					arguments.permissionGroup.addPermission( pEntity );
				}
			}
		}
		
		// Validate the permission group
		arguments.permissionGroup.validate(context='save');
		
		// Setup hibernate session correctly if it has errors or not
		if(!arguments.permissionGroup.hasErrors()) {
			getAccountDAO().save( arguments.permissionGroup );
		}
		
		return arguments.permissionGroup;
	}
	
	public any function saveAccount(required any account, struct data={}) {
		super.save(account,data);
		getAccountDAO().subscribeSend24(account);
		return arguments.account;
	}

	public boolean function deleteAccount(required any account) {
		// delete sessions
		var sessionSmartList = getService('planService').getSessionSmartList();
		sessionSmartList.addFilter("accountAuthentication.account.accountID",arguments.account.getAccountID());
		for(var session in sessionSmartList.getRecords()) {
			getService('planService').deleteSession(session);
		}
		// delete comments
		var commentSmartList = getService('planService').getCommentSmartList();
		commentSmartList.addFilter("createdByAccount.accountID",arguments.account.getAccountID());
		for(var comment in commentSmartList.getRecords()) {
			getService('planService').deleteComment(comment);
		}
		// remove account from checklists
		var clientGroupChecklistSmartList = getService('planService').getClientGroupChecklistSmartList();
		clientGroupChecklistSmartList.addFilter("createdByAccount.accountID",arguments.account.getAccountID(),1);
		clientGroupChecklistSmartList.addFilter("modifiedByAccount.accountID",arguments.account.getAccountID(),2);
		for(var clientGroupChecklist in clientGroupChecklistSmartList.getRecords()) {
			clientGroupChecklist.setCreatedByAccount(javacast("null",""));
			clientGroupChecklist.setModifiedByAccount(javacast("null",""));
		}
		// remove account from checklistAnswers
		var clientGroupChecklistAnswerSmartList = getService('planService').getClientGroupChecklistAnswerSmartList();
		clientGroupChecklistAnswerSmartList.addFilter("createdByAccount.accountID",arguments.account.getAccountID(),1);
		clientGroupChecklistAnswerSmartList.addFilter("modifiedByAccount.accountID",arguments.account.getAccountID(),2);
		for(var clientGroupChecklistAnswer in clientGroupChecklistAnswerSmartList.getRecords()) {
			clientGroupChecklistAnswer.setCreatedByAccount(javacast("null",""));
			clientGroupChecklistAnswer.setModifiedByAccount(javacast("null",""));
		}
		// remove account from client groups
		var clientGroupSmartList = getService('planService').getClientGroupSmartList();
		clientGroupSmartList.addFilter("createdByAccount.accountID",arguments.account.getAccountID(),1);
		clientGroupSmartList.addFilter("modifiedByAccount.accountID",arguments.account.getAccountID(),2);
		for(var clientGroup in clientGroupSmartList.getRecords()) {
			clientGroup.setCreatedByAccount(javacast("null",""));
			clientGroup.setModifiedByAccount(javacast("null",""));
		}
		var deleteOK = super.delete(arguments.account);
		return true;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	public any function getAccountSmartList(struct data={}, currentURL="") {
		arguments.entityName = "PhiaPlanAccount";
		
		var smartList = getHibachiDAO().getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("PhiaPlanAccount", "primaryEmailAddress", "left");
		
		smartList.addKeywordProperty(propertyIdentifier="firstName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="lastName", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="company", weight=1);
		smartList.addKeywordProperty(propertyIdentifier="primaryEmailAddress.emailAddress", weight=1);
		
		return smartList;
	}
	
	public any function getAccountAuthenticationSmartList(struct data={}){
		arguments.entityName = "PhiaPlanAccountAuthentication";
		
		var smartList = this.getSmartList(argumentCollection=arguments);
		
		smartList.joinRelatedProperty("PhiaPlanAccountAuthentication", "account", "left" );
		
		smartList.addKeywordProperty(propertyIdentifier="account.accountID", weight=1 );

		return smartList;
	}
	
	// ====================  END: Smart List Overrides ========================
	
	// ===================== START: Private Helper Functions ==================

	private any function createNewAccountPassword (required any account, required any processObject ){
	
		var existingPasswords = getInternalAccountAuthenticationsByEmailAddress(arguments.account.getPrimaryEmailAddress().getEmailAddress());
		
		if(arguments.account.getAdminAccountFlag() == true){
			
			//Check to see if the password is a duplicate
			var duplicatePasswordCount = checkForDuplicatePasswords(arguments.processObject.getPassword(), existingPasswords);
			
			if(duplicatePasswordCount > 0){
				arguments.processObject.addError('password', rbKey('validate.newPassword.duplicatePassword'));
				
				return arguments.account;
			}
		}
		
		//Because we only want to store 5 passwords, this gets old passwords that put the lenth of the limit.
		if (arrayLen(existingPasswords) >= 4){
			deleteAccountPasswords(arguments, 4);
		}
		
		//Before creating the new password, make sure that all other passwords have an activeFlag of false
		markOldPasswordsInactive(existingPasswords);
		
		//Save the new password
		var accountAuthentication = this.newAccountAuthentication();
		accountAuthentication.setAccount( arguments.account );
		
		// Put the accountAuthentication into the hibernate scope so that it has an id which will allow the hash / salting below to work
		getHibachiDAO().save(accountAuthentication);
	
		// Set the password
		accountAuthentication.setPassword( getHashedAndSaltedPassword(arguments.processObject.getPassword(), accountAuthentication.getAccountAuthenticationID()) );
		
		return arguments.account;
	}
	
	private any function checkForDuplicatePasswords(required any newPassword, required array authArray){
		
		//Initilize variable to store the number of duplicate passwords
		var duplicatePasswordCount = 0;
		
		//Loop over the existing authentications for this account
		for(authentication in arguments.authArray){
			if(!isNull(authentication.getPassword())) {
				//Check to see if the password for this authentication is the same as the one being created
				if(authentication.getPassword() == getHashedAndSaltedPassword(arguments.newPassword, authentication.getAccountAuthenticationID())){
					//Because they are the same add 1 to the duplicatePasswordCount
					duplicatePasswordCount++;
					
				}
			}
		}
		
		return duplicatePasswordCount;
	}
	
	private void function markOldPasswordsInactive(required array authArray){
		testcount = 0;
		for(authentication in arguments.authArray){
			if(!isNull(authentication.getPassword()) && authentication.getActiveFlag() == '1') {
				authentication.setActiveFlag('0');
				testcount = testcount + 1;
			}
		}
	}

	private void function deleteAccountPasswords(required struct data, required any maxAuthenticationsCount ){
		
		//First need to get an array of all the accountAuthentications for this account ordered by creationDateTime ASC
		var accountAuthentications = getAccountAuthenticationSmartList(data=data);
		accountAuthentications.addFilter("account.accountID", arguments.data.Account.getAccountID());
		accountAuthentications.addWhereCondition("aphiaplanaccountauthentication.password IS NOT NULL");
		accountAuthentications.addOrder("createdDateTime|ASC");
		
		//Get the actual records from the SmartList and store in an array
		accountAuthenticationsArray = accountAuthentications.getPageRecords();
		
		//Create a variable to hold the length of the new array
		var numberOfRecordsToBeDeleted = arrayLen(accountAuthenticationsArray) - arguments.maxAuthenticationsCount + 1;

		//Loop through the length of the array until you are under the maxAuthenticationsCount for that Account.	
		for(var i=1; i <= numberOfRecordsToBeDeleted; i++){
			//if the password that is going to be deleted is how the user logged in, updated the session to the new active password
			if( !isNull(getHibachiScope().getSession().getAccountAuthentication()) && accountAuthenticationsArray[i].getAccountAuthenticationID() == getHibachiScope().getSession().getAccountAuthentication().getAccountAuthenticationID()){
				var activePassword = getAccountDAO().getActivePasswordByAccountID(arguments.data.Account.getAccountID());
				getHibachiScope().getSession().setAccountAuthentication(activePassword);
			}
			accountAuthenticationsArray[i].removeAccount();
			// remove this authentication from old session
			getAccountDAO().removeAccountAuthenticationFromAllSessions( accountAuthenticationsArray[i].getAccountAuthenticationID() );
			this.deleteAccountAuthentication( accountAuthenticationsArray[i] );
		}
		
	}

	private boolean function checkPasswordResetRequired(required any accountAuthentication, required any processObject){
		if (accountAuthentication.getUpdatePasswordOnNextLoginFlag() == true 
			|| ( accountAuthentication.getAccount().getAdminAccountFlag() && 
					( dateCompare(Now(), dateAdd('d', variables.passwordResetDays, accountAuthentication.getCreatedDateTime()))  == 1 
					|| !REFind("^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$" , arguments.processObject.getPassword()) 
					|| ( !isNull(accountAuthentication.getCreatedByAccount()) && accountAuthentication.getCreatedByAccount().getAccountID() != accountAuthentication.getAccount().getAccountId())
					)
				)
			)
		{ 
			return true;
		}
				
		return false;	
	}
	// =====================  END:  Private Helper Functions ==================
	
	
} 
