<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.object" type="any" />
	
	<cfoutput>
		<ul class="thumbnails">
				<cfloop array="#attributes.object.getDocuments()#" index="document">
				<li class="span3">
    				<div class="thumbnail">
    					<div class="img-container">
	    					<a href="#document.getDocumentPath()#" target="_blank">
								#document.getDocumentName()#
							</a>
						</div>
						<hr />
						<div class="small em document-caption">#document.getDocumentPath()#</div>
						<cf_HibachiActionCaller action="admin:entity.detailDocument" querystring="documentID=#document.getDocumentID()#" class="btn" iconOnly="true" icon="eye-open" />
						<cf_HibachiActionCaller action="admin:entity.editDocument" querystring="documentID=#document.getDocumentID()#" class="btn" iconOnly="true" icon="pencil" />
						<cf_HibachiActionCaller action="admin:entity.deleteDocument" querystring="documentID=#document.getDocumentID()#&#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&redirectAction=#request.context.PPAction#" class="btn" iconOnly="true" icon="trash" confirm="true" />				
    				</div>
  				</li>
			</cfloop>
		</ul>
		<cf_HibachiActionCaller action="admin:entity.createDocument" querystring="#attributes.object.getPrimaryIDPropertyName()#=#attributes.object.getPrimaryIDValue()#&objectName=#attributes.object.getClassName()#&redirectAction=#request.context.PPAction#" modal="true" class="btn" icon="plus" />
	</cfoutput>
</cfif>