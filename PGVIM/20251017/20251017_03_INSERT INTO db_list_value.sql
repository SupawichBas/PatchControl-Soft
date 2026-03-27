INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD30', 'รูปแบบสัญญาจ้างทำของ', NULL,'POOD20', 15, true, 'Script', current_timestamp, 'Migrate');
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD31', 'รูปแบบสัญญาเช่าเครื่องถ่ายเอกสาร', NULL,'POOD29', 16, true, 'Script', current_timestamp, 'Migrate');


INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD30', 'EN', 'รูปแบบสัญญาจ้างทำของ', 'Script', current_timestamp, 'Migrate');
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD30', 'TH', 'รูปแบบสัญญาจ้างทำของ', 'Script', current_timestamp, 'Migrate');
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD31', 'EN', 'รูปแบบสัญญาเช่าเครื่องถ่ายเอกสาร', 'Script', current_timestamp, 'Migrate');
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('TypeReportPODT08', 'POOD31', 'TH', 'รูปแบบสัญญาเช่าเครื่องถ่ายเอกสาร', 'Script', current_timestamp, 'Migrate');