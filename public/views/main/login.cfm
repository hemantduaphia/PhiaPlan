<cfparam name="rc.accountAuthenticationExists" type="boolean" />
		
<cfoutput>
	<div style="width:100%;">
		<cfset authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login") />
		<cfset updateProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("updatePassword") />
		
		<div class="well tabable" style="width:400px;margin: 0px auto;">
			<!--- UPDATE PASSWORD BECAUSE OF FORCE RESET --->
			<cfif (authorizeProcessObject.hasError('passwordUpdateRequired') OR updateProcessObject.hasErrors())>
				<h3>Password Update Required</h3>
				<br />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="#rc.fw.getAction()#" value="main.updatePassword" />
					<fieldset class="dl-horizontal">
						<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#updateProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" />
						<cf_HibachiPropertyDisplay object="#updateProcessObject#" property="existingPassword" edit="true" />
						<cf_HibachiPropertyDisplay object="#updateProcessObject#" property="password" edit="true" />
						<cf_HibachiPropertyDisplay object="#updateProcessObject#" property="passwordConfirm" edit="true" />
						<fieldset class="dl-horizontal">
						<button type="submit" class="btn btn-primary pull-right">#$.PhiaPlan.rbKey('define.login')#</button>
					</fieldset>
				</form>
		
			<!--- LOGIN & FORGOT PASSWORD --->
			<cfelse>
				<!--- LOGIN --->
				<h3>Login</h3>
				<br />
				<form action="?s=1" class="form-horizontal" method="post">
					<input type="hidden" name="#rc.fw.getAction()#" value="main.authorizelogin" />
					<fieldset class="dl-horizontal">
						<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="emailAddress" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.emailAddress')#" />
						<fieldset class="dl-horizontal">
						<cf_HibachiPropertyDisplay object="#authorizeProcessObject#" property="password" edit="true" title="#rc.fw.getHibachiScope().rbKey('entity.account.password')#" />
						<button type="submit" class="btn btn-primary pull-right">Login</button>
					</fieldset>
				</form>
			</cfif>
		</div>
	</div>
</cfoutput>