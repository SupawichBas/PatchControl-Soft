INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('2505PO150002', 'PORP12', '2505PO150000', 'ERP', 'far fa-circle fa-xs', true, 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL, NULL);
INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('2505PO150003', 'PORP13', '2505PO150000', 'ERP', 'far fa-circle fa-xs', true, 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL, NULL);
INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('2505PO150004', 'PORP14', '2505PO150000', 'ERP', 'far fa-circle fa-xs', true, 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL, NULL);


INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150002', 'EN', 'รายงานแผนการจัดซื้อ/จัดจ้าง', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150002', 'TH', 'รายงานแผนการจัดซื้อ/จัดจ้าง', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150003', 'EN', 'รายงานการแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150003', 'TH', 'รายงานการแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150004', 'EN', 'รายงานขอซื้อขอจ้าง', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('2505PO150004', 'TH', 'รายงานขอซื้อขอจ้าง', 'ERP', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);


INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ADMIN', '2505PO150002', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ALL', '2505PO150002', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_CENTER', '2505PO150002', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_USER', '2505PO150002', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);

INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ADMIN', '2505PO150003', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ALL', '2505PO150003', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_CENTER', '2505PO150003', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_USER', '2505PO150003', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);

INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ADMIN', '2505PO150004', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_ALL', '2505PO150004', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_CENTER', '2505PO150004', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('PO_USER', '2505PO150004', 'Script', current_timestamp, 'Migrate_MenuPO_20260302', NULL, NULL, NULL);