<!--- You can pass in a object, or just an array of errors --->
<cfparam name="attributes.object" type="any" default="" />
<cfparam name="attributes.errors" type="array" default="#arrayNew(1)#" />

<cfparam name="attributes.errorName" type="string" default="" />
<cfparam name="attributes.displayType" type="string" default="label" />
<cfparam name="attributes.for" type="string" default="" />

<cfif thisTag.executionMode is "start">
	<cfsilent>
		<cfif not arrayLen(attributes.errors) && isObject(attributes.object)>
			<cfif not len(attributes.errorName)>
				<cfloop collection="#attributes.object.getErrors()#" item="errorName">
					<cfloop array="#attributes.object.getErrors()[errorName]#" index="thisError">
						<cfset arrayAppend(attributes.errors, thisError) />
					</cfloop>
				</cfloop>
			<cfelse>
				<cfif attributes.object.hasError( attributes.errorName )>
					<cfset attributes.errors = attributes.object.getError( attributes.errorName ) />
				</cfif>
			</cfif>
		</cfif>
	</cfsilent>
	<cfif arrayLen(attributes.errors)>
		<cfswitch expression="#attributes.displaytype#">
			<!--- LABEL Display --->
			<cfcase value="label">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><label <cfif len(attributes.for)>for="#attributes.for#"</cfif> class="text-error error">#error#</label></cfoutput>
				</cfloop>
			</cfcase>
			<!--- DIV Display --->
			<cfcase value="div">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><div class="text-error error">#error#</div></cfoutput>
				</cfloop>
			</cfcase>
			<!--- P Display --->
			<cfcase value="p">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><p class="text-error error">#error#</p></cfoutput>
				</cfloop>
			</cfcase>
			<!--- BR Display --->
			<cfcase value="br">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput>#error#<br /></cfoutput>
				</cfloop>
			</cfcase>
			<!--- SPAN Display --->
			<cfcase value="span">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><span class="text-error error">#error#</span></cfoutput>
				</cfloop>
			</cfcase>
			<!--- LI Display --->
			<cfcase value="li">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput><li class="text-error error">#error#</li></cfoutput>
				</cfloop>
			</cfcase>
			<!--- None Display --->
			<cfcase value="none">
				<cfloop array="#attributes.errors#" index="error">
					<cfoutput>#error#</cfoutput>
				</cfloop>
			</cfcase>
		</cfswitch>	
	</cfif>
</cfif>
