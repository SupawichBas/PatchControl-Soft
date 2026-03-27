INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD10', 'total_fine_disc_amt', 'TH', 'ส่วนลด/ค่าปรับ', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD10', 'total_fine_disc_amt', 'EN', 'ส่วนลด/ค่าปรับ', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);

UPDATE su_report_label
SET label_name='ค่าปรับ/ส่วนลด', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2' AND language_code='TH';
UPDATE su_report_label
SET label_name='Fine/Discount', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2' AND language_code='EN';
UPDATE su_report_label
SET label_name='มีค่าปรับ/ส่วนลด', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2.1' AND language_code='TH';
UPDATE su_report_label
SET label_name='There is a fine/discount', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2.1' AND language_code='EN';
UPDATE su_report_label
SET label_name='ไม่มีค่าปรับ/ส่วนลด', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2.2' AND language_code='TH';
UPDATE su_report_label
SET label_name='No fine/discount', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD09' AND field_name='2.2' AND language_code='EN';