component output="false" accessors="true" extends="PhiaPlan.org.Hibachi.HibachiScope" {

	// This is your request scope object that you can put all api logic inside.
	// This will be created new on every request, and specificed as request.{applicationNamespace}Scope

	public any function replaceStringTemplatePhia(required string template,required string clientGroupChecklistID,string defaultValue="",boolean highlightReplacement=false) {
		return getService("hibachiUtilityService").replaceStringTemplatePhia(template,clientGroupChecklistID,defaultValue,highlightReplacement);
	}
	
	public any function getDisableCommentFlag() {
		if(!isNull(getAccount().getClient()) && !isNull(getAccount().getClient().getDisableCommentFlag()) && getAccount().getClient().getDisableCommentFlag()) {
			return true;
		}
		return false;
	}
	
	public any function getAllowCreateCommentFlag() {
		return getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.createcomment',getAccount());;
	}
	
}