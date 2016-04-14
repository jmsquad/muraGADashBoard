<!--- This file is part of of a commercially-provided Mura CMS plug-in. This file, and all related files in this plug-in are offered under the terms of the license distributed with the plugin at the time of purchase or download, and use of this file and all related files in this plug-in are restricted to these terms. --->
<cfoutput>
CREATE TABLE IF NOT EXISTS `p_GADashboard_settings` (
	`settingID` nvarchar(35) NOT NULL,
	`siteID` nvarchar(35) NOT NULL,
	`application_name` nvarchar(150) NOT NULL,
	`service_account_email` nvarchar(150) NOT NULL,
	`key_file_name` nvarchar(150) NOT NULL,
	`profileID` nvarchar(150) NOT NULL,
	`settingsJSON` nvarchar(max) NULL,
	PRIMARY KEY (`settingID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
</cfoutput>