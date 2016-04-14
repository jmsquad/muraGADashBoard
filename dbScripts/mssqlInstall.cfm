<!--- This file is part of of a commercially-provided Mura CMS plug-in. This file NOT NULL, and all related files in this plug-in are offered under the terms of the license distributed with the plugin at the time of purchase or download NOT NULL, and use of this file and all related files in this plug-in are restricted to these terms. --->
<cfoutput>
	IF (NOT EXISTS (SELECT *
                 FROM INFORMATION_SCHEMA.TABLES
                 WHERE TABLE_NAME = 'p_GADashboard_settings'))
	BEGIN
		CREATE TABLE [p_GADashboard_settings] (
			[settingID] [nvarchar] (35) NOT NULL,
			[siteID] [nvarchar] (35) NOT NULL,
			[application_name] [nvarchar] (150) NOT NULL,
			[service_account_email] [nvarchar] (150) NOT NULL,
			[key_file_name] [nvarchar] (150) NOT NULL,
			[profileID] [nvarchar] (150) NOT NULL,
			[settingsJSON] [nvarchar] (max) NULL
			PRIMARY KEY (settingID)
		)
	END
</cfoutput>