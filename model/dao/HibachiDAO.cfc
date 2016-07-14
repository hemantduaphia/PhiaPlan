component extends="PhiaPlan.org.Hibachi.HibachiDAO" {

	// Put any custom logic that you would like to have available in all DAO objects.
	// Also, override any of the BaseDAO methods that are in Hibachi

	public any function getExportQuery(required string entityName) {
		// removes the Applicatoin Prefix to the entityName when needed.
		if(left(arguments.entityName, len(getApplicationKey()) ) == getApplicationKey()) {
			arguments.entityName = "#replacenocase(arguments.entityName,getApplicationKey(),"")#";
		}
		
		var qry = new query();
		qry.setName("exportQry");
		var result = qry.execute(sql="SELECT * FROM #arguments.entityName#"); 
    	exportQry = result.getResult(); 
		return exportQry;
	}
		
}