component extends="org.Hibachi.Hibachi" {
	
	this.sessionTimeout = createTimeSpan( 0, 10, 0, 0 );
	
	// @hint this method always fires one time, even if the request is coming from an outside application.
	public void function onEveryRequest() {
		
	}
	
	// @hint this will fire 1 time if you are running the application.  If the application is bootstraped then it won't run
	public void function onInternalRequest() {
		
	}
	
	// @hint this will fire on every application reload, or when the server boots up for the first time
	public void function onFirstRequest() {
		
	}
	
	// @hint this will only fire on an update request where ORM is reloaded
	public void function onUpdateRequest() {
		
	}

	// ===================================== FW1 HOOKS
	
	// Allows for integration services to have a seperate directory structure
	public any function getSubsystemDirPrefix( string subsystem ) {
		if ( arguments.subsystem eq '' ) {
			return '';
		}
		return arguments.subsystem & '/';
	}
	
	// ===================================== END: FW1 HOOKS

}