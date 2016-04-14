/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

	NOTES:
		All ADMIN controllers should EXTEND this file.

*/
component persistent="false" accessors="true" output="false" extends="mura.cfobject" {

	property name='$';
	property name='fw';
	property config;

	public any function init (required any fw) {
		setFW(arguments.fw);
	}

	public any function before(required struct rc) {
		if ( StructKeyExists(rc, '$') ) {
			var $ = rc.$;
			set$(rc.$);
		}

		if(not structKeyExists(rc,'errors') or not isArray(rc.errors))
			rc.errors = [];

		getconfig().setDatasource(rc.pc.getSetting('muraCustomDatasource'));
		getconfig().setSchema(rc.pc.getSetting('muraCustomSchema'));

		if ( !rc.isAdminRequest ) {
			location(url='#rc.$.globalConfig('context')#/', addtoken=false);
		}

	}

	private void function checkBeanForErrors(required any bean, required struct rc){
		if(not structKeyExists(bean,'hasErrors'))
			throw "checkBeanForErrors expects a single bean.";
		if(not structKeyExists(rc,'errors') or not isArray(rc.errors))
			rc.errors = [];
		if(bean.hasErrors()){
				for(local.errStruct in bean.getErrors()){
					arrayAppend(rc.errors,local.errStruct);
				}
		}
	}

}