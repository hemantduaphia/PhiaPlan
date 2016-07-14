<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.fieldType" type="string" />
	<cfparam name="attributes.fieldName" type="string" />
	<cfparam name="attributes.fieldClass" type="string" default="" />
	<cfparam name="attributes.value" type="any" default="" />
	<cfparam name="attributes.valueOptions" type="array" default="#arrayNew(1)#" />
	<cfparam name="attributes.valueOptionsSmartList" type="any" default="" />
	<cfparam name="attributes.fieldAttributes" type="string" default="" />
	<cfparam name="attributes.modalCreateAction" type="string" default="" />			<!--- hint: This allows for a special admin action to be passed in where the saving of that action will automatically return the results to this field --->
	<cfparam name="attributes.questionID" type="string" default="" />
	<cfparam name="attributes.questionCode" type="string" default="" />
	<cfparam name="attributes.questionHint" type="string" default="" />
	<cfparam name="attributes.excludedQuestionStruct" type="struct" default="#structNew()#" />
	<cfparam name="attributes.questionDefaultValue" type="string" default="" />
		
	<cfparam name="attributes.autocompletePropertyIdentifiers" type="string" default="" />
	<cfparam name="attributes.autocompleteNameProperty" type="string" default="" />
	<cfparam name="attributes.autocompleteValueProperty" type="string" default="" /> 
	<cfparam name="attributes.autocompleteSelectedValueDetails" type="struct" default="#structNew()#" />
	<!---
		attributes.fieldType have the following options:
		
		checkbox			|	As a single checkbox this doesn't require any options, but it will create a hidden field for you so that the key gets submitted even when not checked.  The value of the checkbox will be 1
		checkboxgroup		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		date				|	This is still just a textbox, but it adds the jQuery date picker
		dateTime			|	This is still just a textbox, but it adds the jQuery date & time picker
		file				|	No value can be passed in
		multiselect			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		password			|	No Value can be passed in
		radiogroup			|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		select      		|	Requires the valueOptions to be an array of simple value if name and value is same or array of structs with the format of {value="", name=""}
		text				|	Simple Text Field
		textarea			|	Simple Textarea
		time				|	This is still just a textbox, but it adds the jQuery time picker
		wysiwyg				|	Value needs to be a string
		yesno				|	This is used by booleans and flags to create a radio group of Yes and No
		hidden				|	This is used mostly for processing
	--->
		
	<cfset $ = caller.$ />
	<cfsilent>
		<cfloop collection="#attributes#" item="key">
			<cfif left(key,5) eq "data-">
				<cfset attributes.fieldAttributes = listAppend(attributes.fieldAttributes, "#key#=#attributes[key]#", " ") />
			</cfif>
		</cfloop>
	</cfsilent>

	<cfswitch expression="#attributes.fieldType#">
		<cfcase value="hidden">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="#attributes.value#" />
			</cfoutput>
		</cfcase>
		<cfcase value="checkbox">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				<input type="checkbox" name="#attributes.fieldName#" value="1" class="#attributes.fieldClass#" <cfif attributes.value EQ "1"> checked="checked"</cfif> #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="Check Box Group">
			<cfoutput>
				<input type="hidden" name="#attributes.fieldName#" value="" />
				
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<cfset thisOptionHint = isSimpleValue(option) ? option : structKeyExists(option, 'answerHint') ? structFind(option, 'answerHint') : '' />
					
					<div class="questionField">
					<cfif thisOptionHint NEQ "">
						<a href="##option_#attributes.questionID#_#thisOptionValue#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_#thisOptionValue#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#thisOptionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>
						
						<div class="questionContent">
							<label class="checkbox">
								<input type="checkbox" id="#option["questionAnswerID"]#" name="#attributes.fieldName#" value="#thisOptionValue#" data-questionid="#lcase(attributes.questionID)#" <cfif listFindNoCase(attributes.value, thisOptionValue)> checked="checked"</cfif> #attributes.fieldAttributes# />
								#listgetat(thisOptionName,'1','|')#
							</label>
						</div>
					</div>
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="date">
			<cfif Not isDate(attributes.value)>
				<cfset attributes.value = "" />
			</cfif>
			<cfoutput>
				<div class="questionField">
					<cfif attributes.questionHint NEQ "">
						<a href="##option_#attributes.questionID#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#attributes.questionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>
					<div class="questionContent">
						<input type="text" name="#attributes.fieldName#" value="#dateformat(attributes.value,'mmmm dd, yyyy')#" class="#attributes.fieldClass# datepickCustom" #attributes.fieldAttributes# />
					</div>
				</div>			
			</cfoutput>				
		</cfcase>
		<cfcase value="dateTime">
			<cfoutput>
				<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# datetimepicker" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="file">
			<cfoutput>
				<input type="file" name="#attributes.fieldName#" class="#attributes.fieldClass#" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="listingMultiselect">
			<cf_SlatwallListingDisplay smartList="#attributes.valueOptionsSmartList#" multiselectFieldName="#attributes.fieldName#" multiselectFieldClass="#attributes.fieldClass#" multiselectvalues="#attributes.value#" edit="true"></cf_SlatwallListingDisplay>
		</cfcase>
		<cfcase value="multiselect">
			<cfoutput>
				<input name="#attributes.fieldName#" type="hidden" value="" />
				<div class="questionField">
					<!---<cfif attributes.questionHint NEQ "">
						<a href="##option_#attributes.questionID#_#thisOptionValue#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_#thisOptionValue#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#thisOptionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>--->
					<div class="questionContent">
						<select name="#attributes.fieldName#" size="10" class="#attributes.fieldClass# multiselect" multiple="multiple" #attributes.fieldAttributes#>
							<cfloop array="#attributes.valueOptions#" index="option">
								<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
								<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
								<option value="#thisOptionValue#" <cfif listFindNoCase(attributes.value, thisOptionValue)> selected="selected"</cfif>>#thisOptionName#</option>
							</cfloop>
						</select>
					</div>					
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="password">
			<cfoutput>
				<input type="password" name="#attributes.fieldName#" class="#attributes.fieldClass#" autocomplete="off" #attributes.fieldAttributes# />
			</cfoutput>
		</cfcase>
		<cfcase value="Radio Group">
			<cfoutput>
				<!--- if attributes.value is not a valid option default to first one, Array find can't find empty value so we need to loop through --->
				<cfset valueExists = false />
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option)?option:option['value'] />
					<cfif thisOptionValue EQ attributes.value>
						<cfset valueExists = true />
						<cfbreak />
					</cfif>
				</cfloop>
				<!---<cfif !valueExists>
					<cfset attributes.value = attributes.valueOptions[1]['value'] />
				</cfif>--->
				<cfloop array="#attributes.valueOptions#" index="option">
					<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
					<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
					<cfset thisOptionHint = isSimpleValue(option) ? option : structKeyExists(option, 'answerHint') ? structFind(option, 'answerHint') : '' />
					
					<div class="questionField">
						<cfif thisOptionHint NEQ "">
							<a href="##option_#attributes.questionID#_#thisOptionValue#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
							<div id="option_#attributes.questionID#_#thisOptionValue#_tip" class="popupQuestionBlock modal hide fade">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
									<h3 id="myModalLabel">Help</h3>
								</div>
								<div class="modal-body">
									#thisOptionHint#
								</div>
							</div>
						<cfelse>
							<span class="questionPopup"></span>
						</cfif>
						
						<div class="questionContent">
							<label class="radio">
								<cfset excludedQuestionIDs = "" />
								<cfif structKeyExists(attributes.excludedQuestionStruct,option["questionAnswerID"])>
									<cfset excludedQuestionIDs = attributes.excludedQuestionStruct[option["questionAnswerID"]].questionIDs />
								</cfif>
								<input type="radio" id="#option["questionAnswerID"]#" name="#attributes.fieldName#" data-questioncode="#lcase(attributes.questionCode)#" data-questionid="#lcase(attributes.questionID)#" data-excludedQuestionIDs="#excludedQuestionIDs#" value="#thisOptionValue#" <cfif attributes.value EQ thisOptionValue> checked="checked"</cfif> #attributes.fieldAttributes# />
								#listgetat(thisOptionName,'1','|')#
							</label>
						</div>
					</div>
				</cfloop>
			</cfoutput>
		</cfcase>
		<cfcase value="Select Box">
			<cfoutput>
				<div class="questionField">
					<!---<cfif thisOptionHint NEQ "">
						<a href="##option_#attributes.questionID#_#thisOptionValue#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_#thisOptionValue#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#thisOptionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>--->
					
					<div class="questionContent">
						<select name="#attributes.fieldName#" class="#attributes.fieldClass#" #attributes.fieldAttributes#>
							<cfloop array="#attributes.valueOptions#" index="option">
								<cfset thisOptionValue = isSimpleValue(option) ? option : structKeyExists(option, 'value') ? structFind(option, 'value') : '' />
								<cfset thisOptionName = isSimpleValue(option) ? option : structFind(option, 'name') />
								<option value="#thisOptionValue#" <cfif attributes.value EQ thisOptionValue> selected="selected"</cfif>>#thisOptionName#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="text">
			<cfoutput>
				<div class="questionField">
					<span class="questionPopup"></span>
					
					<div class="questionContent">
						<input type="text" name="#attributes.fieldName#" value="#htmlEditFormat(attributes.value)#" title="#attributes.questionHint#" placeholder="#attributes.questionDefaultValue#" class="" #attributes.fieldAttributes# />
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="textautocomplete">
			<cfoutput>
				<cfset suggestionsID = createUUID() />
				<div class="autoselect-container">
					<input type="hidden" name="#attributes.fieldName#" value="#htmlEditFormat(attributes.value)#" />
					<input type="text" name="#attributes.fieldName#-autocompletesearch" class="textautocomplete #attributes.fieldClass#" data-acfieldname="#attributes.fieldName#" data-sugessionsid="#suggestionsID#" #attributes.fieldAttributes# <cfif len(attributes.value)>disabled="disabled"</cfif> />
					<div class="autocomplete-selected" <cfif not len(attributes.value)>style="display:none;"</cfif>><a href="##" class="textautocompleteremove"><i class="icon-remove"></i></a> <span class="value" id="selected-#suggestionsID#"><cfif len(attributes.value)>#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#</cfif></span></div>
					<div class="autocomplete-options" style="display:none;">
						<ul class="#listLast(lcase(attributes.fieldName),".")#" id="#suggestionsID#">
							<cfif len(attributes.value)>
								<li>
									<a href="##" class="textautocompleteadd" data-acvalue="#attributes.value#" data-acname="#attributes.autocompleteSelectedValueDetails[ attributes.autocompleteNameProperty ]#">
									<cfset local.counter = 0 />
									<cfloop list="#attributes.autocompletePropertyIdentifiers#" index="pi">
										<cfset local.counter++ />
										<cfif local.counter lte 2 and pi neq "adminIcon">
											<span class="#listLast(pi,".")# first">
										<cfelse>
											<span class="#listLast(pi,".")#">
										</cfif>
										#attributes.autocompleteSelectedValueDetails[ pi ]#</span>
									</cfloop>
									</a>
								</li>
							</cfif>
						</ul>
					</div>
					<cfif len(attributes.modalCreateAction)>
						<cf_SlatwallActionCaller action="#attributes.modalCreateAction#" modal="true" icon="plus" type="link" class="btn modal-fieldupdate-textautocomplete" icononly="true">
					</cfif>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="Text Area">
			<cfoutput>
				<div class="questionField">
					<cfif attributes.questionHint NEQ "">
						<a href="##option_#attributes.questionID#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#attributes.questionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>
					<div class="questionContent">
						<textarea name="#attributes.fieldName#" placeholder="#attributes.questionDefaultValue#" class="#attributes.fieldClass#" #attributes.fieldAttributes#>#htmlEditFormat(attributes.value)#</textarea>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="time">
			<cfoutput>
				<div class="questionField">
					<cfif attributes.questionHint NEQ "">
						<a href="##option_#attributes.questionID#_tip" data-toggle="modal" class="questionPopup"><i class="icon-question-sign"></i></a>
						<div id="option_#attributes.questionID#_tip" class="popupQuestionBlock modal hide fade">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
								<h3 id="myModalLabel">Help</h3>
							</div>
							<div class="modal-body">
								#attributes.questionHint#
							</div>
						</div>
					<cfelse>
						<span class="questionPopup"></span>
					</cfif>
					<div class="questionContent">
						<input type="text" name="#attributes.fieldName#" value="#attributes.value#" class="#attributes.fieldClass# timepicker" #attributes.fieldAttributes# />
					</div>
				</div>			
			</cfoutput>
		</cfcase>
		<cfcase value="wysiwyg">
			<cfoutput>
				<textarea name="#attributes.fieldName#" class="#attributes.fieldClass# wysiwyg" #attributes.fieldAttributes#>#attributes.value#</textarea>
			</cfoutput>
		</cfcase>
		<cfcase value="yesno">
			<cfoutput>
				<label class="radio inline"><input type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="1" <cfif isBoolean(attributes.value) && attributes.value>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(1)#</label>
				<label class="radio inline"><input type="radio" name="#attributes.fieldName#" class="#attributes.fieldClass# yes" value="0" <cfif (isboolean(attributes.value) && not attributes.value) || not isBoolean(attributes.value)>checked="checked"</cfif> #attributes.fieldAttributes# />#yesNoFormat(0)#</label>
			</cfoutput>
		</cfcase>
		<cfcase value="State">
			<cfoutput>
				<div class="questionField">
					<div class="questionContent">
						<cfquery name="getStates">
							SELECT * FROM State
						</cfquery>
						<select name="#attributes.fieldName#" multiple="multiple" class="#attributes.fieldClass#" #attributes.fieldAttributes#>
							<cfloop query="getStates">
								<option value="#getStates.stateCode#" <cfif listFindNoCase(attributes.value,getStates.stateCode)> selected="selected"</cfif>>#getStates.stateName#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="State Long">
			<cfoutput>
				<div class="questionField">
					<div class="questionContent">
						<cfquery name="getStates">
							SELECT * FROM State
						</cfquery>
						<select name="#attributes.fieldName#" multiple="multiple" class="#attributes.fieldClass#" #attributes.fieldAttributes#>
							<cfloop query="getStates">
								<option value="#getStates.stateName#" <cfif listFindNoCase(attributes.value,getStates.stateName)> selected="selected"</cfif>>#getStates.stateName#</option>
							</cfloop>
						</select>
					</div>
				</div>
			</cfoutput>
		</cfcase>
	</cfswitch>
	
</cfif>