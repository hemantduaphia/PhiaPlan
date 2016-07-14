<cfparam name="rc.permissionGroup" type="any" />
<cfparam name="rc.edit" type="boolean" />
<cfparam name="rc.editEntityName" type="string" default="" />

<cf_HibachiPermissionGroupEntityPermissions permissionGroup="#rc.permissionGroup#" edit="#rc.edit#" editEntityName="#rc.editEntityName#" />