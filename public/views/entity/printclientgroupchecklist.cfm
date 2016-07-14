<cfsetting requesttimeout="600" />
<cfparam name="rc.clientGroupChecklistID" />
<cfset rc.clientGroupChecklist = $.PhiaPlan.getService("planService").getClientGroupChecklist(rc.clientGroupChecklistID) />
<cfset planDocumentTemplate = rc.clientGroupChecklist.getPlanDocumentTemplate() />

<!--- get all the responses --->
<cfset clientGroupChecklistAnswerSmartList = $.PhiaPlan.getService("planService").getClientGroupChecklistAnswerSmartList() />
<cfset clientGroupChecklistAnswerSmartList.addFilter("clientGroupChecklist_clientGroupChecklistID",rc.clientGroupChecklist.getClientGroupChecklistID()) />
<cfset clientGroupChecklistAnswerSmartList.joinRelatedProperty("PhiaPlanClientGroupChecklistAnswer","Question","inner",true) />
<!--- create a struct for answers --->
<cfset answerStruct = {} />
<cfloop array="#clientGroupChecklistAnswerSmartList.getRecords()#" index="clientGroupChecklistAnswer">
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()] = {} />
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()].clientGroupChecklistAnswerID = clientGroupChecklistAnswer.getClientGroupChecklistAnswerID() />
	<cfset answerStruct[clientGroupChecklistAnswer.getQuestion().getQuestionID()].answerValue = isNull(clientGroupChecklistAnswer.getAnswerValue())?"":clientGroupChecklistAnswer.getAnswerValue() />
</cfloop>

<!--- get answer dependency for sections --->
<cfset dependentSectionStruct = {} />
<cfloop array="#rc.clientGroupChecklist.getChecklist().getCheckListSections()#" index="checkListSection">
	<cfif arrayLen(checkListSection.getQuestionAnswerDependencies())>
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionCode()] = {} />
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionCode()].answerValue = [] />
		<cfset dependentSectionStruct[checkListSection.getCheckListSectionCode()].dependentQuestionID = [] />
		<cfloop array="#checkListSection.getQuestionAnswerDependencies()#" index="questionAnswer">
			<cfset arrayAppend(dependentSectionStruct[checkListSection.getCheckListSectionCode()].answerValue,questionAnswer.getAnswerValue()) />
			<cfset arrayAppend(dependentSectionStruct[checkListSection.getCheckListSectionCode()].dependentQuestionID,questionAnswer.getQuestion().getQuestionID()) />
		</cfloop>
	</cfif>
</cfloop> 

<cfset planDocumentChecklistSectionSmartList = planDocumentTemplate.getPlanDocumentChecklistSectionsSmartList() />
<cfset planDocumentChecklistSectionSmartList.addOrder("sortOrder|ASC") />
<cfset planDocumentChecklistSectionSmartList.addFilter("activeFlag",1) />

<cfset downloadAllowed = false />
<cfif $.PhiaPlan.getAccount().getsuperUserFlag() OR rc.fw.getsubsystem() EQ "admin" OR (isBoolean(rc.clientGroupChecklist.getClientGroup().getClient().getAllowDownloadFlag()) AND rc.clientGroupChecklist.getClientGroup().getClient().getAllowDownloadFlag() AND $.PhiaPlan.getService("HibachiAuthenticationService").authenticateActionByAccount('public:entity.downloadclientgroupchecklist',$.PhiaPlan.getAccount()))>
	<cfset downloadAllowed = true />
</cfif>

