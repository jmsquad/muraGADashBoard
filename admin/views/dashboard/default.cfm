<cfif rc.setup>
	<cfset event=request.event>
	<cfinclude template="../../../../../admin/core/views/cdashboard/js.cfm">
	<cfinclude template="../../../../../requirements/mura/backport/esapiencode.cfm">

	<cfset started=false>
	<cfparam name="application.sessionTrackingThrottle" default="false">
	<cfset variables.pluginEvent=createObject("component","mura.event").init(event.getAllValues())/>

	<cfoutput>
		<cfhtmlhead text='#rc.googleChartJS# <link rel="stylesheet" type="text/css" href="../plugins/muraGADashboard/includes/css/dashboard.css">'/>
		<cfinclude template="../../../../../admin/core/views/cdashboard/act_defaults.cfm"/>
		<div class="span9">

		<h1>#application.rbFactory.getKeyValue(session.rb,"dashboard.dashboard")#</h1>
		<cfinclude template="../../../../../admin/core/views/cdashboard/dsp_secondary_menu.cfm">

		<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardPrimaryTop',rc.siteid)>
		<cfif arrayLen(eventMappings)>
			<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
				<cfset renderedEvent=$.renderEvent(eventName='onDashboardPrimaryTop',index=i)>
				<cfif len(trim(renderedEvent))>
					<div<cfif started> class="divide"</cfif>>
						<h2><i class="icon-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
						#renderedEvent#
					</div>
					<cfset started=true>
				</cfif>
			</cfloop>
		</cfif>

		<cfif application.configBean.getSessionHistory() >
		<cfif not application.sessionTrackingThrottle>
		<div id="userActivity"<cfif started> class="divide"</cfif>>
		<h2><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")# <span><a href="./?muraAction=cDashboard.sessionSearch&siteid=#esapiEncode('url',rc.siteid)#&newSearch=true">(#application.rbFactory.getKeyValue(session.rb,"dashboard.advancedsessionsearch")#)</a></span></h2>
		<span id="userActivityData"></span>
		</div>
		<script type="text/javascript">dashboardManager.loadUserActivity('#esapiEncode('javascript',rc.siteid)#');</script>
		<cfset started=true>

		<div id="popularContent"<cfif started> class="divide"</cfif>>
		<h2><i class="icon-thumbs-up"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.popularcontent")# <span>(#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,"dashboard.span"),rc.span)#)</span></h2>
		<span id="popularContentData"></span>
		</div>
		<script type="text/javascript">dashboardManager.loadPopularContent('#esapiEncode('javascript',rc.siteid)#');</script>
		<cfset started=true>
		<cfelse>
		<div id="userActivity"<cfif started> class="divide"</cfif>>
		<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.useractivity")#</h2>
		<p>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.trackingthrottled")# </p>
		</div>
		<cfset started=true>
		</cfif>
		<div id="sessions7DaysContainer" <cfif started> class="divide"</cfif>>
			<h2>Sessions Last 7 Days</h2>
			<div id="sessions7Days"></div>
		</div>
		<div id="topPages7DaysContainer"<cfif started> class="divide"</cfif>>
			<h2>Top Pages 7 Days</h2>
			<div id="topPages7Days"></div>
		</div>
		<div id="topLandingPages7DaysContainer"<cfif started> class="divide"</cfif>>
			<h2>Top Landing Pages 7 Days</h2>
			<div id="topLandingPages7Days"></div>
		</div>
		<div id="topExitPages7DaysContainer"<cfif started> class="divide"</cfif>>
			<h2>Top Exit Pages 7 Days</h2>
			<div id="topExitPages7Days"></div>
		</div>
		<div id="topTrafficSourceContainer"<cfif started> class="divide"</cfif>>
			<h2>Top Traffic Source</h2>
			<div id="topTrafficSource"></div>
		</div>
		<div id="topTrafficChannelsContainer"<cfif started> class="divide"</cfif>>
			<h2>Top Traffic Channels</h2>
			<div id="topTrafficChannels"></div>
		</div>
		</cfif>

		<cfif yesNoFormat(application.configBean.getDashboardComments()) and application.settingsManager.getSite(session.siteid).getHasComments()
			and application.permUtility.getModulePerm('00000000000000000000000000000000015',rc.siteid)
			and application.contentManager.getRecentCommentsQuery(session.siteID,1,false).recordCount>
		<div id="recentComments"<cfif started> class="divide"</cfif>>
		<h2><i class="icon-comments"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.comments")# <span><a href="?muraAction=cComments.default&siteID=#session.siteID#">(#application.rbFactory.getKeyValue(session.rb,"dashboard.viewall")#)</a></span></h2>
		<span id="recentCommentsData"></span>
		</div>
		<script type="text/javascript">dashboardManager.loadRecentComments('#esapiEncode('javascript',rc.siteid)#');</script>
		<cfset started=true>
		</cfif>

		<cfif application.settingsManager.getSite(session.siteid).getdatacollection() and  application.permUtility.getModulePerm("00000000000000000000000000000000004","#session.siteid#")>
		<div id="recentFormActivity"<cfif started> class="divide"</cfif>>
		<h2><i class="icon-list"></i> #application.rbFactory.getKeyValue(session.rb,"dashboard.formactivity")#</h2>
		<span id="recentFormActivityData"></span>
		</div>
		<script type="text/javascript">dashboardManager.loadFormActivity('#esapiEncode('javascript',rc.siteid)#');</script>
		<cfset started=true>
		</cfif>

		<cfif application.settingsManager.getSite(session.siteid).getemailbroadcaster() and  application.permUtility.getModulePerm("00000000000000000000000000000000009","#session.siteid#")>

		<div id="emailBroadcasts" class="divide">
		<span id="emailBroadcastsData"></span>
		</div>

		<script type="text/javascript">dashboardManager.loadEmailActivity('#esapiEncode('javascript',rc.siteid)#');</script>
		<cfset started=true>
		</cfif>

		<cfif arrayLen(eventMappings)>
			<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
				<cfset renderedEvent=$.renderEvent(eventName='onDashboardPrimaryBottom',index=i)>
				<cfif len(trim(renderedEvent))>
					<div<cfif started> class="divide"</cfif>>
						<h2><i class="icon-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
						#renderedEvent#
					</div>
					<cfset started=true>
				</cfif>
			</cfloop>
		</cfif>

		</div>
		<!---- If there's nothing in the main body of the dashboard just move on the the site manager--->
		<cfif not started>
		<cflocation url="./?muraAction=cArch.list&siteid=#session.siteID#&moduleid=00000000000000000000000000000000000&topid=00000000000000000000000000000000001" addtoken="false">
		</cfif>

		<div id="contentSecondary" class="sidebar span3">

		<div>
		<!--- <h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.keywordsearch")#</h2> --->
		<!--- <p>#application.rbFactory.getKeyValue(session.rb,"dashboard.searchtext")#:</p> --->
		<form novalidate="novalidate" id="siteSearch" name="siteSearch" method="get">
			<!--- <input name="keywords" value="#esapiEncode('html_attr',session.keywords)#" type="text" class="search-query" placeholder="Enter Keywords" />
			<input type="button" class="btn" onclick="submitForm(document.forms.siteSearch);" value="Search" /> --->
			<div class="input-append">
			    <input name="keywords" value="#esapiEncode('html_attr',session.keywords)#" type="text" placeholder="Enter Keywords" />
			    <button type="button" class="btn" onclick="submitForm(document.forms.siteSearch);"><i class="icon-search"></i></button>
			</div>
			<input type="hidden" name="muraAction" value="cArch.list">
			<input type="hidden" name="activetab" value="1">
			<input type="hidden" name="siteid" value="#esapiEncode('html_attr',rc.siteid)#">
			<input type="hidden" name="moduleid" value="00000000000000000000000000000000000">
		</form>
		</div>

		<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardSideBarTop',rc.siteid)>
		<cfif arrayLen(eventMappings)>
			<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
				<cfset renderedEvent=$.renderEvent(eventName='onDashboardSideBarTop',index=i)>
				<cfif len(trim(renderedEvent))>
					<div class="divide">
						<h2><i class="icon-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
						#renderedEvent#
					</div>
				</cfif>
			</cfloop>
		</cfif>

		<div id="siteSummary" class="well">
		<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitesummary")#</h2>
		<dl>
			<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.activepages")#</dt>
			<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"Page").total#</span></dd>
			<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.files")#</dt>
			<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"File").total#</span></dd>
			<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.links")#</dt>
			<dd><span class="badge">#application.dashboardManager.getcontentTypeCount(rc.siteID,"Link").total#</span></dd>
			<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.internalfeeds")#</dt>
			<dd><span class="badge">#application.dashboardManager.getFeedTypeCount(rc.siteID,"Local").total#</span></dd>
			<cfif application.settingsManager.getSite(rc.siteID).getExtranet() eq 1><dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.sitemembers")#</dt>
			<dd><span class="badge">#application.dashboardManager.getTotalMembers(rc.siteID)#</span></dd></cfif>
			<dt>#application.rbFactory.getKeyValue(session.rb,"dashboard.administrativeusers")#</dt>
			<dd><span class="badge">#application.dashboardManager.getTotalAdministrators(rc.siteID)#</span></dd>
		</dl>
		</div>

		<div id="recentcontent" class="well">
		<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.recentcontent")#</h2>
		<cfset rsList=application.dashboardManager.getRecentUpdates(rc.siteID,5) />
		<ul>
			<cfloop query="rslist">
			<cfset crumbdata=application.contentManager.getCrumbList(rslist.contentid, rc.siteid)/>
			<cfset verdict=application.permUtility.getnodePerm(crumbdata)/>
			<cfif verdict neq 'none'>
			<li><a title="Version History" href="./?muraAction=cArch.hist&contentid=#rslist.ContentID#&type=#rslist.type#&parentid=#rslist.parentID#&topid=#rslist.contentID#&siteid=#esapiEncode('url',rc.siteid)#&moduleid=#rslist.moduleid#">#esapiEncode('html',rsList.menuTitle)#</a> #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #esapiEncode('html',rsList.lastUpdateBy)# <span>(#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</span></li>
			<cfelse><li>#esapiEncode('html',rslist.menuTitle)# #application.rbFactory.getKeyValue(session.rb,"dashboard.by")# #esapiEncode('html',rsList.lastUpdateBy)# <span>(#LSDateFormat(rsList.lastUpdate,session.dateKeyFormat)#)</span></li>
			</cfif>
			</cfloop>
		</ul>
		</div>

		<cfset eventMappings=$.getBean('pluginManager').getEventMappings('onDashboardSideBarBottom',rc.siteid)>
		<cfif arrayLen(eventMappings)>
			<cfloop from="1" to="#arrayLen(eventMappings)#"	index="i">
				<cfset renderedEvent=$.renderEvent(eventName='onDashboardSideBarBottom',index=i)>
				<cfif len(trim(renderedEvent))>
					<div class="divide">
						<h2><i class="icon-cog"></i> #esapiEncode('html',eventMappings[i].pluginName)#</h2>
						#renderedEvent#
					</div>
				</cfif>
			</cfloop>
		</cfif>
		</div>
	</cfoutput>
<cfelse>
	Your google dashboard has not been setup please setup your google dashboard, or contact an administrator to have it setup.
</cfif>