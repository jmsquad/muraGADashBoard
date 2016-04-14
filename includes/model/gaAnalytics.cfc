component output="false" accessors="true" displayname=""  {

	property string application_name;
	property string libFolder;
	property string key_file_location;
	property string service_account_email;
	property array jarArray;
	property GoogleCredential;
	property GoogleCredential_Builder;
	property GoogleNetHttpTransport;
	property HttpTransport;
	property javaLoader;
	property JsonFactory;
	property GsonFactory;
	property Analytics_Builder;
	property AnalyticsScopes;
	property Accounts;
	property GaData;
	property Profiles;
	property Webproperties;
	property GsonJsonWriter;
	property File;
	property Collections;
	property analytics;
	property Debugging;
	property profilesFound;

	include '../fw1config.cfm'; // framework variables

	public function init(required string application_name,required string service_account_email,required string key_file_name,boolean debugging=false){
		// NOTE: The Jars are loaded from the javaLoader
		applicationSetup();
		setApplication_Name(arguments.application_name);
		setGoogleCredential(initializeJava("com.google.api.client.googleapis.auth.oauth2.GoogleCredential"));
		setGoogleCredential_Builder(initializeJava("com.google.api.client.googleapis.auth.oauth2.GoogleCredential$Builder"));
		setGoogleNetHttpTransport(initializeJava("com.google.api.client.googleapis.javanet.GoogleNetHttpTransport"));
		setHttpTransport(initializeJava("com.google.api.client.http.HttpTransport"));
		setJsonFactory(initializeJava("com.google.api.client.json.JsonFactory"));
		setGsonFactory(initializeJava("com.google.api.client.json.gson.GsonFactory"));
		setGsonJsonWriter(initializeJava("com.google.gson.stream.JsonWriter"));
		setAnalytics_Builder(initializeJava("com.google.api.services.analytics.Analytics$Builder"));
		setAnalyticsScopes(initializeJava("com.google.api.services.analytics.AnalyticsScopes"));
		setAccounts(initializeJava("com.google.api.services.analytics.model.Accounts"));
		setGaData(initializeJava("com.google.api.services.analytics.model.GaData"));
		setProfiles(initializeJava("com.google.api.services.analytics.model.Profiles"));
		setWebproperties(initializeJava("com.google.api.services.analytics.model.Webproperties"));
		setFile(initializeJava("java.io.File"));
		setCollections(initializeJava("java.util.Collections"));
		setService_account_email(arguments.service_account_email);
		setKey_file_location(expandPath("/#variables.framework.package#/includes/keyfiles/#arguments.key_file_name#"));
		setDebugging(arguments.debugging);
		initializeAnalytics();
		setAssociatedProfiles();
		return this;
	}

	public void function applicationSetup() {
		setLibFolder(expandPath("/Mura_multisite/plugins/#variables.framework.package#/includes/lib"));
		// This is the list of jars that we will be using to grab the data, this is feed to the application.cfc
		setJarArray([
			'#getLibFolder()#/google-api-client-1.21.0.jar',
			'#getLibFolder()#/google-api-services-analytics-v3-rev123-1.21.0.jar',
			'#getLibFolder()#/google-http-client-1.21.0.jar',
			'#getLibFolder()#/google-http-client-gson-1.21.0.jar',
			'#getLibFolder()#/google-oauth-client-1.21.0.jar',
			'#getLibFolder()#/gson-2.1.jar'
		]);
		setJavaLoader(CreateObject("component", "mura.javaloader.JavaLoader").init(getJarArray()));
	}

	public struct function getData(required string tableId,required string metrics,string dimensions,required string startDate,required string endDate,string sort,string filters,numeric maxResults=25) {
		try {
				local.request = getAnalytics().data().ga().get(
					arguments.tableId,
					arguments.startDate,
					arguments.endDate,
					arguments.metrics);
				if ( structKeyExists(arguments,'dimensions') )
					local.request.setDimensions(arguments.dimensions);
				if ( structKeyExists(arguments,'sort') )
					local.request.setSort(arguments.sort);
				if ( structKeyExists(arguments,'filters') )
					local.request.setFilters(arguments.filters);
				local.request.setMaxResults(arguments.maxResults);
				return local.request.execute();
			} catch (any e) {
				handleErrors("getData","Error fetching data",e);
			}
	}

	public struct function getRealTimeData(required string tableId,required string metrics,string dimensions,string sort,string filters,numeric maxResults=25) {
		try {
			local.request = getAnalytics().data().realtime().get(
				arguments.tableId,
				arguments.metrics);
			if ( structKeyExists(arguments,'dimensions') )
				local.request.setDimensions(arguments.dimensions);
			if ( structKeyExists(arguments,'sort') )
				local.request.setSort(arguments.sort);
			if ( structKeyExists(arguments,'filters') )
				local.request.setFilters(arguments.filters);
			return local.request.setMaxResults(arguments.maxResults);
		} catch (any e) {
			handleErrors("getRealTimeData","Error fetching data",e);
		}
	}

	private void function initializeAnalytics() {
		local.httpTransport = getGoogleNetHttpTransport().newTrustedTransport();
		local.JSON_FACTORY = getGsonFactory().getDefaultInstance();
		local.key_file_location = getFile().init(getKey_File_Location());
		try {
			local.credential = getGoogleCredential_Builder()
				.setTransport(local.httpTransport)
				.setJsonFactory(local.JSON_FACTORY)
				.setServiceAccountId(getService_account_email())
				.setServiceAccountPrivateKeyFromP12File(local.key_file_location)
				.setServiceAccountScopes(getCollections().singleton(getAnalyticsScopes().ANALYTICS_READONLY))
				.build();
		} catch (any e) {
			handleErrors(functionName='initializeAnalytics',functionDetail='Credential Object Error:',error=e);
		}
		try {
			setAnalytics(getAnalytics_Builder().init(local.httpTransport, local.JSON_FACTORY, local.credential)
				.setApplicationName(getApplication_Name())
				.build());
		} catch (any e) {
			handleErrors(functionName='initializeAnalytics',functionDetail='Analytics Object Error:',error=e);
		}
	}

	private void function setAssociatedProfiles() {
		try {
			setProfilesFound(getAnalytics().management().profiles().list("~all","~all").execute());
		} catch (any e) {
			handleErrors(functionName='getProfiles',functionDetail='Profile Error:',error=e);
		}
	}

	private any function initializeJava(required string className,boolean init=false) {
		if ( arguments.init ) {
			return getJavaLoader().create(arguments.className).init();
		} else {
			return getJavaLoader().create(arguments.className);
		}
	}

	private void function handleErrors(required string functionName,string functionDetail='',required any error) {
		if ( getDebugging() ) {
			writeDump(var=arguments.error,abort=true);
		} else {
			throw(message="#arguments.functionName#: #arguments.functionDetail# #arguments.error.message# - #arguments.error.detail#")
		}
	}
}