

<cfparam name="rc.comment" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.returnAction" default="" />

<cfset local.sRedirectAction = "" />
<cfset local.returnActionQueryString = "" />
<cfset local.hiddenKeyFields = "" />
<cfset local.lastIndex = 0 />

<cfloop collection="#rc#" item="local.key" >
	<cfif local.key neq "settingID" and right(local.key, 2) eq "ID" and isSimpleValue(rc[local.key]) and len(rc[local.key]) gt 30 and local.key NEQ "clientGroupChecklistID">
		<cfset local.lastIndex++ />
		<cfset local.returnActionQueryString = listAppend(local.returnActionQueryString, '#local.key#=#rc[local.key]#', '&') />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].commentRelationshipID" value="" />', chr(13)) />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />	
	</cfif>
	<cfif local.key EQ "clientGroupChecklistID">
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />	
	</cfif>
</cfloop>
<cfloop array="#listToArray(urlDecode(rc.returnAction),'&')#" index="item">
	<cfif listFirst(item,"=") EQ "PPAction">
		<cfset local.sRedirectAction = listLast(item,"=") />
	<cfelse>
		<cfset local.returnActionQueryString = listAppend(local.returnActionQueryString, '#listFirst(item,"=")#=#listLast(item,"=")#', '&') />
	</cfif>
</cfloop>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.comment#" edit="#rc.edit#" saveActionQueryString="#local.returnActionQueryString#" sRedirectAction="#local.sRedirectAction#">
		
		<!--- Only Runs if new --->
		<cfif rc.comment.isNew()>#local.hiddenKeyFields#</cfif>
		<input type="hidden" name="publicFlag" value="1" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.comment#" property="comment" displaytype="plain" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>

		<span id="commentAlert" class="btn btn-primary">Save</span>

		<script>
			$().ready(function() { 
				$('##commentAlert').click(function() {
					$.ajax({
						type: "POST",
						url: "?#cgi.QUERY_STRING#",
						data: $(".form-horizontal").serialize(),
						beforeSend: function(){
							$('.modal-body .container').html('');
							$('.modal-body .container').html('<img src="/assets/images/loader.gif" /> Saving...');
						},
						success: function(data){
							<cfif StructKeyExists(url,"questionID")>
								var tmpQuestionID = '#url.questionID#';
							<cfelseif StructKeyExists(url,"planDocumentChecklistSectionID")>
								var tmpQuestionID = '#url.planDocumentChecklistSectionID#';
							<cfelseif StructKeyExists(url,"clientID")> 	
								var tmpQuestionID = '#url.clientID#';
							</cfif>
							// $('##successBlock').html(data);
							$('.modal-body .container').html('<a class="closeCommentPost" data-dismiss="modal">Comment Posted!</a>');
							$('.modal-body .container ##modalSuccessClose').css("display", "block");
							
							<cfif rc.comment.isNew()>
								var commentCountNumber = parseInt($('##cCount-' + tmpQuestionID).text(), 10);
								commentCountNumber = commentCountNumber + 1;
								$('##cCount-' + tmpQuestionID).text(commentCountNumber);
							</cfif>
							
						}
						
					});

				});	
			});
		</script>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>