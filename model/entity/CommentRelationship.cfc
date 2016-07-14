component displayname="Comment Relationship" entityname="PhiaPlanCommentRelationship" table="CommentRelationship" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="commentService" hb_permission="comment.commentRelationships" {
	
	// Persistent Properties
	property name="commentRelationshipID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="referencedRelationshipFlag" ormtype="boolean" default="false";
	property name="referencedExpressionStart" ormtype="integer";
	property name="referencedExpressionEnd" ormtype="integer";
	property name="referencedExpressionEntity" ormtype="string";
	property name="referencedExpressionProperty" ormtype="string";
	property name="referencedExpressionValue" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="comment" cfc="Comment" fieldtype="many-to-one" fkcolumn="commentID";
	
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="client" cfc="Client" fieldtype="many-to-one" fkcolumn="clientID";
	property name="checklist" cfc="Checklist" fieldtype="many-to-one" fkcolumn="checklistID";
	property name="checklistSection" cfc="ChecklistSection" fieldtype="many-to-one" fkcolumn="checklistSectionID";
	property name="planDocumentTemplate" cfc="PlanDocumentTemplate" fieldtype="many-to-one" fkcolumn="planDocumentTemplateID";
	property name="planDocumentChecklistSection" cfc="PlanDocumentChecklistSection" fieldtype="many-to-one" fkcolumn="planDocumentChecklistSectionID";
	property name="question" cfc="Question" fieldtype="many-to-one" fkcolumn="questionID";
	property name="clientGroupChecklist" cfc="ClientGroupChecklist" fieldtype="many-to-one" fkcolumn="clientGroupChecklistID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	
	// Audit Properties
	
	// Non-Persistent Properties
	property name="relationshipEntity" persistent="false";
	
	public any function getRelationshipEntity() {
		if(!isNull(getAccount())) {
			return getAccount();
		} else if (!isNull(getClient())) {
			return getClient();
		} else if (!isNull(getChecklist())) {
			return getChecklist();
		} else if (!isNull(getChecklistSection())) {
			return getChecklistSection();
		} else if (!isNull(getPlanDocumentTemplate())) {
			return getPlanDocumentTemplate();
		} else if (!isNull(getPlanDocumentChecklistSection())) {
			return getPlanDocumentChecklistSection();
		} else if (!isNull(getQuestion())) {
			return getQuestion();
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Comment (many-to-one)
	public void function setComment(required any comment) {
		variables.comment = arguments.comment;
		if(isNew() or !arguments.comment.hasCommentRelationship( this )) {
			arrayAppend(arguments.comment.getCommentRelationships(), this);
		}
	}
	public void function removeComment(any comment) {
		if(!structKeyExists(arguments, "comment")) {
			arguments.comment = variables.comment;
		}
		var index = arrayFind(arguments.comment.getCommentRelationships(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.comment.getCommentRelationships(), index);
		}
		structDelete(variables, "comment");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "commentRelationshipID";
	}
	
	public string function getSimpleRepresentation() {
		return getComment().getCreatedByAccount().getFullName() & " - " & getComment().getFormattedValue("createdDateTime");
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
		
	// ===================  END:  ORM Event Hooks  =========================
}