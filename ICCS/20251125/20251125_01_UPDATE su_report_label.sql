UPDATE su_report_label
SET label_name='( ผู้เบิกวัสดุ )', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD33' AND field_name='approve_name' AND language_code='EN';
UPDATE su_report_label
SET label_name='( ผู้เบิกวัสดุ )', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD33' AND field_name='approve_name' AND language_code='TH';

INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD33', 'PageNo', 'EN', 'Page No.', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD33', 'PageNo', 'TH', 'หน้าที่', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
