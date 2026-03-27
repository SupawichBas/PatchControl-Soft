--ApproveAPI
UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'8101', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'PORTALIDTaWorkFlowAPI';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'F14C51FD-CF1E-4732-B57E-6E20D932E598', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'AuthTokenTaWorkFlowApproveAPI';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'300000005', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'ServiceCategoryId';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'300000903', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'TemplateId';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_date_300000914', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_from_date';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_date_300000915', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_to_date';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000921', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_mobile_no';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000920', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_package_code';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000912', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_document_id';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000913', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_country';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000918', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_name_passport';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000917', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_name';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000919', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_email';

UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'udf_sline_300000916', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'udf_sline_user_code';

--CancelledAPI
UPDATE SuSystemConfigurationAll
SET ConfigurationValue=N'F14C51FD-CF1E-4732-B57E-6E20D932E598', UpdatedBy=N'Script', UpdatedDate= current_timestamp, UpdatedProgram=N'Script'
WHERE ConfigurationGroupCode=N'TA' and ConfigurationName=N'AuthTokenTaWorkFlowCancelledAPI';