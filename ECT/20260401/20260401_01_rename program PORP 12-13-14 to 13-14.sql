-- rename program PORP 12-13-14 to 13-14-15 and add new program PORP12
INSERT INTO su_program
(program_code, program_name, program_path, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, ds_program_code, "version")
VALUES('PORP15', 'รายงานขอซื้อขอจ้าง', '/po/porp15', 'ERP', 'PO', 'Script', '2026-02-26 17:00:27.721', 'Migrate', NULL, NULL, NULL, NULL, NULL);

INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('2505PO150060', 'PORP12', '2505PO150000', 'ERP', 'far fa-circle fa-xs', true, 'Script', '2025-09-23 14:57:46.616', 'Migrate_MenuPO_20250923', NULL, NULL, NULL, NULL);

INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150060', 'TH', 'รายงานทะเบียนคุมการจัดซื้อจัดจ้าง', 'ERP', 'Script', '2025-09-23 15:38:31.102', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150060', 'EN', 'รายงานทะเบียนคุมการจัดซื้อจัดจ้าง', 'ERP', 'Script', '2025-09-23 15:38:31.102', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);



UPDATE su_program
SET program_name='รายงานทะเบียนคุมการจัดซื้อจัดจ้าง', program_path='/po/porp12', system_code='ERP', module_code='PO', created_by='Script', created_date='2026-02-26 17:00:27.721', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, ds_program_code=NULL, "version"=NULL
WHERE program_code='PORP12';
UPDATE su_program
SET program_name='รายงานแผนการจัดซื้อ/จัดจ้าง', program_path='/po/porp13', system_code='ERP', module_code='PO', created_by='Script', created_date='2026-02-26 17:00:27.721', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, ds_program_code=NULL, "version"=NULL
WHERE program_code='PORP13';
UPDATE su_program
SET program_name='รายงานการแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', program_path='/po/porp14', system_code='ERP', module_code='PO', created_by='Script', created_date='2026-02-26 17:00:27.721', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, ds_program_code=NULL, "version"=NULL
WHERE program_code='PORP14';


UPDATE su_menu
SET program_code='PORP13', main_menu='2505PO150000', system_code='ERP', icon='far fa-circle fa-xs', active=true, created_by='Script', created_date='2025-09-23 14:57:46.616', created_program='Migrate_MenuPO_20250923', updated_by=NULL, updated_date=NULL, updated_program=NULL, "version"=NULL
WHERE menu_code='2505PO150002';
UPDATE su_menu
SET program_code='PORP14', main_menu='2505PO150000', system_code='ERP', icon='far fa-circle fa-xs', active=true, created_by='Script', created_date='2025-09-23 14:57:46.616', created_program='Migrate_MenuPO_20250923', updated_by=NULL, updated_date=NULL, updated_program=NULL, "version"=NULL
WHERE menu_code='2505PO150003';
UPDATE su_menu
SET program_code='PORP15', main_menu='2505PO150000', system_code='ERP', icon='far fa-circle fa-xs', active=true, created_by='Script', created_date='2025-09-23 14:57:46.616', created_program='Migrate_MenuPO_20250923', updated_by=NULL, updated_date=NULL, updated_program=NULL, "version"=NULL
WHERE menu_code='2505PO150004';




INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('ALL', '2505PO150060', 'Script', '2025-09-23 16:00:33.509', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ADMIN', '2505PO150060', 'Script', '2025-09-23 16:00:33.509', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ALL', '2505PO150060', 'Script', '2025-09-23 16:00:33.509', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_CENTER', '2505PO150060', 'Script', '2025-09-23 16:00:33.509', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_USER', '2505PO150060', 'Script', '2025-09-23 16:00:33.509', 'Migrate_MenuPO_20250923', NULL, NULL, NULL);