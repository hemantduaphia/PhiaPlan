<cfif listFindNoCase("PhiaPlan,PhiaPlan.ten24web.com",CGI.SERVER_NAME)>
	<cfoutput>#body#</cfoutput>
<cfelse>
	<div id="content_container">
		<p align="center">There was an error processing your request. Please try again later.</p>
	</div>
	<cfmail from="errors@ten24web.com" to="errors@ten24web.com" type="html" subject="Error on #server_name#"><cfdump var="#cgi#" top="3">#body#</cfmail>
</cfif>

