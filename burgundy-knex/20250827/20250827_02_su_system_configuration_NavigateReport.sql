UPDATE su_system_configuration
SET configuration_value='https://burgundy-uat.knex.softsquaregroup.app/empty/navigate/', updated_date=current_timestamp
WHERE configuration_group_code='NavigateReport' and configuration_name='NavigateReport';
