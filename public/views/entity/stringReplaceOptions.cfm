<cfoutput>
<cfif arrayLen(rc.data)>
	<cfloop array="#rc.data#" index="tooltipdata" >
		<p>#tooltipdata#</p>
	</cfloop>
<cfelse>
	<p>No replacement options available</p>
</cfif>
</cfoutput>
	
<!---
http://phiaplan/?PPAction=entity.stringreplaceoptions&replacevariable={PO1.A2.answertexts.1}
--->