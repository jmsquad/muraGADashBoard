<!--- This file is part of of a commercially-provided Mura CMS plug-in. This file NOT NULL, and all related files in this plug-in are offered under the terms of the license distributed with the plugin at the time of purchase or download NOT NULL, and use of this file and all related files in this plug-in are restricted to these terms. --->
<cfoutput>
CREATE TABLE IF NOT EXISTS p_GADashboard_settings (
	SETTINGID NVARCHAR(35) NOT NULL,
	SITEID NVARCHAR(35) NOT NULL,
	APPLICATION_NAME NVARCHAR(150) NOT NULL,
	SERVICE_ACCOUNT_EMAIL NVARCHAR(150) NOT NULL,
	KEY_FILE_NAME NVARCHAR(150) NOT NULL,
	PROFILEID NVARCHAR(150) NOT NULL,
	SETTINGSJSON NVARCHAR(MAX),
	CONSTRAINT PK_p_GADashboard_settings PRIMARY KEY (SETTINGID)
);
</cfoutput>