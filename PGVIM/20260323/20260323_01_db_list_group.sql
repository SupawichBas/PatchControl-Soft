INSERT INTO db_list_group
(group_code, "sequence", description, parent_group_code, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, can_insert, can_delete, can_edit, system_control)
VALUES('PoDocTypePO', NULL, 'doc type สำหรับรายงาน PORP07', NULL, true, 'Script', current_timestamp, 'Migrate', null, null, null, false, false, false, false);



INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng)
VALUES('PoDocTypePO', '-', 'ทั้งหมด', NULL, NULL, 1, true, 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL, 'secondary', NULL, NULL, NULL, NULL);

INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng)
VALUES('PoDocTypePO', 'PO', 'ใบสั่ง', NULL, NULL, 2, true, 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL, 'secondary', NULL, NULL, NULL, NULL);

INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng)
VALUES('PoDocTypePO', 'CO', 'สัญญา', NULL, NULL, 3, true, 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL, 'secondary', NULL, NULL, NULL, NULL);



INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', '-', 'EN', 'ALL', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', '-', 'TH', 'ทั้งหมด', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);

INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', 'PO', 'EN', 'Order', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', 'PO', 'TH', 'ใบสั่ง', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);

INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', 'CO', 'EN', 'Contract', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PoDocTypePO', 'CO', 'TH', 'สัญญา', 'Script', current_timestamp, 'Migrate', NULL, NULL, NULL);
