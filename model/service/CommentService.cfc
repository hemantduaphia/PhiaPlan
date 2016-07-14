component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="commentDAO" type="any";
	
	public void function parseCommentAndCreateRelationships(required any comment) {
		
	}
	
	public string function getCommentWithLinks(required any comment) {
		var returnCommentArray = listToArray(arguments.comment.getComment(), " ");
		
		if(arguments.comment.getCommentRelationshipsCount() gt 1) {
			for(var i=1; i<=arrayLen(arguments.comment.getCommentRelationships()); i++) {
				var relationship = arguments.comment.getCommentRelationships()[i];
				if(relationship.getReferencedRelationshipFlag()) {
					returnCommentArray[ relationship.getReferencedExpressionStart() ] = '<a href="?PPAction=admin:comment.link&entity=#relationship.getReferencedExpressionEntity()#&property=#relationship.getReferencedExpressionProperty()#&value=#relationship.getReferencedExpressionValue()#">' & returnCommentArray[ relationship.getReferencedExpressionStart() ];
					returnCommentArray[ relationship.getReferencedExpressionEnd() ] = returnCommentArray[ relationship.getReferencedExpressionEnd() ]  & '</a>';
				}
			}	
		}
		
		return arrayToList(returnCommentArray, " ");
	}
		
	public boolean function removeAllEntityRelatedComments(required any entity) {
		var properties = arguments.entity.getProperties();
		
		for(var p=1; p<=arrayLen(properties); p++) {
			if(structKeyExists(properties[p], "fieldType") && properties[p].fieldType eq "one-to-many" && structKeyExists(properties[p], "cascade") && properties[p].cascade eq "all-delete-orphan" && structKeyExists(properties[p], "cfc") && getHasPropertyByEntityNameAndPropertyIdentifier('CommentRelationship', properties[p].cfc)) {
				var subItems = arguments.entity.invokeMethod("get#properties[p].name#");
				for(var s=1; s<=arrayLen(subItems); s++) {
					removeAllEntityRelatedComments(subItems[s]);
				}
			}
		}
		
		
		if(getHasPropertyByEntityNameAndPropertyIdentifier('CommentRelationship', arguments.entity.getClassName())) {
			return getCommentDAO().deleteAllRelatedComments(primaryIDPropertyName=arguments.entity.getPrimaryIDPropertyName(), primaryIDValue=arguments.entity.getPrimaryIDValue());	
		}
		return true;
	}
	
	// ===================== START: Logical Methods ===========================
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	public array function getRelatedCommentsForEntity(required string primaryIDPropertyName, required string primaryIDValue) {
		return getCommentDAO().getRelatedCommentsForEntity(argumentCollection=arguments);
	}
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	
	public any function saveComment(required any comment, required any data) {
		
		arguments.comment.populate( arguments.data );
		
		parseCommentAndCreateRelationships( arguments.comment );
		
        return super.save(arguments.comment);
	}
	
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}