<cfif !structKeyExists(rc,"download")>
	<cfoutput>
	<cfif downloadAllowed AND rc.clientGroupChecklist.getDisclaimerAcceptedByLoggedInAccountFlag()>
		<div class="row-fluid">
			<div class="pull-right">
				<!--- <a class="btn btn-inverse" href="?#cgi.query_string#&download=1">Download Draft</a> --->
				<a class="btn btn-inverse" href="?#cgi.query_string#&download=1&clean=1">Download</a>
			</div>
		</div>
	<cfelseif downloadAllowed>
		<div class="row-fluid">
			<div class="pull-right">
				<a class="btn btn-inverse" href="##disclaimerModal" data-target="##disclaimerModal" role="button" data-toggle="modal">Download</a>
			</div>
		</div>
	</cfif>
	<cfsavecontent variable="toc">
		<cfloop array="#planDocumentChecklistSectionSmartList.getRecords()#" index="planDocumentChecklistSection">
			<cfif !structKeyExists(dependentSectionStruct,planDocumentChecklistSection.getChecklistSectionCode()) OR (structKeyExists(answerStruct,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]].answerValue,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].answerValue[1]))>
				<h4 style="font-size: 12px;"><a style="font-size: 10px; font-family: Arial; color: ##000;" href="###planDocumentChecklistSection.getplanDocumentChecklistSectionID()#">#planDocumentChecklistSection.getChecklistSectionName()#</a></h4>
			</cfif>
		</cfloop>
		<p></p>
	</cfsavecontent>

	<div id="viewAllDocumentBody">
		<cfloop array="#planDocumentChecklistSectionSmartList.getRecords()#" index="planDocumentChecklistSection">
			<cfif !structKeyExists(dependentSectionStruct,planDocumentChecklistSection.getChecklistSectionCode()) OR (structKeyExists(answerStruct,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]].answerValue,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].answerValue[1]))>
				<a name="#planDocumentChecklistSection.getplanDocumentChecklistSectionID()#"></a>
				<cfif Not isNull(planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription())>
					#replaceNoCase(replaceNoCase($.phiaPlan.replaceStringTemplatePhia(planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription(),rc.clientGroupChecklistID,"Not Available",true),'[toc]','#toc#'),'style="font-size:10px"','','all')#
				</cfif>
			</cfif>
		</cfloop>
	</div>
	
	<!--- COMPLETE COMFIRMATION --->
	<div class="modal hide" id="disclaimerModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
			<h3 id="myModalLabel">Disclaimer</h3>
		</div>	
		<div class="modal-body">
			<p>By accepting this Plan Document/Summary Plan Description ("SPD"), generated by Phia's proprietary Phia Document management software (the "Software") for use by the benefit plan for which the "Licensee" is an Administrator, the Licensee agrees not to hold The Phia Group, LLC or Phia Group Consulting, LLC (together, "Phia") liable for, and Phia explicitly disclaims all warrantees of any kind with respect to, any changes, revisions, additions or modifications made to the SPD document following receipt of this correspondence by the Licensee. In the event that the Licensee or any other entity makes any changes to provisions of the SPD that are not reviewed and explicitly approved by Phia in writing, all warrantees previously given by Phia are void. Under no circumstances may the Licensee rely on any warranty made for any purpose by any entity other than Phia.
			<p>In all instances, the Plan Administrator retains sole, full, and final discretionary authority to draft and interpret all provisions within any SPD, including the right to remedy possible ambiguities, inconsistencies, or omissions; to make determinations of eligibility for benefits; and to determine all questions of fact and law arising under the SPD. Licensee shall be solely responsible for reviewing any SPD provided to it that has been produced by the Software to confirm the accuracy of the SPD and its suitability for the needs of the Licensee and the Licensee's client or clients, if applicable.</p>	
			<p>Phia warrants that the SPD produced by the Software meets the requirements of the Employee Retirement Income Security Act, as amended, the Health Insurance Portability and Accountability Act, as amended, and any applicable federal regulations promulgated thereunder at the time the SPD was produced. In the event of any change in the foregoing federal requirements, the Plan Sponsor or Plan Administrator shall be responsible to obtain any updates to the SPD that are necessary to ensure continued compliance with federal or state regulations. Phia disclaims all warranties related to changes in applicable law effective subsequent to the sending of this communication. The Licensee acknowledges that Phia provides consulting services only, and does not function as legal counsel.</p>	
			<p>The execution and delivery of this agreement, the grant of the license hereunder, and the terms of the SPD, will not prejudice the rights or responsibilities of any other entity, or the terms of any other agreement to which Phia or Licensee is a party. Licensee agrees to indemnify and hold harmless Phia for any incidental, consequential, or exemplary damages or loss of profits incurred as a result of the distribution, enforcement, interpretations, or other use or effects of this SPD.</p>		
			
		</div>
		<div class="modal-footer">
			<div class="pull-left disclaimerCheckboxSelect">
				<input type="checkbox" name="disclaimerSelect" id="disclaimerSelect" value="0"><span>Yes, I accept <span style="display: none;" id="disclaimerMissing">Please accept Terms & Conditions</span></span>
			</div>
			
			<!--- <a class="btn btn-disabled" href="?#cgi.query_string#&download=1">Download Draft</a> --->
			<a class="btn btn-disabled" href="?#cgi.query_string#&download=1&clean=1">Download</a>
		</div>
	</div>	
	</cfoutput>
	
	<script>
		
		$(document).ready(function() {
			
			$('ol li span.checklistdata:empty, ul li span.checklistdata:empty').remove();
			$('ol li:empty, ul li:empty').remove();
			// $('ol li p:empty, ul li p:empty').remove();
			
			$('ol li, ul li').filter(function() {
			    return $(this).text() === "<br></br>";
			});
			
			$('ol li p, ul li p').each(function() {
			    var $this = $(this);
			    if($this.html().replace(/\s|&nbsp;/g, '').length == 0)
			        $this.parent().remove();
			});
			
		});
		
		// ENABLE BUTTONS
		$('#disclaimerSelect').click(function(){
		    if ($('#disclaimerSelect').attr('checked')) {
		        $('.btn-disabled').removeClass('btn-disabled').addClass('btn-primary');
			} else {
				$('.btn-primary').removeClass('btn-primary').addClass('btn-disabled');
			}
		});	

		$('.modal-footer .btn').click(function(e) {
			if ($('#disclaimerSelect').attr('checked')) {
				e.preventDefault();
				var goTo = this.getAttribute("href");
			
				// UPDATE USER RECORD TO VIEWED
				$.get("/?PPAction=entity.saveClientGroupChecklistDisclaimerAcceptance&clientGroupChecklistDisclaimerAcceptanceID=&clientGroupChecklist.clientGroupChecklistID=<cfoutput>#rc.clientGroupChecklistID#</cfoutput>&ajaxRequest=1", function( data ) {
					window.location = goTo;
				});
			
			} else {
				$('#disclaimerMissing').slideDown().delay("1200").slideUp() ;
				e.preventDefault();
			}
        });

		$('.checklistdata').click(function(e) {
			e.preventDefault();
			
			var questionCode = this.getAttribute("data-questioncode");
			var goTo = "/?PPAction=entity.detailclientgroupchecklist&clientGroupChecklistID=<cfoutput>#rc.clientGroupChecklist.getclientGroupChecklistID()#</cfoutput>";
		
			// UPDATE USER RECORD TO VIEWED
			$.get("/?PPAction=public:entity.questiondetails&questionCode="+questionCode+"&checklistID=<cfoutput>#rc.clientGroupChecklist.getChecklist().getchecklistID()#</cfoutput>&ajaxrequest=true", function( data ) {
				var responseData = $.parseJSON(data);
				goTo = goTo + '&checklistSectionID='+responseData.data.checklistSectionID+'&questionID='+responseData.data.questionID + '&scroll=true';
				window.location = goTo;
			});
			
        });
	</script>
	
