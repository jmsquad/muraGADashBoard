component accessors=true extends='muraGADashboard.includes.model.baseClasses.baseService'{

	property settingDAO;

	function init( beanFactory ) {
		variables.beanFactory = beanFactory;
		return this;
	}

	public any function delete(required any bean) {
		return getSettingDAO().delete(bean);
	}

	public array function get() {
		return getSettingDAO().get(argumentCollection=arguments);
	}

	public any function getNew() {
		return variables.beanFactory.getBean('setting');
	}

	public any function save(required any bean) {
		return getSettingDAO().save(bean);
	}
}
