/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.pluginGenericEventHandler" {

	// framework variables
	include 'fw1config.cfm';

	// ========================== Mura CMS Specific Methods ==============================
	// Add any other Mura CMS Specific methods you need here.

	public void function onApplicationLoad(required struct $) {
		// trigger FW/1 to reload
		lock scope='application' type='exclusive' timeout=20 {
			getApplication().setupApplicationWrapper(); // this ensures the appCache is cleared as well
		};

		// register this file as a Mura eventHandler
		variables.pluginConfig.addEventHandler(this);
	}

	//This controls the mura dashboard
	public any function onDashboardReplacement(required struct $){
		param name="local.dashboard" default='';
		//Does user have permission to the plugin?
		if(application.permUtility.getModulePerm(application[variables.framework.applicationKey].pluginConfig.getModuleID(), session.siteid)){
			local.dashboard=getApplication().doAction('admin:dashboard.default');
		}
		return local.dashboard;
	}

// public void function onSiteRequestStart(required struct $) {
	// 	// make the methods in displayObjects.cfc accessible via $.packageName.methodName()
	// 	arguments.$.setCustomMuraScopeKey(variables.framework.package, new displayObjects());
	// }

	// public any function onRenderStart(required struct $) {
	// 	arguments.$.loadShadowboxJS();
	// }

	// ========================== Helper Methods ==============================

	private any function getApplication() {
		if( !StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}

}

