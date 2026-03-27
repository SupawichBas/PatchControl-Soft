INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD09', 'detail1_PO', 'EN', 'ตามใบสั่งซื้อ/สั่งจ้าง เลขที่', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD09', 'detail1_PO', 'TH', 'ตามใบสั่งซื้อ/สั่งจ้าง เลขที่', 'ERP', 'PO', NULL, NULL, NULL, 'Script', '2025-05-26 11:04:56.535', 'Script');
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD09', 'detail1_CO', 'EN', 'ตามสัญญา เลขที่', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD09', 'detail1_CO', 'TH', 'ตามสัญญา เลขที่', 'ERP', 'PO', NULL, NULL, NULL, 'Script', '2025-05-26 11:04:56.535', 'Script');


UPDATE su_report_label
SET label_name='ตามใบรายงานผลพิจารณาซื้อ/จ้าง เลขที่', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by='Script', updated_date='2025-05-26 11:04:56.535', updated_program='Script'
WHERE program_code='POOD09' AND field_name='detail1' AND language_code='TH';
