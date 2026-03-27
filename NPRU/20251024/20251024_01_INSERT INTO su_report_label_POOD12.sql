INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD12', 'header_2_1', 'EN', 'ดำเนินการโดยวิธีเฉพาะเจาะจงเนื่องจากการจัดซื้อจัดจ้างพัสดุที่มีการผลิต จำหน่าย ก่อสร้าง หรือให้บริการทั่วไป และมีวงเงินในการจัดซื้อจัดจ้างครั้งหนึ่งไม่เกินวงเงินตามที่กำหนดในกฏกระทรวง', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD12', 'header_2_1', 'TH', 'ดำเนินการโดยวิธีเฉพาะเจาะจงเนื่องจากการจัดซื้อจัดจ้างพัสดุที่มีการผลิต จำหน่าย ก่อสร้าง หรือให้บริการทั่วไป และมีวงเงินในการจัดซื้อจัดจ้างครั้งหนึ่งไม่เกินวงเงินตามที่กำหนดในกฏกระทรวง', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD12', 'header_3_1', 'EN', 'การพิจารณาคัคเลือกข้อเสนอโดยใช้เกณฑ์ราคา', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('POOD12', 'header_3_1', 'TH', 'การพิจารณาคัคเลือกข้อเสนอโดยใช้เกณฑ์ราคา', 'ERP', 'PO', NULL, NULL, NULL, NULL, NULL, NULL);



UPDATE su_report_label
SET label_name='ราคากลางของพัสดุที่จะจ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_1' AND language_code='EN';
UPDATE su_report_label
SET label_name='ราคากลางของพัสดุที่จะจ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_1' AND language_code='TH';
UPDATE su_report_label
SET label_name='วิธีที่จะจ้าง และเหตุผลที่ต้องจ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_2' AND language_code='EN';
UPDATE su_report_label
SET label_name='วิธีที่จะจ้าง และเหตุผลที่ต้องจ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_2' AND language_code='TH';
UPDATE su_report_label
SET label_name='หลักเกณฑ์การพิจราณาคัดเลือกข้อเสนอ', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_3' AND language_code='EN';
UPDATE su_report_label
SET label_name='หลักเกณฑ์การพิจราณาคัดเลือกข้อเสนอ', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='POOD12' AND field_name='header_3' AND language_code='TH';
