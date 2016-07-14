<cfparam name="rc.commentSmartList" type="any" />

<cfoutput>
	<cf_HibachiMessageDisplay />
	
	<div class="row-fluid">
		<div class="span12">
			<h5>New Comments</h5>
			<cfset rc.commentSmartList = $.phiaplan.getService('planService').getCommentRelationshipSmartList() />
			<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","comment") />
			<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","clientGroupChecklist") />
			<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanClientGroupChecklist","checklist") />
			<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanChecklist","client") />
			<cfset rc.commentSmartList.joinRelatedProperty("PhiaPlanCommentRelationship","question") />
			<cfset rc.commentSmartList.addRange('comment.createdDateTime','#dateFormat(dateAdd('d','-30',now()))#^') />
			<cfset rc.commentSmartList.addOrder("comment.createdDateTime|DESC") />
			<cfset rc.commentSmartList.applyData({"p:show"="5"}) />
			<cfoutput>
				<cf_HibachiListingDisplay smartList="#rc.commentSmartList#">
					<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.checklist.client.clientName" filter="false" />
					<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment.comment" filter="false" />
					<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklist.clientGroupChecklistName" filter="false" actionCallerAttributes="#{action='admin:entity.detailClientGroupChecklist',queryString='clientGroupChecklistID=${clientGroupChecklist.clientGroupChecklistID}'}#" />
					<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="comment.primaryRelationshipSimpleRepresentation" />
					<cf_HibachiListingColumn propertyIdentifier="question.questionCode" filter="false" />
					<cf_HibachiListingColumn propertyIdentifier="comment.createdDateTime" />
					<cf_HibachiListingColumn propertyIdentifier="comment.createdByAccount.firstname" filter="false" />
					<cf_HibachiListingColumn propertyIdentifier="comment.createdByAccount.lastname" filter="false" />
				</cf_HibachiListingDisplay>
			</cfoutput>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 tableWrap">
			<h5>Flagged Questions</h5>
			<cfset flaggedQuestionSmartList = $.phiaPlan.getService('planService').getViewClientGroupChecklistFlaggedQuestionSmartList() />
			<cf_HibachiListingDisplay smartList="#flaggedQuestionSmartList#">
				<cf_HibachiListingColumn propertyIdentifier="clientName" title="Client" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="clientGroupName" title="Group" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" search="false" filter="false" sort="false" actionCallerAttributes="#{action='admin:entity.detailClientGroupChecklist',queryString='clientGroupChecklistID=${clientGroupChecklistID}'}#"  />
				<cf_HibachiListingColumn propertyIdentifier="questionCode" title="Question Code" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="questionText" title="Question" tdclass="primary" search="false" filter="false" sort="false"  />
			</cf_HibachiListingDisplay>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 tableWrap">
			<h5>Recent Submitted Checklists</h5>
			<cfset submittedClientGroupChecklistSmartList = $.phiaPlan.getService('planService').getClientGroupChecklistSmartList() />
			<cfset submittedClientGroupChecklistSmartList.addFilter('checklistStatus.systemCode','cgcsClosed') />
			<cfset submittedClientGroupChecklistSmartList.addRange('modifiedDateTime','#dateFormat(dateAdd('d','-30',now()))#^') />
			<cf_HibachiListingDisplay smartList="#submittedClientGroupChecklistSmartList#" 
					recordDetailAction="admin:entity.detailclientgroupchecklist">
				
				<cf_HibachiListingColumn propertyIdentifier="clientGroup.client.clientName" title="Client" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="clientGroup.clientGroupName" title="Group" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" tdclass="primary" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="createdDateTime" range="false" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="modifiedDateTime" range="false" search="false" filter="false" sort="false"  />
			</cf_HibachiListingDisplay>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 tableWrap">
			<h5>Recent Client Checklists</h5>
			<cfset rc.clientGroupChecklistSmartList.addRange('createdDateTime','#dateFormat(dateAdd('d','-30',now()))#^') />
			<cf_HibachiListingDisplay smartList="#rc.clientGroupChecklistSmartList#" 
					recordDetailAction="admin:entity.detailclientgroupchecklist">
				
				<cf_HibachiListingColumn propertyIdentifier="clientGroup.client.clientName" title="Client" search="false" filter="false" sort="false" actionCallerAttributes="#{action='admin:entity.detailclient',queryString='clientID=${clientgroup.client.clientID}'}#"   />
				<cf_HibachiListingColumn propertyIdentifier="clientGroup.clientGroupName" title="Group" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="checklist.checklistName" title="Master Checklist" search="false" filter="false" sort="false" actionCallerAttributes="#{action='admin:entity.detailchecklist',queryString='checklistID=${checklist.checklistID}'}#" />
				<cf_HibachiListingColumn propertyIdentifier="clientGroupChecklistName" title="Checklist" tdclass="primary" search="false" filter="false" sort="false" />
				<cf_HibachiListingColumn propertyIdentifier="createdDateTime" range="false" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="modifiedDateTime" range="false" search="false" filter="false" sort="false"  />
			</cf_HibachiListingDisplay>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12 tableWrap">
			<h5>Recent Client Groups</h5>
			<cfset rc.clientGroupSmartList.addRange('createdDateTime','#dateFormat(dateAdd('d','-30',now()))#^') />
			<cf_HibachiListingDisplay smartList="#rc.clientGroupSmartList#" 
					recordDetailAction="admin:entity.detailclientgroup">
				
				<cf_HibachiListingColumn propertyIdentifier="client.clientName" title="Client" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="clientGroupName" title="Group" tdclass="primary" search="false" filter="false" sort="false"  />
				<cf_HibachiListingColumn propertyIdentifier="createdDateTime" search="false" range="false" filter="false" sort="false"  />
			</cf_HibachiListingDisplay>
		</div>
	</div>
	
	<!---<style>
		.tableWrap .table td { white-space: normal; font-size: 12px; }
	</style>--->
</cfoutput>
