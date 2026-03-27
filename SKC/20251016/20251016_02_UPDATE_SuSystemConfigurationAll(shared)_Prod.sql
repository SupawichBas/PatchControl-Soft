--ApproveAPI
UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'6001', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'PORTALIDTaWorkFlowAPI';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'8D7C6B5A-FEB3-4116-A5D7-A575FD045A80', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'AuthTokenTaWorkFlowApproveAPI';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'400000304', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'ServiceCategoryId';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'4000006032', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'TemplateId';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_date_400000907', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_from_date';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_date_400000908', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_to_date';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000915', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_mobile_no';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000913', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_package_code';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000905', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_document_id';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000906', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_country';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000912', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_name_passport';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000910', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_name';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000911', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_email';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_400000909', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_code';

--CancelledAPI
UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'8D7C6B5A-FEB3-4116-A5D7-A575FD045A80', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'AuthTokenTaWorkFlowCancelledAPI';