<cfelseif downloadAllowed>

	<cfset defaultFont = planDocumentTemplate.getDefaultFont() />
	<cfif isNull(defaultFont) OR defaultFont EQ "">
		<cfset defaultFont = "Arial" />
	</cfif>
	<cfset defaultFontSize = planDocumentTemplate.getDefaultFontSize() />
	<cfif isNull(defaultFontSize) OR defaultFontSize EQ "">
		<cfset defaultFontSize = "10" />
	</cfif>
	<cfset orientation = planDocumentTemplate.getOrientation() />
	<cfset pageSize = "11in 8.5in" />
	<cfif isNull(orientation) OR orientation EQ "" OR orientation EQ "portrait">
		<cfset orientation = "portrait" />
		<cfset pageSize = "8.5in 11.0in" />
	</cfif>

<cfsavecontent variable="planDocument">
<cfoutput>
<html 
xmlns:o='urn:schemas-microsoft-com:office:office' 
xmlns:w='urn:schemas-microsoft-com:office:word'
xmlns='http://www.w3.org/TR/REC-html40'>
<head><title></title>

<!--[if gte mso 9]>
<xml>
<w:WordDocument>
	<w:View>Print</w:View>
	<w:Zoom>90</w:Zoom>
	<w:DoNotOptimizeForBrowser/>
</w:WordDocument>
</xml>
<![endif]-->

<style>
p.MsoFooter, li.MsoFooter, div.MsoFooter {
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	tab-stops:center 3.0in right 6.0in;
	font-size:#defaultFontSize#.0pt;
	}
<style>

<!-- /* Style Definitions */ -->

