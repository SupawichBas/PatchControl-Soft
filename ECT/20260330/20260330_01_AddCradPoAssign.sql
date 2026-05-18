INSERT INTO db_parameter
(pgm_setup, parameter_name, parameter_value, order_seq, remark, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('PO', 'Role_Card_PoAssignTOR', 'PO_APPROVE,PO_STAFF', 1, 'Card มอบหมายงาน TOR', 'Script', '2026-03-27 11:13:52.168', 'Script', 'Script', '2026-03-27 11:13:52.168', 'Script', NULL);


UPDATE db_parameter
SET parameter_value='PO_APPROVE,PO_USER,PO_CENTER,PO_STAFF', order_seq=1, remark='Permission PO_APPROVE Dashbord PO', created_by='Script', created_date='2026-02-09 17:30:50.729', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, "version"=NULL
WHERE pgm_setup='PO' AND parameter_name='PermissionDashbordPO';




INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('DSQY00', 'PoApprove.ShowSession4', 'EN', 'มอบหมายงาน', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('DSQY00', 'PoApprove.ShowSession4', 'TH', 'มอบหมายงาน', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('ALL', 'Tab.PoAssignTOR', 'EN', 'มอบหมายงาน', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('ALL', 'Tab.PoAssignTOR', 'TH', 'มอบหมายงาน', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('ALL', 'Tab.PoAssignTORAgain', 'EN', 'มอบหมายงานอีกครั้ง', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('ALL', 'Tab.PoAssignTORAgain', 'TH', 'มอบหมายงานอีกครั้ง', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('DSQY00', 'PoApprove.EmpName', 'EN', 'เจ้าหน้าที่พัสดุ', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('DSQY00', 'PoApprove.EmpName', 'TH', 'เจ้าหน้าที่พัสดุ', 'ERP', 'DS', 'Script', '2026-03-27 14:48:57.272', 'Migrate', 'Script', '2026-03-27 14:48:57.272', 'Migrate', NULL);




