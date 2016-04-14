<cfoutput>
<h1>Edit Setting</h1>
<form class="form-virticle" id="SettingForm" action="#buildURL('admin:setting.save')#" method="post" enctype="multipart/form-data" onsubmit="return validateForm(this)">
<div class="tabbable tabs-left">
	<div class="tab-content">
		<div class="tab-pane active">
			<div class="fieldset">
				<input type="hidden" name="SettingID" value="#rc.form.getSettingID()#"/>
				<div class="control-group">
					<div>
						<label class="control-label" for="application_name">Application Name:</label>
						<div class="controls">
							<input type="text" data-required="true" name="application_name" id="application_name" value="#rc.form.getApplication_name()#"/>
						</div>
					</div>

					<div>
						<label class="control-label" for="service_account_email">Service Account Email:</label>
						<div class="controls">
							<input type="text" data-required="true" name="service_account_email" id="service_account_email" value="#rc.form.getService_account_email()#"/>
						</div>
					</div>

					<div>
						<label class="control-label" for="key_file_name">Key File Name:</label>
						<div class="controls">
							<input type="file" data-required="true" name="key_file_name" id="key_file_name" accept='application/x-pkcs12' value="#rc.form.getKey_file_name()#"/>
						</div>
					</div>

					<div>
						<label class="control-label" for="profileID">Profile ID:</label>
						<div class="controls">
							<input type="text" data-required="true" name="profileID" id="profileID" value="#rc.form.getProfileID()#"/>
						</div>
					</div>

					<div class="control-label" id="extraSettings">
						<input type="hidden" id="extraSettingsNumber" name="extraSettingsNumber" value="#rc.extraSettingsNumber#"/>
						<input type="button" id="addSetting" name="addSetting" value="Add Setting"/>
						<div id="settingJSON">
							<cfif structKeyExists(rc,'extraSettings')>
								<cfset num = 1/>
								<cfloop list="#structKeyList(rc.extraSettings)#" index="key">
									<div>
										<label class='control-label' for='settingName#num#'>Setting Name</label>
										<input type='text' name='settingName#num#' value="#rc['settingName'&num]#"/>
										<label class='control-label' for='settingValue#num#'>Setting Value</label>
										<input type='text' name='settingValue#num#' value="#rc['settingValue'&num]#"/>
									</div>
									<cfset num = num + 1/>
								</cfloop>
							</cfif>
						</div>
					</div>

					<label class="control-label" for="things">&nbsp;</label>
					<div class="controls">
						<input type="submit" class="btn" name="btnSubmit" value="Save"  />
						<input type="button" class="btn" name="btnCancel" value="Cancel" onclick="history.back();" />
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
<script type="text/javascript">
	number = #rc.extraSettingsNumber#;
	$('##addSetting').on('click',function(){
		number++;
		$('##settingJSON').append(extraSettings(number));
		$('##extraSettingsNumber').val(number);
	});

	function extraSettings(number){
		var html="<div><label class='control-label' for='settingName" + number + "'>Setting Name</label><div class='controls'><input type='text' name='settingName" + number + "' value=''/></div><label class='control-label' for='settingValue" + number + "'>Setting Value</label><div class='controls'><input type='text' name='settingValue" + number + "' value=''/></div></div>";
		return html;
	}

</script>
</cfoutput>

