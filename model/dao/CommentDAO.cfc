<cfcomponent extends="HibachiDAO" output="false">
	
	<cffunction name="getRelatedCommentsForEntity" returntype="Array" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		<cfargument name="filterData" type="struct" required="false" />
		
			<cfset var sql = "SELECT NEW MAP(
				cr.commentRelationshipID as commentRelationshipID,
				cr.referencedRelationshipFlag as referencedRelationshipFlag,
				cr.referencedExpressionStart as referencedExpressionStart,
				cr.referencedExpressionEnd as referencedExpressionEnd,
				cr.referencedExpressionEntity as referencedExpressionEntity,
				cr.referencedExpressionProperty as referencedExpressionProperty,
				cr.referencedExpressionValue as referencedExpressionValue,
				c as comment
			)
			FROM
				PhiaPlanCommentRelationship cr INNER JOIN cr.comment c WHERE cr.#left(arguments.primaryIDPropertyName,len(arguments.primaryIDPropertyName)-2)#.#arguments.primaryIDPropertyName# = ?" />
			
			<cfif structKeyExists(arguments,"filterData")>
				<cfloop collection="#filterData#" item="local.item">
					<cfset sql &= " AND #local.item# = '#filterData[local.item]#' "/>
				</cfloop>
			</cfif>

			<cfset var results = ormExecuteQuery(sql, [arguments.primaryIDValue]) />
		
		<cfreturn results /> 
	</cffunction>
	
	
	<cffunction name="deleteAllRelatedComments" returntype="boolean" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		
		<cfset var relatedComments = getRelatedCommentsForEntity(argumentcollection=arguments) />
		<cfset var relatedComment = "" />
		
		<cfloop array="#relatedComments#" index="relatedComment" >
			<cfset var results = ormExecuteQuery("DELETE PhiaPlanCommentRelationship WHERE commentRelationshipID = ?", [relatedComment["commentRelationshipID"]]) />
			
			<cfif not relatedComment["referencedRelationshipFlag"]>
				<cfset var results = ormExecuteQuery("DELETE PhiaPlanComment WHERE commentID = ?", [relatedComment["comment"].getCommentID()]) />
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>