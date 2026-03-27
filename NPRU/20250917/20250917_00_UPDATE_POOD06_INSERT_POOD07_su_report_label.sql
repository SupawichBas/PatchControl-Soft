UPDATE su_report_label
SET label_name='เลขที่ใบขออนุมัติจัดซื้อ/จ้าง', system_code='ERP', module_code='PO'
WHERE program_code='POOD06' AND field_name='ref_doc_no' AND language_code='EN';
UPDATE su_report_label
SET label_name='เลขที่ใบขออนุมัติจัดซื้อ/จ้าง', system_code='ERP', module_code='PO'
WHERE program_code='POOD06' AND field_name='ref_doc_no' AND language_code='TH';


INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, updated_by, updated_date, updated_program)
VALUES('POOD07', 'receipt_code', 'EN', 'เลขที่เอกสารตั้งหนี้/เลขที่ใบเสร็จรับเงิน', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, updated_by, updated_date, updated_program)
VALUES('POOD07', 'receipt_code', 'TH', 'เลขที่เอกสารตั้งหนี้/เลขที่ใบเสร็จรับเงิน', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');
