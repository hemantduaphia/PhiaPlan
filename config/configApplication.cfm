<!--- Place Application Specific Values Here --->
<cfset this.name = "PhiaPlan" & hash(getCurrentTemplatePath()) /> 	<!--- This currently mirrors what hibachi does by default --->
<cfset this.datasource.name = "PhiaPlan" />							<!--- This currently mirrors what hibachi does by default --->