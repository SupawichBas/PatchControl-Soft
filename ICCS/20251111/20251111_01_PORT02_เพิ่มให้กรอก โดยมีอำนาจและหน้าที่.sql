
ALTER TABLE erp.po_committee_type ADD committee_powers_and_duties varchar(1000) NULL;
COMMENT ON COLUMN erp.po_committee_type.committee_powers_and_duties IS 'โดยมีอำนาจและหน้าที่';



INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORT02', 'PoCommitteeType.CommitteePowersAndDuties', 'EN', 'Powers And Duties', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORT02', 'PoCommitteeType.CommitteePowersAndDuties', 'TH', 'โดยมีอำนาจและหน้าที่', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');






UPDATE su_program_label
SET label_name='Evaluation', system_code='ERP', module_code='PO', updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.EvaluationCommittee' AND language_code='EN';
UPDATE su_program_label
SET label_name='พิจารณาผลการประกวดราคาอิเล็กทรอนิกส์', system_code='ERP', module_code='PO', updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.EvaluationCommittee' AND language_code='TH';
UPDATE su_program_label
SET label_name='Goods Receipt', system_code='ERP', module_code='PO', updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.GoodsReceiptCommittee' AND language_code='EN';
UPDATE su_program_label
SET label_name='การตรวจรับ', system_code='ERP', module_code='PO', updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.GoodsReceiptCommittee' AND language_code='TH';
UPDATE su_program_label
SET label_name='Procurement', system_code='ERP', module_code='PO', updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.ProcurementCommittee' AND language_code='EN';
UPDATE su_program_label
SET label_name='การซื้อการจ้าง', system_code='ERP', module_code='PO',updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.ProcurementCommittee' AND language_code='TH';
UPDATE su_program_label
SET label_name='Tor Draft', system_code='ERP', module_code='PO',updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.TorDraftCommittee' AND language_code='EN';
UPDATE su_program_label
SET label_name='ร่าง TOR และราคากลาง', system_code='ERP', module_code='PO',updated_by='Script', updated_date=current_timestamp, updated_program='Migrate'
WHERE program_code='PORT02' AND field_name='PoCommitteeType.TorDraftCommittee' AND language_code='TH';
