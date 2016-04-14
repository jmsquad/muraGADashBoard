component accessors=true extends='muraGADashboard.includes.model.baseClasses.baseDAO' {

	function init(beanFactory, config) {
		variables.beanFactory = beanFactory;
		variables.config = config;
		variables.columnList = 'siteID,application_name,service_account_email,key_file_name,profileID,settingsJSON';

		return this;
	}

	public any function delete(required any bean) {
		try{
			var qry = new query();
			qry.setDatasource(application.configBean.getDatasource());

			var sqlString = 'Delete from p_GADashboard_settings where settingID = :pkValue';
			qry.addParam(name='pkValue', value='#arguments.bean.getSettingID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.setSQL(sqlString);

			qry.execute();
		} catch (any e) {
			bean.setError('Record was not deleted.',e);
		}
		return bean;
	}

	public array function get() {
		var maxRowsString = "";
		if(structkeyexists(arguments, 'maxrows') and isValid("integer",arguments.maxrows))
			maxRowsString = "top #arguments.maxrows#";

		var qry = new query();
		var sqlString = "select #maxRowsString# siteID,
								s.settingID,
								s.application_name,
								s.service_account_email,
								s.key_file_name,
								s.profileID,
								s.settingsJSON
						from p_GADashboard_settings s
						where siteID = :siteID ";
		qry.addParam(name='siteID', value='#session.siteid#',CFSQLTYPE='CF_SQL_VARCHAR');

		if(structkeyexists(arguments, 'application_name')){
			sqlString &= ' and application_name = :param2';
			qry.addParam(name='param2', value='#arguments.application_name#',CFSQLTYPE='CF_SQL_VARCHAR');
		}

		if(structkeyexists(arguments, 'service_account_email')){
			sqlString &= ' and service_account_email = :param2';
			qry.addParam(name='param2', value='#arguments.service_account_email#',CFSQLTYPE='CF_SQL_VARCHAR');
		}

		if(structkeyexists(arguments, 'key_file_name')){
			sqlString &= ' and key_file_name = :param3';
			qry.addParam(name='param3', value='#arguments.key_file_name#',CFSQLTYPE='CF_SQL_VARCHAR');
		}

		if(structkeyexists(arguments, 'profileID')){
			sqlString &= ' and profileID = :param2';
			qry.addParam(name='param2', value='#arguments.profileID#',CFSQLTYPE='CF_SQL_VARCHAR');
		}

		if(structKeyExists(arguments,'orderby'))
			sqlString &= ' ' & validateOrderBy(arguments.orderBy);

		qry.setDatasource(application.configBean.getDatasource());
		qry.setSQL(sqlString);

		try{
			return queryToBeanArray(qry.execute().getResult(),'setting');
		} catch(any e){
			var bean = variables.beanFactory.getBean('setting');
			bean.setError('Get Failed', e);
			return [bean];
		}
	}

	public any function save(required any bean) {
		var qry = new query();
		var sqlString = "";

		qry.setDatasource(application.configBean.getDatasource());

		//first Do product Record
		if(len(bean.getValue('settingID')) eq 0){
			bean.setSettingID(createUUID());
			sqlString = 'Insert Into p_GADashboard_settings(
				settingID,
				siteID,
				application_name,
				service_account_email,
				key_file_name,
				profileID,
				settingsJSON)'
				& ' values(:settingID,:siteID,:application_name,:service_account_email,:key_file_name,:profileID,:settingsJSON); ';
			qry.addParam(name='settingID', value='#arguments.bean.getSettingID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='siteID', value='#arguments.bean.getSiteID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='application_name', value='#arguments.bean.getApplication_name()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='service_account_email', value='#arguments.bean.getService_account_email()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='key_file_name', value='#arguments.bean.getKey_file_name()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='profileID', value='#arguments.bean.getProfileID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='settingsJSON', value='#arguments.bean.getSettingsJSON()#',CFSQLTYPE='CF_SQL_VARCHAR');
		}
		else{
			sqlString = 'Update p_GADashboard_settings Set'
				& ' siteID = :siteID,'
				& ' application_name = :application_name,'
				& ' service_account_email = :service_account_email,'
				& ' key_file_name = :key_file_name,'
				& ' profileID = :profileID,'
				& ' settingsJSON = :settingsJSON'
				& ' where settingID = :settingID';
			qry.addParam(name='siteID', value='#arguments.bean.getSiteID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='application_name', value='#arguments.bean.getApplication_name()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='service_account_email', value='#arguments.bean.getService_account_email()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='key_file_name', value='#arguments.bean.getKey_file_name()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='profileID', value='#arguments.bean.getProfileID()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='settingsJSON', value='#arguments.bean.getSettingsJSON()#',CFSQLTYPE='CF_SQL_VARCHAR');
			qry.addParam(name='settingID', value='#arguments.bean.getSettingID()#',CFSQLTYPE='CF_SQL_VARCHAR');
		}
		qry.setSQL(sqlString);

		try{
			qry.execute();
		} catch(any e){
			bean.setError('Record was not saved.', e);
		}
		return bean;
	}
}
