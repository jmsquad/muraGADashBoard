/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="true" extends="mura.plugin.plugincfc" {

	property name="config" type="any" default="";

	public any function init(any config='') {
		setConfig(arguments.config);
	}

	public void function install() {
		// triggered by the pluginManager when the plugin is INSTALLED.
		runSql(sqlType=application.configBean.getDBType(),action='Install');
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		// We are going to check to make sure the tables are created by using the install action which checks to see if the tables exist before creation.
		runSql(sqlType=application.configBean.getDBType(),action='Update');
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		runSql(sqlType=application.configBean.getDBType(),action='Delete');
	}

	private void function runSql(required string sqlType,required string action) {
		// Check if we have the proper databases
		if ( listFindNoCase('mysql,postgresql,mssql,oracle',application.configBean.getDBType(),',') EQ 0 ) {
			writeOutput('
				<h1> #application.configBean.getDBType()# had a problem installing</h1>
				<p>Only MySQL, Microsoft SQL Server, PostgreSQL and Oracle are supported.</p>'
			);
			abort;
		}
		local.event = {
			'error' = false,
			'message' = ''
		};
		try {
			savecontent variable='local.sql' {
				include '../dbScripts/#arguments.sqlType##arguments.action#.cfm';
			}
		} catch (any e) {
			writeOutput('
				<h1> #arguments.sqlType# had a problem installing</h1>
				<p>Could not find the #arguments.sqlType##arguments.action#.cfm file.</p>'
			);
			abort;
		}

		local.aSql = listToArray(local.sql,';');
		transaction {
			for(local.x in local.aSql) {
				if ( len(trim(local.x)) ) {
					try {
						local.query = new query();
						local.query.setDatasource(application.configBean.getDatasource());
						local.query.setSQL(preserveSingleQuotes(local.x));
						local.query.execute();
					} catch (any e) {
						local.event.error = true;
						local.event.message = listAppend(local.event.message,structKeyExists(e,"message") ? e.message & (structKeyExists(e,'RootCause') ? ': ' & e.RootCause.message & ': ' & e.RootCause.Detail:'') : '');
					}
				}
			}
			if ( local.event.error ) {
				transaction action='rollback';
				writeOutput('
					<h1> #arguments.sqlType# had a problem installing</h1>
					<p>#local.event.message#</p>'
				);
				abort;
			}
		}
	}


}