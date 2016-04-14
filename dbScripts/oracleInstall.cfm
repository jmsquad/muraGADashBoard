<!--- This file is part of of a commercially-provided Mura CMS plug-in. This file, and all related files in this plug-in are offered under the terms of the license distributed with the plugin at the time of purchase or download, and use of this file and all related files in this plug-in are restricted to these terms. --->
<cfoutput>

CREATE TABLE IF NOT EXISTS "#ucase('p_GADashboard_settings')#"
	(	"SETTINGID" NVARCHAR(35),
	"SITEID" NVARCHAR(35),
	"APPLICATION_NAME" NVARCHAR(150),
	"SERVICE_ACCOUNT_EMAIL" NVARCHAR(150),
	"KEY_FILE_NAME" NVARCHAR(150),
	"PROFILEID" NVARCHAR(150),
	"SETTINGSJSON" NVARCHAR(MAX)
	);


ALTER TABLE "#ucase('p_GADashboard_settings')#" ADD CONSTRAINT "#ucase('p_GADashboard_settings')#_SETTINGID" PRIMARY KEY ("SETTINGID") ENABLE;
ALTER TABLE "#ucase('p_GADashboard_settings')#" MODIFY ("SETTINGID" NOT NULL ENABLE);
ALTER TABLE "#ucase('p_GADashboard_settings')#" MODIFY ("SITEID" NOT NULL ENABLE);
ALTER TABLE "#ucase('p_GADashboard_settings')#" MODIFY ("SERVICE_ACCOUNT_EMAIL" NOT NULL ENABLE);
ALTER TABLE "#ucase('p_GADashboard_settings')#" MODIFY ("KEY_FILE_NAME" NOT NULL ENABLE);
ALTER TABLE "#ucase('p_GADashboard_settings')#" MODIFY ("PROFILEID" NOT NULL ENABLE);
</cfoutput>