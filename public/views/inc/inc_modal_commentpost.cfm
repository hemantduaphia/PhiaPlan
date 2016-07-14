<!--- COMMENTS VIEW --->
<div id="postCommentModal" class="modal hide fade">
	<div class="modal-header">
		<a class="close" data-dismiss="modal">x</a>
		<h3 id="myModalLabel">Post New Comment</h3>
	</div>
	<div class="modal-body">
		<!--- content will be loaded here --->
	</div>
</div>

<!---
<script>
$(function() {
	$("a[data-target=#postCommentModal]").click(function(ev) {
	    $("#postCommentModal .modal-body").html('Nothing!');
		ev.preventDefault();
		
	    var target = $(this).attr("href");
	
		$("#postCommentModal .modal-body").unbind().html('<span class="progressLoad"><img src="/assets/images/loader.gif"></span>');

	    // load the url and show modal on success
	    $("#postCommentModal .modal-body").load(target, function() {  

	    });
	});	
});	
</script>
--->