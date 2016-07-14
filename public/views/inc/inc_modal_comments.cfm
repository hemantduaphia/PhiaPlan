<!--- COMMENTS VIEW --->
<div id="viewCommentModal" class="modal hide">
    <div class="modal-header">
       	<a class="close closeView" data-dismiss="modal">x</a>
        <h3>Comments</h3>
    </div>
    <div class="modal-body"></div>
</div>


<!---
<script>
$(function() {
	$("a[data-target=#viewCommentModal]").click(function(ev) {
	    ev.preventDefault();
	    var target = $(this).attr("href");
	
		$("#viewCommentModal .modal-body").html('<span class="progressLoad"><img src="/assets/images/loader.gif"></span>');
	
	    // load the url and show modal on success
	    $("#viewCommentModal .modal-body").load(target, function() {  

	    });
	});	
});	
</script>
--->