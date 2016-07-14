<cfif isDefined("planDocumentChecklistSectionID")>
	<cfset object = $.PhiaPlan.getService("hibachiService").getPlanDocumentChecklistSection(planDocumentChecklistSectionID) />
<cfelseif isDefined("questionID")>
	<cfset object = $.PhiaPlan.getService("hibachiService").getQuestion(questionID) />
<cfelseif isDefined("clientID")>
	<cfset object = $.PhiaPlan.getService("hibachiService").getClient(clientID) />
</cfif>
<cfset filterData = {"c.publicFlag"=1} />
<cfif structKeyExists(rc,"clientGroupChecklistID")>
	<cfset filterData["cr.clientGroupChecklist.clientGroupChecklistID"] = rc.clientGroupChecklistID />
</cfif>

<cfoutput>
<div id="tabComments">
	<cfif arraylen(object.getComments(filterData=filterData))>
		<cfloop array="#object.getComments(filterData=filterData)#" index="commentRelationship">
			<cfif commentRelationship['comment'].getPublicFlag()>
				<div class="tabCommentContainer">
					#commentRelationship['comment'].getCommentWithLinks()#
					<div align="right" style="font-style: italic;">
						<cfif !isNull(commentRelationship['comment'].getCreatedByAccount())>Posted by #commentRelationship['comment'].getCreatedByAccount().getFullName()#</cfif> on <cfif !isNull(commentRelationship['comment'].getModifiedDateTime()) AND isDate(commentRelationship['comment'].getModifiedDateTime())>#$.PhiaPlan.formatValue(commentRelationship['comment'].getModifiedDateTime(), "datetime")#<cfelse>#$.PhiaPlan.formatValue(commentRelationship['comment'].getCreatedDateTime(), "datetime")#</cfif>
						<a class="editCommentBtn" href="javascript:$('##editCommentModal .modal-body').load('?previewonly=true&PPAction=entity.editcomment&commentID=#commentRelationship['comment'].getCommentID()#',function(e){$('##editCommentModal').modal('show');});void(0);">edit</a>
					</div>
				</div>
			</cfif>
		</cfloop>
	<cfelse>
		<div>
			No comments.
		</div>
	</cfif>
</div>
</cfoutput>

<script>
	$(".editCommentBtn").click(function() {
		$('#viewCommentModal').modal('hide');
	});	
</script>