component persistent='false' accessors='true' output='false' extends='controller' {
	property settingService;
	include '../../includes/fw1config.cfm'; // framework variables

	public any function before(required struct rc) {
		super.before(rc);
		rc.iteratorPageSize = 25;
	}

	// *********************************  PAGES  *******************************************
	public any function default(required struct rc ) {
		param name="rc.sortColumn" default="settingID";
		param name="rc.sortDirection" default="desc";
		param name="rc.page" default=1;
		param name="rc.attributes.keyword" default="";

		local.args = {};
		local.args.orderBy = "#rc.sortColumn# #rc.sortDirection#";

		if(not(isValid("integer",rc.page)))
			rc.page=1;

		rc.setting = getSettingService().get(argumentCollection=local.args);
		checkBeanForErrors(rc.setting[1],rc);

		rc.settingIT = getSettingService().getIteratorFromBeanArray(rc.setting);

		rc.settingIT.setNextN(rc.iteratorPageSize);
		rc.settingIT.setPage(rc.page);
	}

	public any function delete(required struct rc ) {
		if(structKeyExists(rc,"settingID")){
			rc.setting = getSettingService().get(providerID=rc.settingID)[1];
			getSettingService().delete(rc.setting);
		}

		fw.redirect("admin:setting.default");
	}

	public any function edit(required rc) {
		param name="rc.extraSettingsNumber" default="0";
		if(structKeyExists(rc,'settingID')) {
			rc.form = getSettingService().get(settingID=rc.settingID)[1];
			if ( len(rc.form.getSettingsJSON()) ) {
				rc.extraSettings = deSerializeJSON(rc.form.getSettingsJSON());
				rc.extraSettingsNumber = structCount(rc.extraSettings);
				local.i = 1;
				for (local.key in rc.extraSettings) {
					rc['settingName#local.i#'] = local.key;
					rc['settingValue#local.i#'] = rc.extraSettings[local.key];
					local.i++;
				}
			}
		} else {
			rc.form = getSettingService().getNew();
		}
	}

	public any function save(required rc){
		param name="rc.isActive" default="1";

		local.fileLocation = expandPath("/#variables.framework.package#/includes/keyfiles");
		// upload the key_file_name
		local.file = fileUpload(local.fileLocation,'key_file_name','application/x-pkcs12','overwrite');
		rc.key_file_name = local.file.clientFile;

		// Save the siteID
		rc.siteID = rc.$.siteConfig('siteid');
		var bean = getSettingService().getNew();

		if(len(rc.settingID) gt 0)
			bean = getSettingService().get(settingID=rc.settingID)[1];

		if ( rc.extraSettingsNumber GT 0 ) {
			rc.settingsJSON = {};
			for (local.i=1;local.i LTE rc.extraSettingsNumber;local.i++) {
				local.struct = {
					'#rc['settingName#local.i#']#':'#rc['settingValue#local.i#']#'
				};
				structAppend(rc.settingsJSON,local.struct);
			}
			rc.settingsJSON = serializeJSON(rc.settingsJSON);
		} else {
			rc.settingsJSON = '';
		}

		bean.set(rc);

		bean = getSettingService().save(bean);

		checkBeanForErrors(bean,rc);

		if(arraylen(rc.errors))
			fw.redirect(action="admin:setting.edit", preserve="errors");

		fw.redirect(action="admin:setting.default");
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