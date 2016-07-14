<cfparam name="rc.comment" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfset local.returnActionQueryString = "" />
<cfset local.hiddenKeyFields = "" />
<cfset local.lastIndex = 0 />

<cfloop collection="#rc#" item="local.key" >
	<cfif local.key neq "settingID" and right(local.key, 2) eq "ID" and isSimpleValue(rc[local.key]) and len(rc[local.key]) gt 30>
		<cfset local.lastIndex++ />
		<cfset local.returnActionQueryString = listAppend(local.returnActionQueryString, '#local.key#=#rc[local.key]#', '&') />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].commentRelationshipID" value="" />', chr(13)) />
		<cfset local.hiddenKeyFields = listAppend(local.hiddenKeyFields, '<input type="hidden" name="commentRelationships[#local.lastIndex#].#left(local.key, len(local.key)-2)#.#local.key#" value="#rc[local.key]#" />', chr(13)) />	
	</cfif>
</cfloop>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.comment#" edit="#rc.edit#" saveActionQueryString="#local.returnActionQueryString#" saveActionHash="tabComments">
		<cf_HibachiEntityActionBar type="detail" object="#rc.comment#" />
		
		<!--- Only Runs if new --->
		<Cfif rc.comment.isNew()>#local.hiddenKeyFields#</cfif>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.comment#" property="publicFlag" edit="#rc.edit#">
				<cfif !rc.comment.isNew()>
					<cf_HibachiPropertyDisplay object="#rc.comment#" property="createdDateTime">
					<cf_HibachiPropertyDisplay object="#rc.comment#" property="createdByAccount">
				</cfif>
				<hr />
				<cf_HibachiPropertyDisplay object="#rc.comment#" property="comment" displaytype="plain" edit="#rc.comment.isNew()#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>