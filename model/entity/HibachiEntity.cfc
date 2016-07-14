component extends="PhiaPlan.org.Hibachi.HibachiEntity" {

	// Put any custom logic that you would like to have available in all Entity objects.
	// Also, override any of the BaseEntity methods that are in Hibachi

	// @hint Returns an array of comments related to this entity
	public array function getComments() {
		if(!structKeyExists(variables, "comments")) {
			param name="arguments.filterData" default="#structNew()#";
			variables.comments = getService("commentService").getRelatedCommentsForEntity(primaryIDPropertyName=getPrimaryIDPropertyName(), primaryIDValue=getPrimaryIDValue(), filterData=filterData);
		}
		return variables.comments;
	}


}