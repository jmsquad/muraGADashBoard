<cfset sortDir = rc.sortColumn>
<cfset sortCol = rc.sortDirection >

<cfif StructKeyExists(rc, 'errors') and IsArray(rc.errors) and ArrayLen(rc.errors)>
	<div class="alert alert-error">
		<button type="button" class="close" data-dismiss="alert"><i class="icon-remove-sign"></i></button>
		<h2>Alert!</h2>
		<h3>Please note the following message<cfif ArrayLen(rc.errors) gt 1>s</cfif>:</h3>
		<ul>
			<cfloop from="1" to="#ArrayLen(rc.errors)#" index="local.e">
				<li>
					<cfif IsSimpleValue(rc.errors[local.e])>
						<cfoutput>#rc.errors[local.e]#</cfoutput>
					<cfelse>
						<cfdump var="#rc.errors[local.e]#" />
					</cfif>
				</li>
			</cfloop>
		</ul>
	</div>
</cfif>

<cfif StructKeyExists(rc, 'message') AND Len(rc.message)>
	<div class="alert alert-success">
		<button type="button" class="close" data-dismiss="alert"><i class="icon-remove-sign"></i></button>
		<h2>Success!</h2>
		<cfoutput>
			<h3>#rc.message#</h3>
		</cfoutput>
	</div><!--- /.alert --->
</cfif>

<h2>Settings</h2>

<cfoutput>
<div class="tab-content">
	<div id="tabBasic" class="tab-pane active">
		<div class="row-fluid">
			<div class="span12">
				<input type="button" name="btnAdd" class="btn" value="Add Setting" onclick="location.href='#buildURL(action:'admin:setting.edit')#';">
			</div>
		</div>
		<br/>
		<table width="100%" class="table table-striped table-condensed table-bordered mura-table-grid">
			<tr>
				<th><a href="#getSortUrl("application_name")#">Application Name</a></th>
				<th><a href="#getSortUrl("service_account_email")#">Service Account Email</a></th>
				<th>Actions</th>
			</tr>
			<cfloop condition="#rc.settingIT.hasNext()#">
				<cfset pr = rc.settingIT.next()>
				<cfif len(pr.settingID)>
					<tr>
						<td>#pr.application_name#</td>
						<td>#pr.service_account_email#</td>
							<td class="actions">
								<ul class="form">
									<li >
										<a href="#buildURL(action="admin:setting.edit",querystring="settingID=#pr.settingID#")#" alt="Edit" title="Edit"><i class="icon-pencil"></i></a>
									</li>
									<li class="archive">
										<a href="#buildURL(action="admin:setting.delete",querystring="settingID=#pr.settingID#")#" alt="Delete" title="Delete" onclick="return confirm('Are you sure you want to delete the setting \'#pr.application_name#\'');"><i class="icon-trash"></i></a>
									</li>
								</ul>
							</td>
					</tr>
				</cfif>
			</cfloop>
		</table>
		<cfset pagerIT = rc.settingIT>
		<cfinclude template="../../MuraAdminPager.cfm">
	</div>
</div>
</cfoutput>

<cffunction name="getSortUrl" returntype="string">
	<cfargument name="sortColumn" required="true" >

	<cfset var l = {}>

	<cfset l.sortDirection = 'asc'>

	<cfif arguments.sortColumn eq sortCol AND sortDir eq 'asc'>
		<cfset l.sortDirection = 'desc'>
	</cfif>

	<cfset l.sortUrl = buildURL(action="admin:setting", queryString="sortColumn=#arguments.sortColumn#&sortDirection=#l.sortDirection#") >

	<cfreturn l.sortUrl />
</cffunction>
