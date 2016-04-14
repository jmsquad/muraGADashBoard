component persistent='false' accessors='true' output='false' extends='controller' {
	property settingService;
	property gaAnalyticsObject;
	property settings;

	public any function before(required rc){
		param name="arguments.rc.startrow" default="1";
		param name="arguments.rc.keywords" default="";
		param name="arguments.rc.limit" default="10";
		param name="arguments.rc.threshold" default="1";
		param name="arguments.rc.siteID" default="";
		param name="session.startDate" default="#now()#";
		param name="session.stopDate" default="#now()#";
		param name="arguments.rc.membersOnly" default="false";
		param name="arguments.rc.visitorStatus" default="All";
		param name="arguments.rc.contentID" default="";
		param name="arguments.rc.direction" default="";
		param name="arguments.rc.orderby" default="";
		param name="arguments.rc.page" default="1";
		param name="arguments.rc.span" default="#session.dashboardSpan#";
		param name="arguments.rc.spanType" default="d";
		param name="arguments.rc.startDate" default="#dateAdd('#rc.spanType#',-rc.span,now())#";
		param name="arguments.rc.stopDate" default="#now()#";
		param name="arguments.rc.newSearch" default="false";
		param name="arguments.rc.startSearch" default="false";
		param name="arguments.rc.returnurl" default="";
		param name="arguments.rc.layout" default="";
		param name="arguments.rc.ajax" default="";

		super.before(rc);
		setSettings(getSettingService().get()[1]);
		if ( len(getSettings().getSettingID()) GT 0 ) {
			setGAAnalyticsObject(
				createObject("component","muraGADashboard.includes.model.gaAnalytics")
					.init(
						application_name=getSettings().getApplication_name(),
						service_account_email=getSettings().getService_Account_Email(),
						key_file_name=getSettings().getKey_File_Name(),
						debugging=false
					)
			);
		}
		if ((not listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(arguments.rc.siteid).getPrivateUserPoolID()#;0') and not listFind(session.mura.memberships,'S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000000',arguments.rc.siteid))
			secure(arguments.rc);

		if (not LSisDate(arguments.rc.startDate) and not LSisDate(session.startDate))
			session.startdate=now();

		if (not LSisDate(arguments.rc.stopDate) and not LSisDate(session.stopDate))
			session.stopdate=now();

		if (arguments.rc.startSearch and LSisDate(arguments.rc.startDate))
			session.startDate=rc.startDate;

		if (arguments.rc.startSearch and LSisDate(arguments.rc.stopDate))
			session.stopDate=rc.stopDate;

		if (arguments.rc.newSearch) {
			session.stopDate=now();
			session.startDate=now();
		}
	}

	// *********************************  PAGES  *******************************************
	public any function default(required struct rc) {
		param name="rc.setup" default=false;

		fw.setLayout('blank',true);
		if ( len(getSettings().getSettingID()) GT 0 ) {
			rc.setup = true;
			local.session7Days = sessionByTimeSpanAreaChart(chartDivName='sessions7Days',startDate='7daysAgo');
			local.topPages7Days = pageSessionsTable(
				dataHeader='Page Path',
				dataValue='Pageviews',
				tableDivName='topPages7Days',
				startDate='7daysAgo',
				metrics='ga:pageviews',
				dimensions='ga:pagePath',
				maxResults='5',
				rc=rc
			);
			local.topLandingPages7Days = pageSessionsTable(
				dataHeader='Landing Page Path',
				dataValue='Entrances',
				tableDivName='topLandingPages7Days',
				startDate='7daysAgo',
				metrics='ga:entrances',
				dimensions='ga:pagePath',
				maxResults='5',
				rc=rc
			);
			local.topExitPages7Days = pageSessionsTable(
				dataHeader='Exit Page Path',
				dataValue='Exits',
				tableDivName='topExitPages7Days',
				startDate='7daysAgo',
				metrics='ga:exits',
				dimensions='ga:pagePath',
				maxResults='5',
				rc=rc
			);
			local.topTrafficSource = pageSessionsTable(
				dataHeader='Traffic Source',
				tableDivName='topTrafficSource',
				startDate='30daysAgo',
				metrics='ga:sessions',
				dimensions='ga:source',
				maxResults='5',
				rc=rc,
				links=false
			);
			local.topTrafficChannels = pageSessionsTable(
				dataHeader='Traffic Channels',
				dataValue='Organic Search/AdClicks',
				tableDivName='topTrafficChannels',
				startDate='30daysAgo',
				metrics='ga:organicSearches,ga:adClicks,ga:pageviewsPerSession',
				dimensions='ga:source',
				maxResults='5',
				rc=rc,
				links=false
			);
			// Setup the javascript that will run the charts
			savecontent variable='rc.googleChartJS' {
				writeOutput(googleChartWrapperBegin());
				writeOutput(local.topPages7Days);
				writeOutput(local.session7Days);
				writeOutput(local.topLandingPages7Days);
				writeOutput(local.topExitPages7Days);
				writeOutput(local.topTrafficSource);
				writeOutput(local.topTrafficChannels);
				writeOutput(googleChartWrapperEnd());
			};
		}
	}

	// ========================== Charts ======================================

	private string function sessionByTimeSpanAreaChart(string dataHeader='Date',string dataValue='Sessions',required string chartDivName,required string startDate,string endDate='today') {
		local.gaResults = getGAAnalyticsObject().getData(tableId='ga:#getSettings().getProfileID()#',metrics='ga:sessions',dimensions='ga:date',startDate=arguments.startDate,endDate=arguments.endDate);
		savecontent variable='local.chartJS' {writeOutput("
		google.charts.setOnLoadCallback(draw#arguments.chartDivName#);
		function draw#arguments.chartDivName#() {
			var dataTable = new google.visualization.DataTable();
			dataTable.addColumn('string','#arguments.dataHeader#');
			dataTable.addColumn('number','#arguments.dataValue#');
			dataTable.addColumn({type:'string',role:'tooltip'});
			dataTable.addRows([");
			for ( local.i=1;local.i LTE arrayLen(local.gaResults['rows']);local.i++ ) {
				local.data = local.gaResults['rows'][local.i];
				writeOutput("['#getDate(data[1],"dd")#',#data[2]#,'#data[2]# #arguments.dataValue# on #getDate(data[1],"ddd dd")#']#(local.i NEQ arrayLen(local.gaResults['rows'])?',':'')#");
			};
	writeOutput("]);
			var options = {
				hAxis: {title: '#arguments.dataHeader#'},
				vAxis: {
					title: '#arguments.dataValue#',
					minValue: 0
				},
				tooltip: {isHtml: true},
				width: 700,
				height: 157
			};
			var chart = new google.visualization.AreaChart(document.getElementById('#arguments.chartDivName#'));
			chart.draw(dataTable,options);
		}");
		};
		return local.chartJS;
	}

	private string function pageSessionsTable(required string dataHeader,string dataValue='Sessions',required string tableDivName,required string startDate,string endDate='today',required string metrics,required string dimensions,required string maxResults,required rc,boolean links=true) {
		local.gaResults = getGAAnalyticsObject().getData(tableId='ga:#getSettings().getProfileID()#',metrics=arguments.metrics,dimensions=arguments.dimensions,sort='-#arguments.metrics#',startDate=arguments.startDate,endDate=arguments.endDate,maxResults=arguments.maxResults);
		savecontent variable='local.chartJS' {writeOutput("
		google.charts.setOnLoadCallback(draw#arguments.tableDivName#);
		function draw#arguments.tableDivName#() {
			var data = google.visualization.arrayToDataTable([
					['#arguments.dataHeader#','#arguments.dataValue#'],");
					for ( local.i=1;local.i LTE arrayLen(local.gaResults['rows']);local.i++ ) {
						local.data = local.gaResults['rows'][local.i];
						writeOutput("['#(arguments.links? getTitle(data[1],rc):data[1])#',#data[2]#]#(local.i NEQ arrayLen(local.gaResults['rows'])?',':'')#");
					};
				writeOutput("]);
				var cssClassName = {
					'headerRow': 'headerRow',
					'tableRow': 'tableRow',
					'oddTableRow': 'oddTableRow',
					'selecteTableRow': 'selectedTableRow',
					'hoverTableRow': 'hoverTableRow',
					'headerCell': 'headerCell',
					'tableCell': 'tableCell',
					'rowNumberCell': 'rownNumberCell'
				};

				var options = {
					'showRowNumber': false,
					'width': '100%',
					'height': '100%',
					'allowHtml': true,
					'alternatingRowStyle': true,
					'cssClassNames': cssClassName
				};
				var table = new google.visualization.Table(document.getElementById('#arguments.tableDivName#'));
				table.draw(data,options);
			}");
		};
		return local.chartJS;
	}

	private string function googleChartWrapperBegin() {
		saveContent variable='local.googleJS' {writeOutput('
			<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
			<script type="text/javascript">
				// Javascript Generated by Mura GA Dashboard Plugin:dashboard controller
				google.charts.load("current",{"packages":["corechart","table"]});');
		};
		return local.googleJS;
	}

	private string function googleChartWrapperEnd() {
		return '</script>';
	}

	private string function getTitle(string path,rc) {
		local.bean = rc.$.getServiceFactory().getBean('contentManager').getActiveContentByFilename(arguments.path, session.siteid);
		return (len(local.bean.getTitle()) ? encodeForJavaScript('<a href="#rc.$.createHREF(filename=arguments.path)#" target="new">#local.bean.getTitle()#</a>') : arguments.path );
	}

	private string function getDate(date,format) {
		return dateFormat(rereplace(arguments.date,'(\d{4})(\d{2})(\d{2})','\1/\2/\3'),arguments.format);
	}
}