@page {
    mso-page-orientation: #orientation#;
    margin: #planDocumentTemplate.getmarginTop()#in #planDocumentTemplate.getMarginRight()#in #planDocumentTemplate.getMarginBottom()#in #planDocumentTemplate.getMarginLeft()#in;
	font-size:#defaultFontSize#.0pt;
	font-family: #defaultFont#;
	text-align: justify;
	}

@page Section1 {
	mso-page-orientation: #orientation#;
	size: #pageSize#;	
		
	margin: #planDocumentTemplate.getmarginTop()#in #planDocumentTemplate.getMarginRight()#in #planDocumentTemplate.getMarginBottom()#in #planDocumentTemplate.getMarginLeft()#in;
	mso-header-margin:.5in;
	mso-header:h1;
	mso-footer: f1; 
	mso-footer-margin:.5in;
	}

div.Section1 {
	page:Section1;
	}

table##hrdftrtbl {
	margin: 0in 0in 0in 11in;
	}
		
p.MsoFooter p { text-align: left !important; }	

div p { margin: 0px; padding: 0px; }

div.Section1 p { margin: 0px; padding: 0px; }

<!--- flush margin - margin-left: 24px; --->
ul { margin-top: 0px; margin-top: 0; margin-bottom: 0px; margin-bottom: 0; }
ol { margin-top: 0px; margin-top: 0 margin-bottom: 0px; margin-bottom: 0; }

