UPDATE su_report_label
SET label_name='ตั้งแต่เลขที่ใบรายงานผลพิจารณาจัดซื้อ/จ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='PORP01' AND field_name='P_DocNo' AND language_code='TH';
UPDATE su_report_label
SET label_name='ตั้งแต่วันที่ใบรายงานผลพิจารณาจัดซื้อ/จ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='PORP01' AND field_name='P_Date' AND language_code='TH';
UPDATE su_report_label
SET label_name='เลขที่ใบรายงานผลพิจารณาจัดซื้อ/จ้าง', system_code='ERP', module_code='PO', created_by=NULL, created_date=NULL, created_program=NULL, updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='PORP01' AND field_name='PoNo' AND language_code='TH';
