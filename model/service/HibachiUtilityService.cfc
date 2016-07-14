component extends="PhiaPlan.org.Hibachi.HibachiUtilityService" {

	/* string is passed in following format 
		${questionCode.answerLabel}|${questionCode.answerValue}
	*/
	public array function getStringReplaceOptions(required string replaceVariable, string checklistID="") {
		var returnArray = []; 
		var key = rereplace(arguments.replaceVariable,"\$|{|}","","all");
		var answerEntity = getService("planService").newQuestionAnswer();
		
		var questionCode = listFirst(key,".");
		var displayProperty = replace(listGetAt(key,2,"."),"answertexts","questionAnswerTexts");
		
		var questionAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
		questionAnswerSmartList.addFilter("question_questionCode",questionCode);
		if(arguments.checklistID != ""){
			questionAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",arguments.checklistID);
		}
		
		// if it's not a property then it's an answercode
		if(!answerEntity.hasProperty(displayProperty)) {
			var thisAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
			thisAnswerSmartList.addFilter("question_questionCode",questionCode);
			if(arguments.checklistID != ""){
				thisAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",arguments.checklistID);
			}
			thisAnswerSmartList.addFilter("answerCode",displayProperty);
			if(arrayLen(thisAnswerSmartList.getRecords())) {
				var answer = thisAnswerSmartList.getRecords()[1];
				var newDisplayProperty = replace(listGetAt(key,3,"."),"answertexts","questionAnswerTexts");
				if(answer.hasProperty(newDisplayProperty)) {
					if(newDisplayProperty == "questionAnswerTexts") {
						if(arrayLen(answer.getQuestionAnswerTexts()) >= listLast(key,".")) {
							var answerTextSmartList = answer.getQuestionAnswerTextsSmartList();
							answerTextSmartList.addOrder("sortOrder|asc");
							arrayAppend(returnArray,answerTextSmartList.getRecords()[listLast(key,".")].getAnswerText());
						} else {
							arrayAppend(returnArray,"Invalid AnswerText Index.");
						}
					} else {
						var data = answer.invokeMethod("get#newDisplayProperty#");
						if(isSimpleValue(data)) {
							arrayAppend(returnArray,data);
						}
					}
				}
			} else {
				arrayAppend(returnArray,"Invalid question or answer code.");
			}
		}
		if(answerEntity.hasProperty(displayProperty)) {
			for(var answer in questionAnswerSmartList.getRecords()) {
				if(displayProperty == "questionAnswerTexts") {
					if(arrayLen(answer.getQuestionAnswerTexts()) >= listLast(key,".")) {
						var answerTextSmartList = answer.getQuestionAnswerTextsSmartList();
						answerTextSmartList.addOrder("sortOrder|asc");
						arrayAppend(returnArray,answerTextSmartList.getRecords()[listLast(key,".")].getAnswerText());
					} else {
						arrayAppend(returnArray,"Invalid AnswerText Index.");
					}
				} else {
					var data = answer.invokeMethod("get#displayProperty#");
					if(!isNull(data) && isSimpleValue(data)) {
						arrayAppend(returnArray,data);
					}
				}
			}
		}
		
		// do a second round of replacement for nested variable
		for(var i = 1; i <= arrayLen(returnArray); i++) {
			var item = returnArray[i];
			var templateKeys = reMatchNoCase("\${[^}]+}",item);
			for(var j=1; j<=arrayLen(templateKeys); j++) {
				var replacedDataArray = getStringReplaceOptions(templateKeys[j]);
				var replacedData = '<span class="nestedlookup">' & arrayToList(replacedDataArray,"<br>") & '</span>';
				//var replacedData = '<span class="nestedlookup">'&'xxx'&'</span>';
				returnArray[i] = replaceNoCase(returnArray[i],templateKeys[j],replacedData);
			}
		}
		
		return returnArray;
	}
	
	public function replaceStringTemplatePhia(required string template,required string clientGroupChecklistID,string defaultValue="",boolean highlightReplacement=false) {
		// parse out the template argument and create an array of all the variables in the format ${xx}
		var templateKeys = reMatchNoCase("\${[^}]+}",arguments.template);
		var replacementArray = [];
		var returnString = arguments.template;
		
		// instantiate a new answer entity, so we lookup entity metadata for properties
		var answerEntity = getService("planService").newQuestionAnswer();
		// load clientGroupChecklist and cache it in request scope
		if(getHibachiScope().hasValue("clientGroupChecklist_#clientGroupChecklistID#")){
			var clientGroupChecklist = getHibachiScope().getValue("clientGroupChecklist_#clientGroupChecklistID#");
		} else {
			var clientGroupChecklist = getService("planService").getClientGroupChecklist(arguments.clientGroupChecklistID);
			getHibachiScope().setValue("clientGroupChecklist_#clientGroupChecklistID#",clientGroupChecklist);
		}
		var checklist = clientGroupChecklist.getChecklist();
		// loop through all the variables to be replaced
		for(var i=1; i<=arrayLen(templateKeys); i++) {
			// create a struct that will hold the key value pair for replacement
			var replaceDetails = {};
			replaceDetails.key = templateKeys[i];
			replaceDetails.value = defaultValue;
			replaceDetails.questionCode = "";
			
			// get the actual variable without ${}
			var Key = replace(replace(templateKeys[i], "${", ""),"}","");
			
			// first portion of the variable is always question code
			var questionCode = listFirst(key,".");
			replaceDetails.questionCode = questionCode;
			
			if(listLen(key,".") >= 2){
				// if the varible has more than 2 parts, set the second part as the displayProperty
				// replace "answertexts" with "questionAnswerTexts" in the variable string
				// answertexts is used in the variable instead of "questionAnswerTexts" as a 'friendly' text
				var displayProperty = replace(listGetAt(key,2,"."),"answertexts","questionAnswerTexts");
			} else {
				// if the list length of varible is 1 then display property is always answerValue
				displayProperty = "answerValue";
			}
			
			// Load the client's answer for this question
			var clientGroupChecklistAnswerSmartList = getService("planService").getClientGroupChecklistAnswerSmartList();
			clientGroupChecklistAnswerSmartList.addFilter("clientGroupChecklist_clientGroupChecklistID",clientGroupChecklistID);
			clientGroupChecklistAnswerSmartList.addFilter("question_questionCode",questionCode);
			if(!getHibachiScope().hasValue("answer_#clientGroupChecklistID#_#questionCode#")){
				getHibachiScope().setValue("answer_#clientGroupChecklistID#_#questionCode#",clientGroupChecklistAnswerSmartList.getRecords());
			}
			// if an answer record is found proceed with replacement logic
			if(arrayLen(getHibachiScope().getValue("answer_#clientGroupChecklistID#_#questionCode#"))){
				
				// assume replacement is done by answerValue and set that as the default replacement
				replaceDetails.value = getHibachiScope().getValue("answer_#clientGroupChecklistID#_#questionCode#")[1].getAnswerValue();
				
				// if the answerValue is not null the proceed with replacement logic
				if(!isNull(replaceDetails.value)){
					// if the display Property is answerValue, nothing to do, already set
					if(displayProperty == "answerValue") {
						// if the value is date, format it properly
						if(isValid("usdate",replaceDetails.value)){
							replaceDetails.value = dateFormat(replaceDetails.value,"MMMM DD, YYYY");
						}
					// if the displayProperty is a property of answer Entity the perform the logic below	
					} else if(answerEntity.hasProperty(displayProperty)) {
						// get answer entity for this question based on the answerValue (the user answered Value) 
						// join with questionAnswerTexts and fetch it eager
						var questionAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
						questionAnswerSmartList.addFilter("question_questionCode",questionCode);
						questionAnswerSmartList.addFilter("answerValue",replaceDetails.value);
						questionAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",checklist.getCheckListID());
						questionAnswerSmartList.joinRelatedProperty("PhiaPlanQuestionAnswer","questionAnswerTexts","left",true);
						var answers = questionAnswerSmartList.getRecords();
						// if there are answers created for this question proceed further
						if(arrayLen(answers)){
							var answer = questionAnswerSmartList.getRecords()[1];
							// if the displayProperty is "questionAnswerTexts" (answertexts), the last item of the variable should be 
							// the array index for the answertexts, sorted based on sortOrder
							if(displayProperty == "questionAnswerTexts") {
								var answerTextSmartList = getService("planService").getQuestionAnswerTextSmartList();
								answerTextSmartList.addFilter("questionAnswer.questionAnswerID",answer.getQuestionAnswerID());
								answerTextSmartList.addFilter("extension",listLast(key,"."));
								if(arrayLen(answerTextSmartList.getRecords())){
									var answerTextStr = answerTextSmartList.getRecords()[1].getAnswerText();
									replaceDetails.value = reReplaceNoCase(reReplaceNoCase(trim(answerTextStr),"(<\/p>)$",""),"^<p>","");
								}
							// otherwise displayProperty should be a property of the answer Entity
							} else {
								var data = answer.invokeMethod("get#displayProperty#");
								if(!isNull(data) && isSimpleValue(data)) {
									replaceDetails.value = data;
								}
							}
						} else {
							replaceDetails.value = "";
						}
					// if the displayProperty is not a property of answerEntity then assume it to be answercode
					} else {
						// get answer entity for this question based on the answerValue (the user answered Value) 
						// join with questionAnswerTexts and fetch it eager
						// join with answerCode to filter further
						var questionAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
						questionAnswerSmartList.addFilter("question_questionCode",questionCode);
						questionAnswerSmartList.addFilter("answerValue",replaceDetails.value);
						questionAnswerSmartList.addFilter("answerCode",displayProperty);
						questionAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",checklist.getCheckListID());
						questionAnswerSmartList.joinRelatedProperty("PhiaPlanQuestionAnswer","questionAnswerTexts","left",true);
						var answers = questionAnswerSmartList.getRecords();
						if(arrayLen(answers)){
							var answer = questionAnswerSmartList.getRecords()[1];
							// if answer code don't match replace with blank
							if(answer.getAnswerCode() != displayProperty) {
								replaceDetails.value = "";
							} else {
								// since the variable had answerCode there should be more parts to define the displayProperty
								// replace based on answertext or property
								var newDisplayProperty = replace(listGetAt(key,3,"."),"answertexts","questionAnswerTexts");
								if(newDisplayProperty == "questionAnswerTexts") {
									var answerTextSmartList = getService("planService").getQuestionAnswerTextSmartList();
									answerTextSmartList.addFilter("questionAnswer.questionAnswerID",answer.getQuestionAnswerID());
									answerTextSmartList.addFilter("extension",listLast(key,"."));
									if(arrayLen(answerTextSmartList.getRecords())){
										var answerTextStr = answerTextSmartList.getRecords()[1].getAnswerText();
										replaceDetails.value = reReplaceNoCase(reReplaceNoCase(trim(answerTextStr),"(<\/p>)$",""),"^<p>","");
									}
								} else if (answer.hasProperty(newDisplayProperty)) {
									var data = answer.invokeMethod("get#newDisplayProperty#");
									if(!isNull(data) && isSimpleValue(data)) {
										replaceDetails.value = data;
									}
								} else {
									replaceDetails.value = "";
								}
							}
						} else {
							replaceDetails.value = defaultValue;
						}
					}
				}
			}
			
			// if the replace value was not, set it to the default value passed in as argument (e.g. Not Available)
			if(isNull(replaceDetails.value)){
				replaceDetails.value = defaultValue;
			}
			
			// do a second round of replacement for nested variable
			var nestedTemplateKeys = reMatchNoCase("\${[^}]+}",replaceDetails.value);
			if(arrayLen(nestedTemplateKeys)) {
				replaceDetails.value = replaceStringTemplatePhia(replaceDetails.value,clientGroupChecklistID,defaultValue,highlightReplacement) ;
			}
		
			// build an array of replacement values that we will replace at the end
			arrayAppend(replacementArray, replaceDetails);
		}
		
		// loop through all the replace values
		for(var i=1; i<=arrayLen(replacementArray); i++) {
			if(structKeyExists(replacementArray[i],"value")) {
				var replacementValue = replacementArray[i].value;
				// if highlightReplacement argument was passed in, wrap the value in a span with checklistdata class
				if(highlightReplacement) {
					replacementValue = "<span class='checklistdata' title='#replace(replacementArray[i].key,"$","")#' data-questioncode='#replacementArray[i].questionCode#'>#replacementValue#</span>";
				}
				// do the actual replace in the string that was passed in
				returnString = replace(returnString, replacementArray[i].key, replacementValue, "all");
			}
		}
		
		return returnString;
	}
	
	public function findLoopingCode(required string template,required any checklist, string keyPath = "") {
		// parse out the template argument and create an array of all the variables in the format ${xx}
		var templateKeys = reMatchNoCase("\${[^}]+}",arguments.template);
		var replacementArray = [];
		var returnString = arguments.template;
		
		// instantiate a new answer entity, so we lookup entity metadata for properties
		var answerEntity = getService("planService").newQuestionAnswer();

		// loop through all the variables to be replaced
		for(var i=1; i<=arrayLen(templateKeys); i++) {
			// create a struct that will hold the key value pair for replacement
			var replaceDetails = {};
			replaceDetails.key = templateKeys[i];
			replaceDetails.value = "";
			
			// if the key in keypath, then it's a looping code
			if(listFindNoCase(arguments.keyPath, replaceDetails.key)) {
				return "looping_code";
			}
			
			// get the actual variable without ${}
			var Key = replace(replace(templateKeys[i], "${", ""),"}","");
			
			// first portion of the variable is always question code
			var questionCode = listFirst(key,".");
			
			if(listLen(key,".") >= 2){
				// if the varible has more than 2 parts, set the second part as the displayProperty
				// replace "answertexts" with "questionAnswerTexts" in the variable string
				// answertexts is used in the variable instead of "questionAnswerTexts" as a 'friendly' text
				var displayProperty = replace(listGetAt(key,2,"."),"answertexts","questionAnswerTexts");
			} else {
				// if the list length of varible is 1 then display property is always answerValue
				displayProperty = "answerValue";
			}
							
			// if the display Property is answerValue, nothing to do, already set
			if(displayProperty == "answerValue") {
				// no looping code here
			// if the displayProperty is a property of answer Entity the perform the logic below	
			} else if(answerEntity.hasProperty(displayProperty)) {
				// get answer entity for this question based on the answerValue (the user answered Value) 
				// join with questionAnswerTexts and fetch it eager
				var questionAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
				questionAnswerSmartList.addFilter("question_questionCode",questionCode);
				questionAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",checklist.getCheckListID());
				questionAnswerSmartList.joinRelatedProperty("PhiaPlanQuestionAnswer","questionAnswerTexts","left",true);
				var answers = questionAnswerSmartList.getRecords();
				// if there are answers created for this question proceed further
				if(arrayLen(answers)){
					var answer = questionAnswerSmartList.getRecords()[1];
					// if the displayProperty is "questionAnswerTexts" (answertexts), the last item of the variable should be 
					// the array index for the answertexts, sorted based on sortOrder
					if(displayProperty == "questionAnswerTexts") {
						var answerTextSmartList = getService("planService").getQuestionAnswerTextSmartList();
						answerTextSmartList.addFilter("questionAnswer.questionAnswerID",answer.getQuestionAnswerID());
						answerTextSmartList.addFilter("extension",listLast(key,"."));
						if(arrayLen(answerTextSmartList.getRecords())){
							var answerTextStr = answerTextSmartList.getRecords()[1].getAnswerText();
							//replaceDetails.value = mid(answerTextStr,4,len(answerTextStr)-4);
							replaceDetails.value = reReplaceNoCase(answerTextStr,"(.*?)(<p>)(.*?)(</p>)(.*)","\1\3\5");
						}	
					// otherwise displayProperty should be a property of the answer Entity
					} else {
						var data = answer.invokeMethod("get#displayProperty#");
						if(!isNull(data) && isSimpleValue(data)) {
							replaceDetails.value = data;
						}
					}
				} else {
					replaceDetails.value = "";
				}
			// if the displayProperty is not a property of answerEntity then assume it to be answercode
			} else {
				// get answer entity for this question based on the answerValue (the user answered Value) 
				// join with questionAnswerTexts and fetch it eager
				// join with answerCode to filter further
				var questionAnswerSmartList = getService("planService").getQuestionAnswerSmartList();
				questionAnswerSmartList.addFilter("question_questionCode",questionCode);
				questionAnswerSmartList.addFilter("answerCode",displayProperty);
				questionAnswerSmartList.addFilter("question_checklistSection_checklist_checklistID",checklist.getCheckListID());
				questionAnswerSmartList.joinRelatedProperty("PhiaPlanQuestionAnswer","questionAnswerTexts","left",true);
				var answers = questionAnswerSmartList.getRecords();
				if(arrayLen(answers)){
					var answer = questionAnswerSmartList.getRecords()[1];
					// if answer code don't match replace with blank
					if(answer.getAnswerCode() != displayProperty) {
						replaceDetails.value = "";
					} else {
						// since the variable had answerCode there should be more parts to define the displayProperty
						// replace based on answertext or property
						var newDisplayProperty = replace(listGetAt(key,3,"."),"answertexts","questionAnswerTexts");
						if(newDisplayProperty == "questionAnswerTexts") {
							var answerTextSmartList = getService("planService").getQuestionAnswerTextSmartList();
							answerTextSmartList.addFilter("questionAnswer.questionAnswerID",answer.getQuestionAnswerID());
							answerTextSmartList.addFilter("extension",listLast(key,"."));
							if(arrayLen(answerTextSmartList.getRecords())){
								var answerTextStr = answerTextSmartList.getRecords()[1].getAnswerText();
								//replaceDetails.value = mid(answerTextStr,4,len(answerTextStr)-4);
								replaceDetails.value = reReplaceNoCase(answerTextStr,"(.*?)(<p>)(.*?)(</p>)(.*)","\1\3\5");
							}
						} else if (answer.hasProperty(newDisplayProperty)) {
							var data = answer.invokeMethod("get#newDisplayProperty#");
							if(!isNull(data) && isSimpleValue(data)) {
								replaceDetails.value = data;
							}
						} else {
							replaceDetails.value = "";
						}
					}
				} else {
					replaceDetails.value = "";
				}
			}
			
			// do a second round of replacement for nested variable
			var nestedTemplateKeys = reMatchNoCase("\${[^}]+}",replaceDetails.value);
			if(arrayLen(nestedTemplateKeys)) {
				var newKeyPath = listAppend(arguments.keyPath,replaceDetails.key);
				replaceDetails.value = findLoopingCode(replaceDetails.value,checklist,newKeyPath) ;
				if(replaceDetails.value == "looping_code") {
					return replaceDetails.key;
				}
			}
		
			// build an array of replacement values that we will replace at the end
			arrayAppend(replacementArray, replaceDetails);
		}

		return "";
	}

	/**
	 * Removes HTML from the string.
	 * v2 - Mod by Steve Bryant to find trailing, half done HTML.        
	 * v4 mod by James Moberg - empties out script/style blocks
	 * 
	 * @param string      String to be modified. (Required)
	 * @return Returns a string. 
	 * @author Raymond Camden (ray@camdenfamily.com) 
	 * @version 4, October 4, 2010 
	 */
	function stripHTML(str) {
	    str = reReplaceNoCase(str, "<*style.*?>(.*?)</style>","","all");
	    str = reReplaceNoCase(str, "<*script.*?>(.*?)</script>","","all");
	
	    str = reReplaceNoCase(str, "<.*?>","","all");
	    //get partial html in front
	    str = reReplaceNoCase(str, "^.*?>","");
	    //get partial html at end
	    str = reReplaceNoCase(str, "<.*$","");
	    return trim(str);
	}
}