table td { font-family: #defaultFont#; font-size:#defaultFontSize#.0pt; }

##f1 { text-align: left; }

.insertPageBreak { max-height: 1px; page-break-before:always; mso-break-type:page-break; height: 0.0in; margin: 0px; padding: 0px; }
.tdDarkBlue { background-color: ##0775a8;}
.tdMediumBlue { background-color: ##c0e8fb;}
.tdLightBlue { background-color: ##eff9ff;}
.backgroundTest { background-color: ##000; color: ##fff; }

.elapDarkBlue { color: ##0000cc; } 
.elapLightBlue { color: ##33ccff; } 
.elapCostOrange { color: ##ff6600; } 
.phiaBlue { color: ##0066ff; }
.phiaPink { color: ##ff00cc; } 
.phiaRose { color: ##cc6666; } 
.phiaDarkRed { color: ##990000; }
.tealFourteen { color: ##339999; } 
.greenFifteen { color: ##666600; } 

p.arrowBulletPara {
	margin-left:.25in !important;
	mso-add-space:auto; 
	text-indent:-.25in;
	tab-stops:.25in;
}

.bullet {
	font-family: 'Wingdings';
	mso-fareast-font-family: Wingdings;
	mso-bidi-font-family: Wingdings; 
	width: 20px; 
	display: inline-block; 
	text-indent: 0px;
}

<cfif planDocumentTemplate.getListMarginAlignment() EQ "Left Aligned">
	ul, ol { margin: 24px 0px 24px 24px; }
</cfif>

</style></head>

<cfset bulletStartText = '<p class="arrowBulletPara">
	<span class="bullet">
		&##216;
	</span>
	<span>' />

<cfset bulletEndText = '</span></p-->' />

<body lang=EN-US style='tab-interval:.5in'>
<div class="Section1">

<cfsavecontent variable="toc">
	<cfloop array="#planDocumentChecklistSectionSmartList.getRecords()#" index="planDocumentChecklistSection">
		<cfif !structKeyExists(dependentSectionStruct,planDocumentChecklistSection.getChecklistSectionCode()) OR (structKeyExists(answerStruct,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]].answerValue,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].answerValue[1]))>
			<h4 style="font-size: 12px;"><span style="font-size: 10px; font-family: Arial; color: ##000;">#planDocumentChecklistSection.getChecklistSectionName()#<br></h4>
		</cfif>
	</cfloop>
	<br clear="all" style="page-break-before:always;mso-break-type:page-break" />
</cfsavecontent>

<!--- MAIN DOCUMENT CONTENT --->
<cfloop array="#planDocumentChecklistSectionSmartList.getRecords()#" index="planDocumentChecklistSection">
	<cfif !structKeyExists(dependentSectionStruct,planDocumentChecklistSection.getChecklistSectionCode()) OR (structKeyExists(answerStruct,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]) AND listFindNoCase(answerStruct[dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].dependentQuestionID[1]].answerValue,dependentSectionStruct[planDocumentChecklistSection.getChecklistSectionCode()].answerValue[1]))>
		<a name="#planDocumentChecklistSection.getplanDocumentChecklistSectionID()#"></a>
		
		<cfif Not isNull(planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription())>
			
			<cfif structKeyExists(rc,"download") AND url.download EQ "YES">
				<cfset sectionText = replaceNoCase($.phiaPlan.replaceStringTemplatePhia(planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription(),rc.clientGroupChecklistID,'notextreplacement'),'[toc]','#toc#') />
			<cfelse>
				<cfset sectionText = replaceNoCase($.phiaPlan.replaceStringTemplatePhia(planDocumentChecklistSection.getPlanDocumentChecklistSectionDescription(),rc.clientGroupChecklistID),'[toc]','#toc#') />
			</cfif>

			<!---<textarea>#sectionText#</textarea>--->
			
			<!--- special bullets --->
			<cfset match = reMatchNoCase('<ul[\s\S]class=\"bullet\"[\s\S^>]*?>([\s\S]*?)</ul>',sectionText) />
			
			<cfloop array="#match#" index="item">
				<cfset newValue = reReplaceNoCase(item,'<li>([\s\S]*?)</li>','#bulletStartText#\1#bulletEndText#','all') />
				<cfset newValue = reReplaceNoCase(trim(newValue),'^<ul[\s\S]class=\"bullet\"[\s\S^>]*?>([\s\S]+)<\/ul>$','\1') />
				
				<!--- add in space after the end of the final bullet for spacing --->
				<cfset newValue = newvalue & "<forcedspace>">
				<cfset sectionText = replaceNoCase(sectionText,item,newValue) />
			</cfloop>

			<!--- replace empty answer codes --->
			<cfset sectionText = rereplaceNoCase(sectionText,'(notextreplacement)+\1','\1','ALL') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<p>notextreplacement</p>','','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<li>notextreplacement</li>','','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'notextreplacement','','all') />
			
			<cfset sectionText = replaceNoCase(sectionText,'style="font-size:10px"','','all') />
			<cfset sectionText = replaceNoCase(sectionText,'style="line-height:1.6em"','','all') />
			
			<!--- DEFINE PARAGRAPH SPACING OPTIONS --->
			<cfif planDocumentTemplate.getParagraphSpacing() EQ "2">
				<cfset sectionText = rereplaceNoCase(sectionText,'</p>','</p><p>&nbsp;</p><p>&nbsp;</p>','all') />
			
				<!--- add space at beginning of paragraph --->
				<cfset sectionText = replaceNoCase(sectionText,'<p><br />','<p>&nbsp;</p><p>&nbsp;</p><p>','all') />
				
				<!--- add extra gap after ol and ul's --->
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol>','</ol><p>&nbsp;</p><p>&nbsp;</p>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul>','</ul><p>&nbsp;</p><p>&nbsp;</p>','all') />
			
			<cfelseif planDocumentTemplate.getParagraphSpacing() EQ "0">
				<cfset sectionText = rereplaceNoCase(sectionText,'</p>','</p>','all') />
			
				<!--- add space at beginning of paragraph --->
				<cfset sectionText = replaceNoCase(sectionText,'<p><br />','<p>','all') />
			
				<!--- add extra gap after ol and ul's --->
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol>','</ol>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul>','</ul>','all') />
			
			<cfelse>
				<cfset sectionText = rereplaceNoCase(sectionText,'</p>','</p><p>&nbsp;</p>','all') />
			
				<!--- add space at beginning of paragraph --->
				<cfset sectionText = replaceNoCase(sectionText,'<p><br />','<p>&nbsp;</p><p>','all') />
			
				<!--- add extra gap after ol and ul's --->
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol>','</ol><p>&nbsp;</p>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul>','</ul><p>&nbsp;</p>','all') />
			
			</cfif>
			
			<cfset sectionText = replaceNoCase(sectionText,'<br><br>','<p></p>','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<br[^>]+>[^a-zA-z0-9]+<br[^>]+>','<p></p>','all') />
			
			<!--- replace <br>'s with an opening and close paragraph --->
			<cfset sectionText = rereplaceNoCase(sectionText,'<br>','</p><p>','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<br[^>]+>','</p><p>','all') />
			
			<!--- remove any empty span sets <span> and <span ></span> --->
			<cfset sectionText = rereplaceNoCase(sectionText,'<span[^>]+></span>','','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<span></span>','','all') />
			
			<!--- remove the auto added space --->
			<cfset sectionText = rereplaceNoCase(sectionText,'<li>','<li style="mso-add-space:auto;">','all') />
			
			<!--- remove any empty line items - <li></li> --->
			<cfset sectionText = rereplaceNoCase(sectionText,'<li></li>','','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<li style="mso-add-space:auto;"></li>','','all') />
			
			<!--- remove extra space after bulleted list --->
			<cfif planDocumentTemplate.getParagraphSpacing() EQ "2">
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol><p>&nbsp;</p></p><p>&nbsp;</p>','</ol></p><p>&nbsp;</p><p>&nbsp;</p>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul><p>&nbsp;</p></p><p>&nbsp;</p>','</ul></p><p>&nbsp;</p><p>&nbsp;</p>','all') />
			<cfelseif planDocumentTemplate.getParagraphSpacing() EQ "0">
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol><p>&nbsp;</p></p><p>&nbsp;</p>','</ol></p>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul><p>&nbsp;</p></p><p>&nbsp;</p>','</ul></p>','all') />
			<cfelse>
				<cfset sectionText = rereplaceNoCase(sectionText,'</ol><p>&nbsp;</p></p><p>&nbsp;</p>','</ol></p><p>&nbsp;</p>','all') />
				<cfset sectionText = rereplaceNoCase(sectionText,'</ul><p>&nbsp;</p></p><p>&nbsp;</p>','</ul></p><p>&nbsp;</p>','all') />
			</cfif> 	
			
			<!--- remove extra space from paragraph within table --->
			<cfset sectionText = rereplaceNoCase(sectionText,'</p><p>&nbsp;</p>[^>]+</td>','</p></td>','all') />
			
			<!--- remove extra space from next ULs/OLs --->
			<cfset sectionText = rereplaceNoCase(sectionText,'</ol><p>&nbsp;</p>[^>]+</li>','</ol></li>','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'</ul><p>&nbsp;</p>[^>]+</li>','</ul></li>','all') />
			
			<!--- FIX FOR insertPageBreak paragraph after --->
			<cfset sectionText = replaceNoCase(sectionText,'<p class="insertPageBreak" style="text-align:center">&nbsp;</p><p>&nbsp;</p>','<p class="insertPageBreak" style="text-align:center">&nbsp;</p>','all') />
			
			<cfif structKeyExists(rc,"clean")>
				<cfset sectionText = rereplaceNoCase(sectionText,'style="background-color[^"]+"','','all') />
			</cfif>
			
			<!--- restore normal spacing for arrow paragraphs --->
			<cfset sectionText = rereplaceNoCase(sectionText,'</p-->','</p>','all') />
			<cfset sectionText = rereplaceNoCase(sectionText,'<forcedspace','<p>&nbsp;</p','all') />
			#sectionText#
		</cfif>
		<br clear="all" style="page-break-before:always;mso-break-type:page-break" />
		
	</cfif>
</cfloop>

<table id='hrdftrtbl' border='0' cellspacing='0' cellpadding='0'>
	<tr>
		<td>
			<cfif !isNull(planDocumentTemplate.getPlanDocumentHeaderText())>
				<div style='mso-element: header' id="h1">
					<p class="MsoHeader">
						#$.phiaPlan.replaceStringTemplatePhia(planDocumentTemplate.getPlanDocumentHeaderText(),rc.clientGroupChecklistID)#
					</p>
			    </div>
			</cfif>
		</td>
		<td>
			<div style='mso-element: footer' id="f1">
                <cfif !isNull(planDocumentTemplate.getPlanDocumentFooterText())>
			        <p class="MsoFooter">
						<span style='mso-tab-count:1'><cfif !isNull(planDocumentTemplate.getPlanDocumentFooterText())>#$.phiaPlan.replaceStringTemplatePhia(planDocumentTemplate.getPlanDocumentFooterText(),rc.clientGroupChecklistID)#</cfif></span>
					</p>
				</cfif>
				<p class="MsoFooter">
					<span style='mso-tab-count:2'></span><span style='mso-field-code:" PAGE "'></span> 
				</p>
            </div>
		</td>
	</tr>
</table>

</body>
</html>

</cfoutput>
</cfsavecontent>

<cfheader name="Content-Disposition" value="attachment; filename=#rereplace(rc.clientGroupChecklist.getClientGroupChecklistName(),'[^a-zA-z0-9]','_','all')#.doc">
<cfcontent type="application/msword" variable="#ToBinary(ToBase64(planDocument))#">
</cfif>