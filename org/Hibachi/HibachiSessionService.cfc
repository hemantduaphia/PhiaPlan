component output="false" accessors="true" extends="HibachiService"  {

	property name="accountService" type="any";
	property name="orderService" type="any";
	property name="hibachiTagService" type="any";
	property name="accountDAO" type="any";

	variables.logoutAfterXMinutes = 60;
	
	// ===================== START: Logical Methods ===========================
	
	public void function setPropperSession() {
		var sessionFoundWithCookie = false;
		
		// Check to see if a session value doesn't exist, then we can check for a cookie... or just set it to blank
		if(!hasSessionValue("sessionID")) {
			setSessionValue('sessionID', '');
			if(structKeyExists(cookie, "#getApplicationValue('applicationKey')#SessionID")) {
				setSessionValue('sessionID', cookie["#getApplicationValue('applicationKey')#SessionID"]);
				sessionFoundWithCookie = true;
			}
		}
		
		// Load Session
		var sessionEntity = this.getSession(getSessionValue('sessionID'), true);
		getHibachiScope().setSession( sessionEntity );
		
		// Variable to store the last request dateTime of a session
		var previousRequestDateTime = getHibachiScope().getSession().getLastRequestDateTime();
		
		
		// Update the last request datetime, and IP Address
		getHibachiScope().getSession().setLastRequestDateTime( now() );
		getHibachiScope().getSession().setLastRequestIPAddress( CGI.REMOTE_ADDR );
		
		// Save the session
		getHibachiDAO().save( getHibachiScope().getSession() );
		
		// Save session ID in the session Scope & cookie scope for next request
		setSessionValue('sessionID', getHibachiScope().getSession().getSessionID());
		getHibachiTagService().cfcookie(name="#getApplicationValue('applicationKey')#SessionID", value=getHibachiScope().getSession().getSessionID(), expires="never");
		
		// If the session has an account but no authentication, then remove the account
		// Check to see if this session has an accountAuthentication, if it does then we need to verify that the authentication shouldn't be auto logged out
		// If there was an integration, then check the verify method for any custom auto-logout logic
		if((sessionFoundWithCookie && getHibachiScope().getLoggedInFlag()) 
			|| (!isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getSession().getAccountAuthentication().getForceLogoutFlag()) 
			|| (isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getLoggedInFlag())
			|| (!isNull(getHibachiScope().getSession().getAccountAuthentication()) && getHibachiScope().getSession().getAccount().getAdminAccountFlag() == true && DateDiff('n', previousRequestDateTime, Now()) >= variables.logoutAfterXMinutes ) )
			{	
				logoutAccount();
		}
	}
	
	public string function loginAccount(required any account, required any accountAuthentication) {
		var currentSession = getHibachiScope().getSession();
		
		currentSession.setAccount( arguments.account );
		currentSession.setAccountAuthentication( arguments.accountAuthentication );
		
		// Make sure that this login is persisted
		getHibachiDAO().flushORMSession();
		
		getHibachiEventService().announceEvent("onSessionAccountLogin");
	}
	
	public void function logoutAccount() {
		var currentSession = getHibachiScope().getSession();
		
		currentSession.removeAccount();
		currentSession.removeAccountAuthentication();
		
		// Make sure that this logout is persisted
		getHibachiDAO().flushORMSession();
		
		getHibachiEventService().announceEvent("onSessionAccountLogout");
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}