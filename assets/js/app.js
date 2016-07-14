var pageInitialized = false;

jQuery(document).ready(function() {
	
	replaceVariables();
	showVariableOptions();

	// RESET EXCLUDES
	$('input[type=radio]').mouseup(function(){
		var tmpExcludeID = $(this).attr('id');
		var tmpExcludeList = $('#' + tmpExcludeID).attr('data-excludedquestionids');

		if (tmpExcludeList) {
			
			var tmpExcludeListArray = tmpExcludeList.split(",");
			$.each(tmpExcludeListArray, function(i){
				$('#'+tmpExcludeListArray[i]).removeClass('excludeQuestion');	
			});	
		}

	});

	function clearFormField(id) {
		
		// Clear Answers
		$('#'+id).find(':input').each(function() {

			switch(this.type) {
				case 'password':
				case 'text':
				case 'textarea':
				case 'file':
				case 'select-one':
				case 'select-multiple':
				    jQuery(this).val('');
        		    break;
        		case 'checkbox':
        		case 'radio':
        			this.checked = false;
			}
		});
		
	}

	function hideChildren(id) {
		// console.log(id)
		
		$('.'+ id).slideUp( "fast", function() {
		
			// Clear values
			clearFormField(this.id);
		
			// Recursively hide related children
			hideChildren(this.id);
			
		});
	}

	jQuery('body').on('change', ':input', function(e){
		var elm = $(e.target);
		var questionParentID = $(this).closest('.questionDisplay').attr('id');
		
		var questionID = elm.attr('data-questionid');
		
		// RESET / HIDE
		if(elm.attr('id') != undefined && elm.attr('data-questionid') != undefined) {	
			
			// HIDE SIBLING RADIOS
			$('#'+questionID).find('input:radio:not(:checked)').each(function(){
				$('.'+ this.id).slideUp( "fast", function() {
					
					// CLEAR THE FORM SELECTION
					clearFormField(this.id);
			
					// HIDE THEIR KIDS
					hideChildren(this.id);
				});
				
			});
			
			// RESET EXCLUDED
			if (elm.attr('data-excludedquestionids') != undefined) {
				$('*[data-hiddenbyquestionid=' + questionParentID + ']').removeClass('excludeQuestion');
			};
			
		}

		if (elm.attr('data-excludedquestionids') != undefined) {
			var elmExcluded = elm.attr('data-excludedquestionids').split(",");	

			if(elmExcluded != "") {
				$.each(elmExcluded, function(i){
					var tmpHide = elmExcluded[i];

					$('#'+tmpHide).addClass('excludeQuestion');	
					$('#'+tmpHide).attr('data-hiddenbyquestionid',questionParentID);	
				});
			}
		}
		
		if(elm.attr('id') != undefined && elm.attr('data-questionid') != undefined) {			
			
			if (elm.is(':checked')) {
			
				// show all related to this answer
				$('.'+elm.attr('id')).slideDown();
  				
			} else {
				// hide all related to this question
				$('.'+elm.attr('id')).slideUp();	
				
			}
			
		}	

	});
	
	if (!pageInitialized) {
		$(':input').each(function(){
			var elm = $(this);
			
			if (elm.attr('type') == 'radio' && elm.is(':checked')) {

				if (elm.attr('id') != undefined && elm.attr('data-questionid') != undefined) {
					// hide all related to this question
					$('.' + elm.attr('data-questionid')).slideUp();
					// show all related to this answer
					$('.' + elm.attr('id')).slideDown();
				}
			}

			// show any related questions to selected checkbox answer
			if (elm.attr('type') == 'checkbox' && elm.is(':checked')) {
			
				$('.' + elm.attr('id')).slideDown();
			
			}
		});
	}
	
	pageInitialized = true;
});



function replaceVariables() {
	// find each variables
	if(!$('#plandocumentsectiontext').html()){return;}
	var checklistid = '';
	if($('div[name=currentchecklist]')){
		var checklistid = $('div[name=currentchecklist]').attr('data-checklistid');
	}
	var variableArray = $('#plandocumentsectiontext').html().match(/\$\{([^\}]+)\}/gi);
	if(variableArray != undefined && variableArray.length) {
		$.each(variableArray, function(index, value) {
			// console.log(value);
			var lookupValue = value.replace("\$","\\$");
			//var questioncode = value.substring(2,value.indexOf("."));
			var newValue = '<span class="lookup" data-lookupvalue="'+value.replace("\$","")+'" data-checklistid="'+checklistid+'">'+value+'</span>';
			//console.log(lookupValue);
			//console.log(newValue);
			$('#plandocumentsectiontext').html(function(i, oldhtml) {
				var regex = new RegExp(lookupValue,"gi");
				return oldhtml.replace(regex,newValue);
			});
		});
	}
}

function showVariableOptions() {
	$('.lookup').each(function() {
		var url = '/?PPAction=entity.stringreplaceoptions&replacevariable='+$(this).data('lookupvalue')+'&checklistid='+$(this).data('checklistid');
        
        $(this).hover().qtip({
			content: {
				title: {
		            text: '',
		            button: 'Close'
		         },
                text: 'Loading...',
                ajax: {
                    url: url,
                    loading: false
                }
            },            

            style: {
                classes: 'myCustomClass'
            },

            show: {
                solo: true
            },

            position: {                
                viewport: $(window),
                target: $(this),
                my: 'top center',
                at: 'bottom center'
            },

            hide: 'unfocus'

        });
    });
}

$(document).ready(function() {

	$('.questionHintIcon').popover({
		trigger: 'hover',
		title: 'Hint'
	});

	$(".editCommentBtn").click(function() {
		$('#viewCommentModal').modal('hide');
	});	

	$( ".datepickCustom" ).datepicker({ dateFormat: "MM d, yy" });
	
});