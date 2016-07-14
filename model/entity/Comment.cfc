component displayname="PhiaPlanComment" entityname="PhiaPlanComment" table="Comment" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="commentService" hb_permission="this" {
	
	// Persistent Properties
	property name="commentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="comment" ormtype="string" length="4000" hb_formFieldType="textarea";
	property name="publicFlag" ormtype="boolean";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="commentRelationships" singularname="commentRelationship" cfc="CommentRelationship" type="array" fieldtype="one-to-many" fkcolumn="commentID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="primaryRelationship" persistent="false";
	property name="primaryRelationshipEntity" persistent="false";
	property name="primaryRelationshipEntityName" persistent="false";
	property name="primaryRelationshipSimpleRepresentation" persistent="false";
	property name="commentWithLinks" persistent="false";
	
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getPrimaryRelationship() {
		if(!structKeyExists(variables, "primaryRelationship")) {
			for(var i=1; i<=arrayLen(getCommentRelationships()); i++) {
				if(!getCommentRelationships()[i].getReferencedRelationshipFlag()) {
					variables.primaryRelationship = getCommentRelationships()[i];
					break;
				}
			}
		}
		return variables.primaryRelationship;
	}
	
	public any function getPrimaryRelationshipEntity() {
		if(!structKeyExists(variables, "primaryRelationshipEntity")) {
			variables.primaryRelationshipEntity = getPrimaryRelationship().getRelationshipEntity();
		}
		return variables.primaryRelationshipEntity;
	}
	
	public any function getPrimaryRelationshipEntityName() {
		if(!structKeyExists(variables, "primaryRelationshipEntityName")) {
			variables.primaryRelationshipEntityName = reReplace(getPrimaryRelationship().getRelationshipEntity().getEntityName(),'PhiaPlan','');
		}
		return variables.primaryRelationshipEntityName;
	}
	
	public any function getPrimaryRelationshipSimpleRepresentation() {
		if(!structKeyExists(variables, "primaryRelationshipSimpleRepresentation")) {
			variables.primaryRelationshipSimpleRepresentation = getPrimaryRelationshipEntityName() & ' : ' & getPrimaryRelationship().getRelationshipEntity().getSimpleRepresentation();
		}
		return variables.primaryRelationshipSimpleRepresentation;
	}
	
	public string function getCommentWithLinks() {
		if(!structKeyExists(variables, "commentWithLinks")) {
			variables.commentWithLinks = getService("commentService").getCommentWithLinks(comment=this);
		}
		return variables.commentWithLinks;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Comment Relationships (one-to-many)
	public void function addCommentRelationship(required any commentRelationship) {
		arguments.commentRelationship.setComment( this );
	}
	public void function removeCommentRelationship(required any commentRelationship) {
		arguments.commentRelationship.removeComment( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return getCreatedByAccount().getFullName() & " - " & getFormattedValue("createdDateTime");
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}