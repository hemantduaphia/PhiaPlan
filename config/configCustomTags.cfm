<!--- Place Application Specific Custom Tag Settings Here --->
<cfset arrayAppend(this.customTagPathsArray, "#replace(replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all"), "/config/", "/tags")#") />
