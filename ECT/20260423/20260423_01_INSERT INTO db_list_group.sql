INSERT INTO db_list_group
(group_code, "sequence", description, parent_group_code, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, can_insert, can_delete, can_edit, system_control, "version")
VALUES('PoDocType', NULL, 'ประเภทเอกสาร PO', NULL, true, 'Script', '2026-04-22 18:05:19.123', 'Migrate', 'Script', '2026-04-22 18:05:19.123', 'Migrate', false, false, false, false, NULL);



INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'TR', 'การแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', NULL, NULL, 1, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'PC', 'รายงานขอซื้อขอจ้าง', NULL, NULL, 2, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'PR', 'รายงานผลพิจารณา', NULL, NULL, 3, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'PO', 'สั่งซื้อ/สั่งจ้าง', NULL, NULL, 4, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'CO', 'สัญญา', NULL, NULL, 5, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'RE', 'ตรวจรับ', NULL, NULL, 6, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO db_list_value
(group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program, color, icon, interface_mapping_code, data_type, description_eng, "version")
VALUES('PoDocType', 'GO', 'คืนหลักประกัน', NULL, NULL, 7, true, 'Script', '2025-11-12 15:41:13.340', 'Migrate', 'Script', '2025-11-12 15:41:13.340', 'Migrate', NULL, NULL, NULL, NULL, NULL, NULL);




INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'TR', 'TH', 'การแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'TR', 'EN', 'การแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PC', 'TH', 'รายงานขอซื้อขอจ้าง', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PC', 'EN', 'รายงานขอซื้อขอจ้าง', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PR', 'TH', 'รายงานผลพิจารณา', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PR', 'EN', 'รายงานผลพิจารณา', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PO', 'TH', 'สั่งซื้อ/สั่งจ้าง', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'PO', 'EN', 'สั่งซื้อ/สั่งจ้าง', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'CO', 'TH', 'สัญญา', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'CO', 'EN', 'สัญญา', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'RE', 'TH', 'ตรวจรับ', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'RE', 'EN', 'ตรวจรับ', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'GO', 'TH', 'คืนหลักประกัน', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);
INSERT INTO db_list_value_lang
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PoDocType', 'GO', 'EN', 'คืนหลักประกัน', 'Script', '2026-04-22 18:13:31.183', 'Migrate', 'Script', '2026-04-22 18:13:31.183', 'Migrate', NULL);