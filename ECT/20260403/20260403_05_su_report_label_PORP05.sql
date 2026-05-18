INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PORP05', 'PRDate', 'EN', 'วันที่ขออนุญาตซื้อ/จ้าง', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PORP05', 'PRDate', 'TH', 'วันที่ขออนุญาตซื้อ/จ้าง', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);




UPDATE su_report_label
SET label_name='วันที่ขออนุญาตซื้อ/จ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='PORP05' AND field_name='PRDate' AND language_code='EN';
UPDATE su_report_label
SET label_name='วันที่ขออนุญาตซื้อ/จ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='PORP05' AND field_name='PRDate' AND language_code='TH';
