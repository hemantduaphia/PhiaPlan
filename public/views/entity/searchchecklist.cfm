<!---<cfoutput>#url.checklistID#</cfoutput>--->
<cfparam name="form.keyword" default="" />

<cfoutput>
	
<form class="form-inline" id="searchForm">
  <input type="text" class="input" name="keyword" placeholder="Search..." value="#form.keyword#">
  <span class="btn btn-primary submitForm">Search</span>
</form>	

<div id="resultsBlock"></div>

<script>
	$(document).on("keypress", 'form', function (e) {
	    var code = e.keyCode || e.which;
	    if (code == 13) {
	        e.preventDefault();
			$('.submitForm').trigger( "click" );
	        return false;
	    }
	});

	$('.submitForm').click(function(e) {
		$.ajax({
			url: "/?previewonly=true&PPAction=entity.searchchecklistresults&checklistID=#rc.checklistID#&clientgroupchecklistID=#url.clientgroupchecklistID#",
			type: "POST",
			data: $("##searchForm").serialize(),
			beforeSend: function() {
				
				$(".submitForm").text('Searching...');
				
				}
			})
			.done(function( data ) {
				$(".submitForm").text('Search');
				
				$('##resultsBlock').html(data);
			}
		);		
		return false			

	});
</script>
</cfoutput>