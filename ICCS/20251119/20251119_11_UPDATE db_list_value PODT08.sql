UPDATE db_list_value
SET parent_value = 'POOD16'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD16';

UPDATE db_list_value
SET parent_value = 'POOD17'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD17';

UPDATE db_list_value
SET parent_value = 'POOD18'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD18';

UPDATE db_list_value
SET parent_value = 'POOD19'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD19';

UPDATE db_list_value
SET parent_value = 'POOD20'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD20';

UPDATE db_list_value
SET parent_value = 'POOD21'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD21';

UPDATE db_list_value
SET parent_value = 'POOD22'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD22';

UPDATE db_list_value
SET parent_value = 'POOD23'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD23';

UPDATE db_list_value
SET parent_value = 'POOD24'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD24';

UPDATE db_list_value
SET parent_value = 'POOD25'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD25';

UPDATE db_list_value
SET parent_value = 'POOD26'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD26';

UPDATE db_list_value
SET parent_value = 'POOD27'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD27';

UPDATE db_list_value
SET parent_value = 'POOD28'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD28';

UPDATE db_list_value
SET parent_value = 'POOD29'
WHERE group_code = 'TypeReportPODT08' AND value = 'POOD29';



INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active)
VALUES('TypeReportPODT08', 'POOD30', 'ข้อตกลง', NULL, 'POOD34', 0, true);



INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text)
VALUES('TypeReportPODT08', 'POOD30', 'EN', 'ข้อตกลง');
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text)
VALUES('TypeReportPODT08', 'POOD30', 'TH', 'ข้อตกลง');
